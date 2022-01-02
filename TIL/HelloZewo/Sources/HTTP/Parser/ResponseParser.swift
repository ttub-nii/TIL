import CHTTPParser
import Core
import Foundation
import Venice

internal final class ResponseParser : Parser {
    private var responses: [Response] = []
    
    internal init(stream: Readable, bufferSize: Int = 2048) {
        super.init(stream: stream, bufferSize: bufferSize, type: HTTP_RESPONSE)
    }
    
    internal func parse(deadline: Deadline) throws -> Response {
        while true {
            guard responses.isEmpty else {
                return responses.removeFirst()
            }
            
            try read(deadline: deadline)
        }
    }
    
    override func headersComplete(context: Parser.Context, body: Parser.BodyStream, method: Int32, http_major: Int16, http_minor: Int16) -> Bool {
        guard let status = context.status else {
            return false
        }
        
        let response = Response(
            status: status,
            headers: context.headers,
            version: Version(major: Int(http_major), minor: Int(http_minor)),
            body: .readable(body)
        )
        
        responses.append(response)
        return true
    }
}
