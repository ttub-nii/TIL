# Week1 RxSwift 개요
> RxSwift 에 대해 간략히 알아보쟈 !

### 📌 Contents 
- [What is ReactiveX?](#reactivex)
- [What is RxSwift?](#rxswift)
- [Asynchronous programming](#asynchronous-programming)
  - [concept](#concept)
  - [mutable / immutable](#mutable--immutable)
  - [first-citizen class](#first-citizen-class)
  - [명령형 프로그래밍](#명령형-프로그래밍)
  - [선언형 프로그래밍](#선언형-프로그래밍)
- [RxSwift 주요 구성 요소](#rxswift-주요-구성-요소)
  - [Observables](#observables)
  - [Operators](#operators)
  - [Schedulers](#schedulers)
  - [Subject](#subject)
- [How to import](#how-to-import)

# ReactiveX
### `Rx`Swift 를 이해하기 위한 과정, Rx가 무엇인가?
* [Reactive eXensions](http://reactivex.io/) 의 줄임말

  <img width="740" alt="스크린샷 2021-03-03 오후 9 13 24" src="https://user-images.githubusercontent.com/44978839/109804328-787e0d00-7c65-11eb-9cc0-1216fff0cd8e.png">

* 옵저버블한 시퀀스를 사용하여 비동기 & 이벤트 기반 프로그램을 구성하기 위한 라이브러리
* _옵저버블..? 시퀀스..? 머르겠지만 일단 라이브러리군..!_
* 데이터나 이벤트의 시퀀스를 지원하기 위해 옵저버 패턴을 사용
* 시퀀스를 같이 구성하기 위해 오퍼레이터 제공
* low-level 스레딩, 동기화, thread-safety, 동시 데이터 구조 및 논블로킹 I/O 이러한 상황들...
    > concurrent data structure
    ```
    병렬 또는 분산 컴퓨팅 환경에서 사용하기 위한 동시 데이터 구조
    단일 프로세서 시스템의 sequential 한 데이터 구조와는 상이
    ```

### 그럼... 왜 사용하는걸까?
* 요약하자면, Rx 의 옵저버블한 모델이 비동기적인 이벤트 스트림을 다루는데 도움을 줄 수 있다.

  <img width="740" alt="스크린샷 2021-03-03 오후 9 13 30" src="https://user-images.githubusercontent.com/44978839/109804525-b11de680-7c65-11eb-9c36-f6657bc8e282.png">

* 어떤 경우냐 하면, array 처럼 data collections 를 사용할 때 같은 단순하고 복합적인 작업을 동반하는 비동기 이벤트 스트림을 처리할 때!!
* 마구잡이로 오는 (뒤엉킨) 콜백 처리에서 자유로워질 수 있음...
* 나아가 코드가 좀 더 readable, 버그가 덜 발생할 수 있다는 장점!

* 추가로 왜 사용하면 좋은지에 대해 medium 글이 있어 첨부
  ```
  1. 반응형 패러다임이 제공하는 명확함. 비동기를 동기화 된 것인양 작성할 수 있다.
  2. 일관성이 없는 비동기 코드를 해결. DispatchQueue, OperationQueue... 하나로 가능하다.
  3. 확장 불가능한 아키텍처 패턴을 해결. Rx로 일관된 코드를 작성하면서 아키텍처의 확장이 가능하다.
  (중략)
  5. Operator 를 이용해 Async 하게 전달되는 데이터를 조작해서 사용할 수 있다. (다른 비동기 util 과 차별되는 부분)
  (후략)
  ```
 * 출처 : https://medium.com/@jang.wangsu/ios-swift-rxswift-%EC%99%9C-%EC%82%AC%EC%9A%A9%ED%95%98%EB%A9%B4-%EC%A2%8B%EC%9D%84%EA%B9%8C%EC%9A%94-5c9995f47bab

# RxSwift
* Swift 로 FRP를 가능하게 하여주는 ReactiveX 라이브러리
    > FRP 는 Functional Reactive Programming  
    > 함수형 프로그래밍(FP) + 반응형 프로그래밍(RP)

* 요약하자면, 반응형 프로그래밍을 함수형 프로그래밍 블록(filter, map, reduce 등)과 함께 사용하는 것이다.
* 좀 더 구체적으로, 이벤트 스트림에 고차함수를 적용해서 이벤트를 최종 결과 값으로 변환해서 전달해주는 형태의 프로그래밍을 가능하게 해준다.
* 변수에 정적으로 값을 할당하는 것 --> 무언가 미래에 바뀔 수 있는 것을 관찰(observe)하는 것으로 관점을 변경해야 한다! 일을 간단하게 만들어주기 때문!
    ```
    * 테스트하기 어려운 notification 대신 signal
    * 많은 코드로 번거로운 delegate 대신 block
    * 외에도 KVO, IBAction, MVVM 등등.. 포함되어 있어 적절하게 사용한다면 굳
    ```
* cf.1 : https://medium.com/@jang.wangsu/rxswift-rxswift%EB%9E%80-reactivex-%EB%9E%80-b21f75e34c10
* cf.2 : https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html

# Asynchronous programming
## concept
* 메인 프로그램 흐름과 독립적인 이벤트의 발생 및 이러한 이벤트(비동기 데이터 스트림)를 다루는 방법
  
  <img width="740" src = "https://user-images.githubusercontent.com/44978839/109804671-dad70d80-7c65-11eb-91e9-c1f063098447.png">

* signal 도착과 같은 `outside` 이벤트거나, 프로그램이 결과를 기다리도록 blocking 되지 않고 프로그램 실행과 동시에 발생하는, 프로그램에 의해 실행된 작업일 수 있다.
* 시나리오
  ```
  1. I / O 작업
   ex. 네트워크 호출, 데이터베이스와 통신, 파일 읽기, 문서 인쇄 등
  2. 병렬로 여러 작업 수행
   ex. 데이터베이스 호출, 웹 서비스 호출 및 계산과 같은 다른 작업을 병렬로 수행해야하는 경우
  ```
* 출처 : https://www.codeproject.com/Tips/866962/Async-and-Await-Tutorial

## mutable / immutable
* mutable한 객체는 생성된 이후 변경될 수 있지만, immutable한 객체는 불가능하다.
* ex. String 은 Struct 이므로 그 자체로는 `immutable` 하지만 String의 Definition 파일을 보면 대표적인 `mutating` 함수로 `@inlinable public mutating func append(_ newElement: Character)` 을 볼 수 있는 것처럼 말이다.

    <img width="551" alt="스크린샷 2021-03-03 오후 8 42 07" src="https://user-images.githubusercontent.com/44978839/109804733-ede9dd80-7c65-11eb-914a-1c6b21db5ef0.png">


## first-citizen class
다음 조건을 만족하는 객체를 의미한다.
1. 변수나 상수에 저장 및 할당 할 수 있어야 한다.  
   
    ```swift
   func createfirstCitizen(test: String) -> String {
       print("I am first-citizen")
       return test
    }

    let firstCitizen = createfirstCitizen
   ```

2. 파라미터(객체의 인자)로 전달 할 수 있어야 한다.

    ```swift
   func passFirstCitizen(test: String) {
        print(test)
    }

    passFirstCitizen(test: firstCitizen("Hello"))
   ```

3. 함수(객체)에서 return 할 수 있어야 한다.
   
   ```swift
   func returnCitizen() -> String {
       return createfirstCitizen(test: "Hello, World!")
    }
    ```

* 출처 : https://richard25.tistory.com/62

## 명령형 프로그래밍
명령형 패러다임은 컴퓨터가 어떻게 동작하는지를 말해주는 알고리즘을 생성하는 것을 통해 프로그램의 상태를 변화시키는 구문들(statements)을에 초점을 둔다. 이는 하드웨어의 동작과 밀접한 관련이 있다. 일반적으로, 조건문, 반복문 그리고 클래스 상속의 사용이 이를 보여준다.
* C, C++, C#, PHP, Jave와 Assembly

## 선언형 프로그래밍
선언형 그 프로그램이 실제로 어떻게 흘러가는지에 대한 묘사 없이 오직 프로그램의 논리에 초점을 맞춘다. HTML의 예를 들면, 브라우저에 이미지를 표시하기 위해 사용하는 `<img src="./image.jpg" />` 는 이 코드 구문이 어떻게 동작하는지에 대해 신경쓰지 않고 이를 사용한다.
* HTML, XML, CSS, SQL, Prolog, Haskell, F#, Lisp

### _"명령형 프로그래밍은 무엇을 `어떻게` 할 것인가에 가깝고,_
### _선언형 프로그래밍은 `무엇을` 할 것인가와 가깝다."_

* 출처 : https://phobyjun.github.io/2019/09/20/%EB%AA%85%EB%A0%B9%ED%98%95(Imperative)-%EC%96%B8%EC%96%B4%EC%99%80-%EC%84%A0%EC%96%B8%ED%98%95(Declarative)-%EC%96%B8%EC%96%B4.html

# RxSwift 주요 구성 요소
## Observables
* event 를 내보낼 수 있는 능력 (emit)
* event 가 흘러가는 흐름을 추상화한 것
* Observer 패턴에서 사용하는 용어로는 Subject 라고 보면 된다.
* Sequence, Stream 를 같은 의미로 많이 쓴다
* Observable 이 내보내는 event를 받아 어떤 작업을 하기위해 `subscribe()` 메소드가 정의되어 있다.
* Observable 은 subscribe 해야 그 때부터 event를 내보내기 시작한다.

## Operators
* emit된 이벤트들에 대해서 변형 & 처리 & 반응 할 수 있는 방법
* Observable을 다루는 메소드들을 통칭하는 용어
* cf. : http://reactivex.io/documentation/ko/operators.html

## Schedulers
* 작업을 위한 메커니즘을 추상화 (스케줄러는 쓰레드가 아님 !!)
* 각각의 작업을 위한 메커니즘에는 thread, dispatch queue, operation queue, 새로운 thread, thread pool 이 포함되어 있다.
* `observeOn` 과 `subscribeOn` 은 스케줄러로 작동되는 대표적인 두 연산자 !!
* 만약 다른 스케줄러에서 작업을 실행하고 싶다면 `observeOn(scheduler)` 연산자를 사용하면 됩니다.
* `observeOn(scheduler)` : Observable 이 Observer 에게 알리는 스케줄러를 지정
* `subscribeOn(scheduler)` : Observable 이 동작하는 스케줄러 지정

## Subject
* Observable 인 동시에 Observer
* Observable 과 Observer 간의 연결 (특별한 제약사항을 걸어둔 Observable)
* 따라서 event를 주입받고, 이를 내보낼 수 있는 능력을 가진다.

> Observer 가 하는 일
>> * Observable 구독  
>> * Observable 이 배출하는 항목에 대한 반응
>> * emit 할 때까지 기다릴 필요가 없이 옵저버가 알아서 반응해주니 동시성 연산이 가능해짐

* 출처 : https://daheenallwhite.github.io/ios/rx/2020/01/31/Rx-Terms/

# How to import
* https://github.com/ReactiveX/RxSwift
* https://cocoapods.org/pods/RxSwift
