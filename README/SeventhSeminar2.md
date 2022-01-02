# Swift 서버 사이드 프레임워크 보강(실패?)
Zewo 로 서버 생성하기
> [2020.04.01]

# Contents
- [0 단계 | Zewo 는 무엇인가?](#0-단계) 
- [1 단계 | Zewo 로 서버 만들기](#1-단계)

----

## 0 단계
> Zewo 는 무엇인가?

* 웹 서버 어플리케이션을 제공하는 Swift 라이브러리 중 Linux 환경을 지원하는 유일한(?) 서버 사이드 프레임워크라고 들었다.  

* Swift 서버 사이드 프레임워크에는 Vapor, Perfect, Kitura, Zewo, SwiftExpress 등이 있었는데 지난번 세미나에서 Zewo 는 서버 생성을 다루지 않았었다. 

* Zewo 는 2018년 4월 13일에 배포된 버전이 가장 최신 버전이라 Swift 최신 버전까지 coverage 되는 것 같지 않았다.  

* 구글링을 하다보면 Zewo 가 패키지를 배포하기 전인 2016년도 Zewo 를 사용하던 tutorial 블로그가 나오긴 하는데 너무 오래됐다. ~~국내 버전은 아예 안나옴.~~

### 1. Zewo 의 장점으로 제작자들이 말하기로는,

* Go 언어 스타일의 동시성

* 동기식 API

* 놀라운 성능

* 확장성

* 클린 코드

* 적절한 오류 처리

* 콜백 지옥 없음

와 같은 점이라고 한다.

----

## 1 단계
> Zewo 로 서버 만들기

### 1. Zewo 프로젝트 생성

1. Zewo 는 Swift 4.0+ 를 요구하기 때문에 터미널에 **swift --version** 을 쳐서 버전을 확인한다. swift 4.1 버전은 호환하지 않는다고 한다.
2. https://github.com/Zewo/Zewo/releases 링크로 들어가서 Source code.zip 파일을 다운 받았다.
3. Terminal을 열고 **mkdir [Project Name]** 명령어를 입력해 생성하려는 프로젝트 명으로 폴더를 만든다.

4-1. 다운 받은 파일을 압축 해제하고 모든 souce 파일들을 생성한 프로젝트 폴더로 이동한다.

4-2. 작업 폴더로 이동해서 cd [Project Name] 패키지를 초기화한다. swift package init –type executable
5. 다운 받은 파일을 압축 해제하고 Package.swift 파일만 생성한 프로젝트 디렉토리로 옮겨 init 한 Package.swift 파일을 대치한다. 

### 2. Zewo 설치
1. Package.swift 에 dependencies 가 명시된 상태이기 때문에 **swift package update** 명령어를 입력한다.

```
Fetching https://github.com/Zewo/CLibdill.git
Fetching https://github.com/Zewo/Venice.git
Fetching https://github.com/Zewo/CBtls.git
Fetching https://github.com/Zewo/CLibreSSL.git
Completed resolution in 5.46s
Cloning https://github.com/Zewo/CBtls.git
Resolving https://github.com/Zewo/CBtls.git at 1.1.0
Cloning https://github.com/Zewo/CLibdill.git
Resolving https://github.com/Zewo/CLibdill.git at 2.0.0
Cloning https://github.com/Zewo/Venice.git
Resolving https://github.com/Zewo/Venice.git at 0.20.0
Cloning https://github.com/Zewo/CLibreSSL.git
Resolving https://github.com/Zewo/CLibreSSL.git at 3.1.0
```

* Fetch, Clone, Resolve 모두 정상적으로 완료되었다.

2. **swift package generate-xcodeproj** 명령어를 입력하여 xcode 프로젝트를 재생성하고 빌드한다.
```
generated: ./Zewo.xcodeproj
```
