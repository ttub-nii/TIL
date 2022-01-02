#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import Venice

public final class ReadableBuffer : Readable {
    var buffer: UnsafeRawBufferPointer
    
    public init(_ buffer: UnsafeRawBufferPointer) {
        self.buffer = buffer
    }
    
    public func read(
        _ buffer: UnsafeMutableRawBufferPointer,
        deadline: Deadline
    ) throws -> UnsafeRawBufferPointer {
        guard !buffer.isEmpty && !self.buffer.isEmpty else {
            return UnsafeRawBufferPointer(start: nil, count: 0)
        }
        
        guard let destination = buffer.baseAddress, let origin = self.buffer.baseAddress else {
            return UnsafeRawBufferPointer(start: nil, count: 0)
        }
        
        let readCount = min(buffer.count, self.buffer.count)
        memcpy(destination, origin, readCount)
        
        #if swift(>=3.2)
            let read = UnsafeRawBufferPointer(rebasing: buffer.prefix(readCount))
            self.buffer = UnsafeRawBufferPointer(rebasing: self.buffer.suffix(from: readCount))
        #else
            let read = UnsafeRawBufferPointer(buffer.prefix(readCount))
            self.buffer = self.buffer.suffix(from: readCount)
        #endif
        
        return read
    }
}

extension ReadableBuffer {
    public static var empty: ReadableBuffer = ReadableBuffer(
        UnsafeRawBufferPointer(start: nil, count: 0)
    )
}
