#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import CYAJL
import Venice

public struct JSONSerializerError : Error, CustomStringConvertible {
    public let description: String
}

final class JSONSerializer {
    private var ordering: Bool
    private var buffer: String = ""
    private var bufferSize: Int = 0

    private var handle: yajl_gen?

    convenience init() {
        self.init(ordering: false)
    }

    init(ordering: Bool) {
        self.ordering = ordering
        self.handle = yajl_gen_alloc(nil)
    }

    deinit {
        yajl_gen_free(handle)
    }

    func serialize(_ json: JSON, bufferSize: Int = 4096, body: (UnsafeRawBufferPointer) throws -> Void) throws {
        yajl_gen_reset(handle, nil)
        self.bufferSize = bufferSize
        try generate(json, body: body)
        try write(body: body)
    }

    private func generate(_ json: JSON, body: (UnsafeRawBufferPointer) throws -> Void) throws {
        switch json {
        case .null:
            try generateNull()
        case .bool(let bool):
            try generate(bool)
        case .double(let double):
            try generate(double)
        case .int(let int):
            try generate(int)
        case .string(let string):
            try generate(string)
        case .array(let array):
            try generate(array, body: body)
        case .object(let object):
            try generate(object, body: body)
        }

        try write(highwater: bufferSize, body: body)
    }

    private func generate(
        _ dictionary: [String: JSON],
        body: (UnsafeRawBufferPointer
    ) throws -> Void) throws {
        var status = yajl_gen_status_ok

        status = yajl_gen_map_open(handle)
        try check(status: status)

        if ordering {
            for (key, value) in dictionary.sorted(by: { $0.0 < $1.0 }) {
                try generate(key)
                try generate(value, body: body)
            }
        } else {
            for (key, value) in dictionary {
                try generate(key)
                try generate(value, body: body)
            }
        }

        status = yajl_gen_map_close(handle)
        try check(status: status)
    }

    private func generate(_ array: [JSON], body: (UnsafeRawBufferPointer) throws -> Void) throws {
        var status = yajl_gen_status_ok

        status = yajl_gen_array_open(handle)
        try check(status: status)

        for value in array {
            try generate(value, body: body)
        }

        status = yajl_gen_array_close(handle)
        try check(status: status)
    }

    private func generateNull() throws {
        try check(status: yajl_gen_null(handle))
    }

    private func generate(_ string: String) throws {
        let status: yajl_gen_status

        if string.isEmpty {
            status = yajl_gen_string(handle, nil, 0)
        } else {
            status = string.withCString { cStringPointer in
                return cStringPointer.withMemoryRebound(to: UInt8.self, capacity: string.utf8.count) {
                    yajl_gen_string(self.handle, $0, string.utf8.count)
                }
            }
        }

        try check(status: status)
    }

    private func generate(_ bool: Bool) throws {
        try check(status: yajl_gen_bool(handle, (bool) ? 1 : 0))
    }

    private func generate(_ double: Double) throws {
        let string = double.description
        let status = string.withCString { pointer in
            return yajl_gen_number(self.handle, pointer, string.utf8.count)
        }
        try check(status: status)
    }

    private func generate(_ int: Int) throws {
        try check(status: yajl_gen_integer(handle, Int64(int)))
    }

    private func check(status: yajl_gen_status) throws {
        switch status {
        case yajl_gen_keys_must_be_strings:
            throw JSONSerializerError(description: "Keys must be strings.")
        case yajl_max_depth_exceeded:
            throw JSONSerializerError(description: "Max depth exceeded.")
        case yajl_gen_in_error_state:
            throw JSONSerializerError(description: "In error state.")
        case yajl_gen_invalid_number:
            throw JSONSerializerError(description: "Invalid number.")
        case yajl_gen_no_buf:
            throw JSONSerializerError(description: "No buffer.")
        case yajl_gen_invalid_string:
            throw JSONSerializerError(description: "Invalid string.")
        case yajl_gen_status_ok:
            break
        case yajl_gen_generation_complete:
            break
        default:
            throw JSONSerializerError(description: "Unknown.")
        }
    }

    private func write(highwater: Int = 0, body: (UnsafeRawBufferPointer) throws -> Void) throws {
        var buffer: UnsafePointer<UInt8>? = nil
        var bufferLength: Int = 0

        guard yajl_gen_get_buf(handle, &buffer, &bufferLength) == yajl_gen_status_ok else {
            throw JSONSerializerError(description: "Could not get buffer.")
        }

        guard bufferLength >= highwater else {
            return
        }

        try body(UnsafeRawBufferPointer(start: buffer, count: bufferLength))
        yajl_gen_clear(handle)
    }
}
