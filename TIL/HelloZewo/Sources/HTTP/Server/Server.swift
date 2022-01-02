import Core
import IO
import Venice

public final class Server {
    /// Parser buffer size
    public let parserBufferSize: Int
    
    /// Serializer buffer size
    public let serializerBufferSize: Int
    
    /// Parse timeout
    public let parseTimeout: Duration
    
    /// Serialization timeout
    public let serializeTimeout: Duration
    
    /// Close connection timeout
    public let closeConnectionTimeout: Duration
    
    private let header: String
    private let group = Coroutine.Group()
    private let respond: Respond

    /// Creates a new HTTP server
    public init(
        header: String = defaultHeader,
        parserBufferSize: Int = 4096,
        serializerBufferSize: Int = 4096,
        parseTimeout: Duration = 10.seconds,
        serializeTimeout: Duration = 5.minutes,
        closeConnectionTimeout: Duration = 1.minute,
        respond: @escaping Respond
    ) {
        self.header = header
        self.parserBufferSize = parserBufferSize
        self.serializerBufferSize = serializerBufferSize
        self.parseTimeout = parseTimeout
        self.serializeTimeout = serializeTimeout
        self.closeConnectionTimeout = closeConnectionTimeout
        self.respond = respond
    }
    
    deinit {
        group.cancel()
    }

    /// Start server
    public func start(
        host: String = "0.0.0.0",
        port: Int = 8080,
        backlog: Int = 2048,
        reusePort: Bool = false,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        column: Int = #column
    ) throws {
        let tcp = try TCPHost(
            host: host,
            port: port,
            backlog: backlog,
            reusePort: reusePort
        )
        
        log(
            host: host,
            port: port,
            locationInfo: Logger.LocationInfo(
                file: file,
                line: line,
                column: column,
                function: function
            )
        )
        
        try start(host: tcp)
    }
    
    /// Start server
    public func start(host: Host) throws {
        while true {
            do {
                try accept(host)
            } catch SystemError.tooManyOpenFiles {
                Logger.info("Too many open files while accepting connections. Retrying in 10 seconds.")
                try Coroutine.wakeUp(10.seconds.fromNow())
                continue
            } catch VeniceError.canceledCoroutine {
                break
            } catch {
                Logger.error("Error while accepting connections.", error: error)
                throw error
            }
        }
    }
    
    /// Stop server
    public func stop() throws {
        Logger.info("Stopping HTTP server.")
        group.cancel()
    }
    
    public static var defaultHeader: String {
        var header = "\n"
        header += "                        _____                         \n"
        header += "     _.-ˆˆ-._.-ˆˆ-._   /__  /   ____ _      __ ____   \n"
        header += "    |ˆ-._.-ˆˆˆ-._.-ˆ|    / /   / __/| | /| / // __ \\ \n"
        header += "    |   |ˆ-._.-ˆ|   |   / /__ / __/ | |/ |/ // /_/ /  \n"
        header += "    ˆ-._|   |   |_.-ˆ  /____//____/ |__/|__/ \\____/  \n"
        header += "        ˆ-._|_.-ˆ                                       \n"
        header += "_______________________________________________________ \n"
        return header
    }
    
    @inline(__always)
    private func log(host: String, port: Int, locationInfo: Logger.LocationInfo) {
        var header = self.header
        header += "Started HTTP server at \(host), listening on port \(port)."
        Logger.info(header, locationInfo: locationInfo)
    }
    
    @inline(__always)
    private func accept(_ host: Host) throws {
        let stream = try host.accept(deadline: .never)
        
        try group.addCoroutine { [unowned self] in
            do {
                try self.process(stream)
            } catch SystemError.brokenPipe {
                Logger.error("Broken pipe while processing connection.")
                return
            } catch SystemError.connectionResetByPeer {
                Logger.error("Connection reset by peer while processing connection.")
               return
            } catch VeniceError.canceledCoroutine {
                Logger.error("Cancelled coroutine while processing connection.")
               return
            } catch {
                Logger.error("Error while processing connection.", error: error)
            }
            
            try stream.close(deadline: self.closeConnectionTimeout.fromNow())
        }
    }

    @inline(__always)
    private func process(_ stream: DuplexStream) throws {
        let parser = RequestParser(stream: stream, bufferSize: parserBufferSize)
        let serializer = ResponseSerializer(stream: stream, bufferSize: serializerBufferSize)
        
        while true {
            let request = try parser.parse(deadline: parseTimeout.fromNow())
            let response = respond(request)
            let keepAlive = try serializer.serialize(response, deadline: serializeTimeout.fromNow())
            
            guard keepAlive else {
                break
            }
            
            if let upgrade = response.upgradeConnection {
                try upgrade(request, stream)
                break
            }
            
            if !request.isKeepAlive {
                break
            }
        }
    }
}
