import Core
import IO
import Media
import Venice

public final class Request : Message {
    public typealias UpgradeConnection = (Response, DuplexStream) throws -> Void
    
    public var method: Method
    public var uri: URI
    public var version: Version
    public var headers: Headers
    public var body: Body
    
    public var storage: Storage = [:]
    public var upgradeConnection: UpgradeConnection?
    
    public init(
        method: Method,
        uri: URI,
        headers: Headers = [:],
        version: Version = .oneDotOne,
        body: Body
    ) {
        self.method = method
        self.uri = uri
        self.headers = headers
        self.version = version
        self.body = body
    }
    
    public enum Method {
        case get
        case head
        case post
        case put
        case patch
        case delete
        case options
        case trace
        case connect
        case other(String)
    }
}

extension Request {
    public convenience init(
        method: Method,
        uri: String,
        headers: Headers = [:]
    ) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            version: .oneDotOne,
            body: .empty
        )
        
        switch method {
        case .get, .head, .options, .connect, .trace:
            break
        default:
            contentLength = 0
        }
    }
    
    public convenience init(
        method: Method,
        uri: String,
        headers: Headers = [:],
        body stream: Readable
    ) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            version: .oneDotOne,
            body: .readable(stream)
        )
    }
    
    public convenience init(
        method: Method,
        uri: String,
        headers: Headers = [:],
        body write: @escaping Body.Write
    ) throws {
        self.init(
            method: method,
            uri: try URI(uri),
            headers: headers,
            version: .oneDotOne,
            body: .writable(write)
        )
    }
    
    public convenience init(
        method: Method,
        uri: String,
        headers: Headers = [:],
        body buffer: BufferRepresentable,
        timeout: Duration = 5.minutes
    ) throws {
        try self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: { stream in
                try stream.write(buffer, deadline: timeout.fromNow())
            }
        )
        
        contentLength = buffer.bufferSize
    }
    
    public convenience init<Content : EncodingMedia>(
        method: Method,
        uri: String,
        headers: Headers = [:],
        content: Content,
        timeout: Duration = 5.minutes
    ) throws {
        try self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: { writable in
                try content.encode(to: writable, deadline: timeout.fromNow())
            }
        )
        
        self.contentType = Content.mediaType
        self.contentLength = nil
        self.transferEncoding = "chunked"
    }
    
    public convenience init<Content : MediaEncodable>(
        method: Method,
        uri: String,
        headers: Headers = [:],
        content: Content,
        timeout: Duration = 5.minutes
    ) throws {
        let media = try Content.defaultEncodingMedia()
        
        try self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: { writable in
                try media.encode(content, to: writable, deadline: timeout.fromNow())
            }
        )
        
        self.contentType = media.mediaType
        self.contentLength = nil
        self.transferEncoding = "chunked"
    }
    
    public convenience init<Content : MediaEncodable>(
        method: Method,
        uri: String,
        headers: Headers = [:],
        content: Content,
        contentType mediaType: MediaType,
        timeout: Duration = 5.minutes
    ) throws {
        let media = try Content.encodingMedia(for: mediaType)
        
        try self.init(
            method: method,
            uri: uri,
            headers: headers,
            body: { writable in
                try media.encode(content, to: writable, deadline: timeout.fromNow())
            }
        )
        
        self.contentType = media.mediaType
        self.contentLength = nil
        self.transferEncoding = "chunked"
    }
}

extension Request {
    public var path: String {
        return uri.path!
    }
    
    public var accept: [MediaType] {
        get {
            return headers["Accept"].map({ MediaType.parse(acceptHeader: $0) }) ?? []
        }
        
        set(accept) {
            headers["Accept"] = accept.map({ $0.type + "/" + $0.subtype }).joined(separator: ", ")
        }
    }
    
    public var authorization: String? {
        get {
            return headers["Authorization"]
        }
        
        set(authorization) {
            headers["Authorization"] = authorization
        }
    }
    
    public var host: String? {
        get {
            return headers["Host"]
        }
        
        set(host) {
            headers["Host"] = host
        }
    }
    
    public var userAgent: String? {
        get {
            return headers["User-Agent"]
        }
        
        set(userAgent) {
            headers["User-Agent"] = userAgent
        }
    }
}

extension Request : CustomStringConvertible {
    /// :nodoc:
    public var requestLineDescription: String {
        return method.description + " " + uri.description + " " + version.description + "\n"
    }
    
    /// :nodoc:
    public var description: String {
        return requestLineDescription + headers.description
    }
}
