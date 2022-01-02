import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

// server 상수 선언
let server = HTTPServer()

// server 속성 정의. serverPort : 포트 번호 , documentRoot : web 진입디렉토리
server.serverPort = 8080
server.documentRoot = "./src"

// 해당 git 에는 라우팅과 핸들러 예제 또한 정의되어있습니다.

// server 시작
do {
    try server.start()
} catch PerfectError.networkError(let error, let message) {
    Log.error(message: "Error: \(error), \(message)")
}
