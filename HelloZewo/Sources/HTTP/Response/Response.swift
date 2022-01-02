import Core
import IO
import Media
import Venice

public final class Response : Message {
    public typealias UpgradeConnection = (Request, DuplexStream) throws -> Void
    
    public var status: Status
    public var headers: Headers
    public var version: Version
    public var body: Body
    
    public var storage: Storage = [:]
    public var upgradeConnection: UpgradeConnection?
    public var cookieHeaders: Set<String> = []
    
    public init(
        status: Status,
        headers: Headers,
        version: Version,
        body: Body
    ) {
        self.status = status
        self.headers = headers
        self.version = version
        self.body = body
    }
    
    // TODO: Check http://www.iana.org/assignments/http-status-codes
    public enum Status {
        case `continue`
        case switchingProtocols
        case processing
        
        case ok
        case created
        case accepted
        case nonAuthoritativeInformation
        case noContent
        case resetContent
        case partialContent
        
        case multipleChoices
        case movedPermanently
        case found
        case seeOther
        case notModified
        case useProxy
        case switchProxy
        case temporaryRedirect
        case permanentRedirect
        
        case badRequest
        case unauthorized
        case paymentRequired
        case forbidden
        case notFound
        case methodNotAllowed
        case notAcceptable
        case proxyAuthenticationRequired
        case requestTimeout
        case conflict
        case gone
        case lengthRequired
        case preconditionFailed
        case requestEntityTooLarge
        case requestURITooLong
        case unsupportedMediaType
        case requestedRangeNotSatisfiable
        case expectationFailed
        case imATeapot
        case authenticationTimeout
        case enhanceYourCalm
        case unprocessableEntity
        case locked
        case failedDependency
        case preconditionRequired
        case tooManyRequests
        case requestHeaderFieldsTooLarge
        
        case internalServerError
        case notImplemented
        case badGateway
        case serviceUnavailable
        case gatewayTimeout
        case httpVersionNotSupported
        case variantAlsoNegotiates
        case insufficientStorage
        case loopDetected
        case notExtended
        case networkAuthenticationRequired
        
        case other(statusCode: Int, reasonPhrase: String)
    }
}

extension Response {
    public convenience init(
        status: Status,
        headers: Headers = [:]
    ) {
        self.init(
            status: status,
            headers: headers,
            version: .oneDotOne,
            body: .empty
        )
        
        contentLength = 0
    }
    
    public convenience init(
        status: Status,
        headers: Headers = [:],
        body readable: Readable
    ) {
        self.init(
            status: status,
            headers: headers,
            version: .oneDotOne,
            body: .readable(readable)
        )
    }
    
    public convenience init(
        status: Status,
        headers: Headers = [:],
        body write: @escaping Body.Write
    ) {
        self.init(
            status: status,
            headers: headers,
            version: .oneDotOne,
            body: .writable(write)
        )
    }

    public convenience init(
        status: Status,
        headers: Headers = [:],
        body buffer: BufferRepresentable,
        timeout: Duration = 5.minutes
    ) {
        self.init(
            status: status,
            headers: headers,
            body: { stream in
                try stream.write(buffer, deadline: timeout.fromNow())
            }
        )

        contentLength = buffer.bufferSize
    }
    
    public convenience init<Content : EncodingMedia>(
        status: Status,
        headers: Headers = [:],
        content: Content,
        timeout: Duration = 5.minutes
    ) throws {
        self.init(
            status: status,
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
        status: Status,
        headers: Headers = [:],
        content: Content,
        timeout: Duration = 5.minutes
    ) throws {
        let media = try Content.defaultEncodingMedia()
        
        self.init(
            status: status,
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
        status: Status,
        headers: Headers = [:],
        content: Content,
        contentType mediaType: MediaType,
        timeout: Duration = 5.minutes
    ) throws {
        let media = try Content.encodingMedia(for: mediaType)
        
        self.init(
            status: status,
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

extension Response : CustomStringConvertible {
    /// :nodoc:
    public var statusLineDescription: String {
        return version.description + " " + status.description + "\n"
    }
    
    /// :nodoc:
    public var description: String {
        return statusLineDescription + headers.description
    }
}
