#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import Venice
import Core
import CLibdill

// TODO: Create TCP errors
public enum TCPError : Error {}

public final class TCPHost : Host {
    private typealias Handle = Int32

    private let handle: Handle
    public let ip: IP

    private init(handle: Handle, ip: IP) {
        self.handle = handle
        self.ip = ip
    }
    
    deinit {
        hclose(handle)
    }

    public convenience init(ip: IP, backlog: Int, reusePort: Bool) throws {
        var address = ip.address
        let result = tcp_listen(&address, Int32(backlog))
        
        // TODO: Set reusePort
        
        guard result != -1 else {
            switch errno {
            default:
                throw SystemError.lastOperationError
            }
        }
        
        self.init(handle: result, ip: ip)
    }

    public convenience init(
        host: String = "",
        port: Int = 8080,
        backlog: Int = 128,
        reusePort: Bool = false
    ) throws {
        let ip: IP
        
        if host == "" {
            ip = try IP(port: port)
        } else {
            ip = try IP(local: host, port: port)
        }
        
        try self.init(ip: ip, backlog: backlog, reusePort: reusePort)
    }

    public func accept(deadline: Deadline) throws -> DuplexStream {
        var address = ipaddr()
        let result = tcp_accept(handle, &address, deadline.value)
        
        guard result != -1 else {
            switch errno {
            default:
                throw SystemError.lastOperationError
            }
        }

        return TCPStream(handle: result, ip: IP(address: &address), open: true)
    }
}
