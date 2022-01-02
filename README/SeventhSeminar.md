# Seventh Seminar
Swift 서버 사이드 프레임워크 Vapor, Perfect, Kitura 로 서버 생성하기
> [2020.03.14]

<br />

# Contents
- [0 단계 | Swift 의 서버 사이드 프레임워크](#0-단계) 
- [1 단계 | Vapor 로 서버 만들기](#1-단계)
- [2 단계 | Perfect 로 서버 만들기](#2-단계)
- [3 단계 | Kitura 로 서버 만들기](#3-단계)

----

## 0 단계
> Swift 의 서버 사이드 프레임워크

Swift 서버 사이드 프레임워크에는 Vapor, Perfect, Kitura, Zewo, SwiftExpress 등이 있는데, 이 중에서 SwiftExpress 는 다루지 않겠다. ~~(안 유명해서)~~

### 1. 프레임워크 비교 분석

> 2020.03.14 00:57 기준  

| Framework | Vapor	|	Perfect | Kitura | Zewo |
|:--------:|:--------:|:--------:|:--------:|:--------:|
| Company | Qutheory(미국) | PerfectlySoft(캐나다) | IBM(미국) | Zewo |
| License | MIT | ASLv2 | ASLv2 | MIT |
| Starts at | 2016.01.19 | 2015.10.03 | 2016.02.06 | 2017.05.24 |
| Github Stars | 18.2K | 13.7K | 7.3K | 1.8K |
| Github Commits | 5374 | 797 | 1160 | 428 |
| Latest Version | 4.0.0 | 3.1.4 | 2.9.1 | 0.16.1 |
| Code Quality Rank | L4 | L3 | L1 | L5 |

> 코드 퀄리티는 [Awesome iOS](https://ios.libhunt.com/vapor-alternatives) 를 참고했다.  
> 평가는 Lumnify 에서 한 것으로 Level 1 이 가장 낮은 퀄리티, Level 5 이 가장 높은 퀄리티의 코드라고 한다.

* 초반에는 Perfect 가 시작이 빨랐던 만큼, 가장 많은 DBMS 를 지원하면서 스타도 가장 많았지만 요즘에는 Vapor 가 대세인 듯 하다.
* Vapor가 다른 Swift 웹프레임워크보다 우월한 것은 아니지만 처음 사용법을 익히는 것이 쉽다고 한다. 한번 직접 사용해보겠다.

----

## 1 단계
> Vapor 로 서버 만들기

### 1. Vapor 설치 및 프로젝트 생성
1. vapor는 Swift 4.1+ 를 요구하기 때문에 터미널에 **swift --version** 을 쳐서 버전을 확인한다. ~~(나의 버전은 5.1.2 였다.)~~
2. vapor 패키지 저장소를 추가하기 위해 **brew tap vapor/tap** 명령어를 입력한다.
3. vapor 패키지를 설치하기 위해 **brew install vapor/tap/vapor** 명령어를 입력한다.

<img width="400" alt="스크린샷 2020-03-14 오전 2 01 18" src="https://user-images.githubusercontent.com/44978839/76643072-bc30c000-6597-11ea-872e-be6264486f64.png"> 설치가 정상적으로 완료되었다.

4. 작업할 폴더를 생성하기 위해 **vapor new [Project Name]** 명령어를 입력한다.
5. 작업 폴더로 이동해서 **cd [Project Name]** vapor프로젝트 실행하려면 **vapor xcode** 명령어를 입력한다.

<img width="800" alt="스크린샷 2020-03-14 오전 2 06 34" src="https://user-images.githubusercontent.com/44978839/76643545-9821ae80-6598-11ea-92c5-84fc305d91e7.png">

* **ISSUE #1 Vapor 설치 과정 중 brew 명령어 없다는 에러**
* brew 명령어를 사용하려면 그 전에 Homebrew 가 맥에 설치되어있어야 한다.
* 그렇지 않다면 아래 명령어를 터미널에 입력해 Homebrew 를 설치한다. 

 ```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
 ```

<br/>

* **ISSUE #2 Vapor Xcode 프로젝트 생성이 안되는 에러**

<img width="500" alt="스크린샷 2020-03-14 오전 2 21 03" src="https://user-images.githubusercontent.com/44978839/76644514-75909500-659a-11ea-85bf-cbc0edc981af.png">

* 만약 vapor xcode 명령어를 입력해서 xcode 파일이 생성되었다는 메시지가 뜨는데도 열리지 않는다면 아래 명령어를 입력한다. 문제가 해결될 것이다.

 ```
  sudo xcode-select -s /Applications/Xcode.app
  vapor build
  vapor xcode
 ```

<br/>

### 2. 서버 동작시키고 "Hello, world!" 띄우기
1. 서버를 동작시키는 방법에는 터미널 창에 **vapor run** 명령어를 입력하는 방법과 Xcode 상에서 Run 스킴으로 바꾸고 빌드하는 방법이 있다.

  [http://localhost:8080 접속화면]  
  <img width="600" alt="스크린샷 2020-03-14 오전 2 33 15" src="https://user-images.githubusercontent.com/44978839/76645344-2b101800-659c-11ea-9e01-56832570699c.png">

  [첫번째 방법]
  <img width="500" alt="스크린샷 2020-03-14 오전 2 27 04" src="https://user-images.githubusercontent.com/44978839/76644940-51818380-659b-11ea-86a2-b8300ab32e8c.png">

  [두번째 방법]
  <img width="252" alt="스크린샷 2020-03-14 오전 2 23 07" src="https://user-images.githubusercontent.com/44978839/76644957-5d6d4580-659b-11ea-82fe-4e6f19351f7e.png"> <img width="430" alt="스크린샷 2020-03-14 오전 2 23 41" src="https://user-images.githubusercontent.com/44978839/76644962-5f370900-659b-11ea-9ddb-0ed4173e7acb.png">

2. Project > Sources > routes.swift 파일에 가면 get 메소드를 return 하는 값이 보인다. 현재는 http://localhost:8080/hello 경로로 이동해야 "Hello, world!" 가 출력되도록 설정되어있다.

 ```swift
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
}
 ```

3. baseURL 로 접속하자마자 "Hello, world!" 가 뜨도록 코드를 변경하고 샘플코드는 삭제했다.

 ```swift
import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "Hello, world!"
    }
}
 ```
 
 <img width="600" alt="스크린샷 2020-03-14 오전 2 36 47" src="https://user-images.githubusercontent.com/44978839/76645638-bd182080-659c-11ea-9e86-c864048643d9.png">

----

## 2 단계
> Perfect 로 서버 만들기

### 1. Perfect 프로젝트 생성
1. perfect 는 Swift 3.0.1+ 를 요구하기 때문에 터미널에 **swift --version** 을 쳐서 버전을 확인한다.
2. Terminal을 열고 **mkdir [Project Name]** 명령어를 입력해 생성하려는 프로젝트 명으로 폴더를 만든다.
3. 작업 폴더로 이동해서 **cd [Project Name]** 패키지를 초기화한다. **swift package init --type executable**

<img width="750" alt="스크린샷 2020-03-14 오전 2 50 42" src="https://user-images.githubusercontent.com/44978839/76646601-9a870700-659e-11ea-8b91-1a2748dd4fb7.png">

<br/>

### 2. Perfect 설치
1. Package.swift 안의 Dependencies에 perfect 추가한다.
```swift
[Package.swift]

...

    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
	// 아래 Perfect 패키지코드를 추가한다.
    .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0")
    ],
    
...
```

* 구글링 해보면 Perfect package 설치하는 dependency 작성법이 아래와 같이 많이 나올텐데 2018. 1. 2 기준 버전이 바뀌면서 명령어가 에러를 발생시킨다.
* 정확한 설치법을 다음 링크에서 참고하였다. https://github.com/iexploits/Perfect-Init
```swift
dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2)
]
```

2. 저장하고 나와서 터미널 창에다가 **swift package update** 명령어를 입력한다.

<img width="750" alt="스크린샷 2020-03-14 오전 3 09 18" src="https://user-images.githubusercontent.com/44978839/76648003-344fb380-65a1-11ea-9070-4ce67b23e364.png">

3. Sources > [Project Name] > main.swift 파일을 열어 다음과 같이 작성한다.
```swift
[./Sources/[Project Name]/main.swift]

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import Foundation

// server 상수 선언 
let server = HTTPServer()

// server 속성 정의. serverPort : 포트 번호 , documentRoot : web 진입디렉토리
server.serverPort = 8080
server.documentRoot = "./src"

// 해당 git 에는 라우팅과 핸들러 예제 또한 정의되어있다.

// server 시작
do {
    try server.start()
} catch PerfectError.networkError(let error, let message) {
    Log.error(message: "Error: \(error), \(message)")
}
```

4. 아까 사용했던 **swift package generate-xcodeproj** 명령어를 입력하여 xcode 프로젝트를 재생성하고 빌드한다.
```
> swift build
> ./.build/debug/[프로젝트 명]
[INFO] Starting HTTP server  on 0.0.0.0:8080
```
----

## 3 단계
> Kitura 로 서버 만들기

### 1. Kitura 프로젝트 생성 및 설치
1. 폴더를 생성하고 package 매니저를 만드는 과정 모두 Perfect 패키지를 설치하는 방법과 동일하다.
2. Package.swift 안의 Dependencies에 kitura를 추가한다.
```swift
[Package.swift]

...

    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
	// 아래 Kitura 패키지코드를 추가한다.
    .package(url: "https://github.com/IBM-Swift/Kitura.git", from: "2.6.0")
    ],
    
...
```
* Perfect package 설치할 때와 마찬가지로 아래 코드와 같이 Kitura 와 버전이 맞지 않으면 dependency 작성에서 에러를 발생시킨다.
* 정확한 설치법을 다음 링크에서 참고하였다. https://github.com/IBM-Swift/Kitura-Sample/blob/master/Package.swift
```swift
dependencies: [
        .Package(url: “https://github.com/IBM-Swift/Kitura.git", majorVersion:1)
	.Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7)
]
```

2. 저장하고 나와서 터미널 창에다가 **swift package update** 명령어를 입력한다.

<img width="750" alt="스크린샷 2020-03-14 오전 4 40 05" src="https://user-images.githubusercontent.com/44978839/76654250-eb522c00-65ad-11ea-965f-16ae741eccc7.png">


- Kitura를 dependencies에 추가하면 Kitura 외 SwiftyJSON 등 Kitura와 버전을 맞춘 framework들이 추가된다.  
	- https://github.com/IBM-Swift/Kitura.git
	- https://github.com/IBM-Swift/Kitura-net.git
	- https://github.com/IBM-Swift/SwiftyJSON.git
	- https://github.com/IBM-Swift/Kitura-TemplateEngine.git
	- https://github.com/IBM-Swift/LoggerAPI.git
	- https://github.com/IBM-Swift/BlueSocket.git
	- https://github.com/IBM-Swift/CCurl.git
	- https://github.com/IBM-Swift/BlueSSLService.git

3. Sources > [Project Name] > main.swift 파일을 열어 다음과 같이 작성한다.
```swift
import Kitura

// Create a new router
let router = Router()

// Handle HTTP GET requests to /
router.get("/") {
    request, response, next in
    response.send("Hello, World!")
    next()
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8080, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
```

4. **swift build** 명령어로 컴파일하고 실행시킨다.

* 만약 로그를 찍고 싶다면, https://github.com/IBM-Swift/HeliumLogger.git 을 위처럼 Package.swift 안에 dependencies 에 명시하여 사용하면 된다.
