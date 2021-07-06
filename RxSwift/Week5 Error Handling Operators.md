# Week5 Error Handling Operators
> Error Handling Operators 에 대해 알아보쟈 2 !

> Code Example & 설명은 [출처_Panda iOS](https://iospanda.tistory.com/entry/RxSwift-10-Error-Handling)를 참고했습니다.

- [Error Handling Operators](#error-handling-operators)
  - [RxSwift에서 에러를 알리는 방법 (onError notification)](#onerror-notification)
  - [RxSwift에서 에러를 캐치하는 방법 (Catch Error Operator)](#catch-error-operator)
  - [RxSwift에서 에러 발생 후 재구독하는 방법 (Retry Operator)](#retry-operator)

# Error Handling Operators
RxSwift에서 에러를 관리하기 위한 방법을 알아보겠습니다.

Observable 에서 에러 이벤트가 전달되면, 구독이 종료되고 더 이상 새로운 이벤트가 전달되지 않습니다. 새로운 이벤트를 처리할 수 없게 되는 것이지요.

예를 들어 Observable 이 네트워크 요청을 처리하고, 구독자가 UI 를 Update 하는 패턴을 생각해보면 UI 를 업데이트 하는 코드는 next event 가 전달되는 시점에 실행됩니다. 

에러 이벤트가 전달되면 구독이 종료되고, 더 이상 next event 가 전달되지 않게 되지요. 그래서 UI 를 업데이트하는 코드는 실행되지 않습니다. (ex. 에러가 발생했다는 내용으로의 UI 업데이트가 불가능해집니다.)

```swift
let bag = DisposeBag() 

enum MyError: Error { 
    case error 
} 

let subject = PublishSubject<Int>() 
let recovery = PublishSubject<Int>() 

subject 
    // #1
    .subscribe { print($0) } 
    .disposed(by: bag) 
    
subject.onError(MyError.error) 

/*
error(error)
*/
```

먼저, RxSwift 에서 에러를 알기 위한 방법을 알아봅시다.

## onError Notification
> An Observable calls this method to indicate that it has failed to generate the expected data or has encountered some other error. It will not make further calls to onNext or onCompleted. The onError method takes as its parameter an indication of what caused the error. 

Observable 은 기대하는 데이터가 생성되지 않았거나 다른 이유로 오류가 발생할 경우, 오류를 알리기 위해 이 메서드를 호출합니다. 

이 메서드가 호출되면 onNext 나 onCompleted 는 더 이상 호출되지 않습니다. 

onError 메서드는 오류 정보를 저장하고 있는 객체를 파라미터로 전달 받습니다.

예를 들어, 네트워킹에 실패하여 onError 로 빠지게 되면 dispose 되기 때문에 에러를 관리하기 위한 방법이 필요합니다.

RxSwift 는 두 가지 방법으로 이런 문제를 해결합니다.

## Catch Error Operator
> 특정 값으로 Error 복구
* `catchError(_ handler: (Swift.Error)-> Observable<E>)`
* `catchErrorJustReturn(_ element: E)`

<img width=500 src="https://user-images.githubusercontent.com/44978839/113126781-fa585a80-9252-11eb-8ea4-6864cde66188.png">

첫 번째 방법은 error 이벤트가 전달되면 새로운 Observable 을 리턴하는 것입니다. 여기에서는 catchError 연산자를 사용합니다. 

Observable 이 전달하는 next event 와 completed event 는 그대로 구독자에게 전달되지만 error event 가 전달되면, 새로운 Observable 을 구독자에게 전달합니다.

다시 네트워크 요청 예시를 생각해보면 기본 값이나 로컬 캐시를 방출하는 Observable 을 구독자에게 전달할 수 있게 되면서 에러가 발생한 경우에도 UI 는 적절한 값으로 업데이트 됩니다.

### catchError(_ handler: (Swift.Error)-> Observable<E>)
```swift
let bag = DisposeBag() 

enum MyError: Error { 
    case error 
} 

let subject = PublishSubject<Int>() 
let recovery = PublishSubject<Int>() 

subject 
    // #1 catch Error 추가
    .catchError { _ in recovery }
    .subscribe { print($0) } 
    .disposed(by: bag) 
    
subject.onError(MyError.error) 

/*
출력값 없음
*/
```
이후에 subject에 next event를 전달해보면, 이미 에러 이벤트를 전달하고 종료된 Observable이기 때문에 더 이상 구독자에게 next event가 전달되지 않습니다.
```swift
subject.onNext(11) 

/*
출력값 없음
*/
```
next event 를 recovery 로 전달하면 구독자에게 전달됩니다.
```swift
//completed
recovery.onNext(22) 

/*
next(22)
*/
```
completed event 를 전달하면 구독이 에러 없이 정상적으로 종료됩니다.
```swift
recovery.onCompleted() 

/*
completed
*/
```

### catchErrorJustReturn(_ element: E)
catchErrorJustReturn 연산자는 에러 발생시 Observable이 아니라 기본값을 리턴합니다.
```swift
let bag = DisposeBag() 

enum MyError: Error { 
    case error 
} 

let subject = PublishSubject<Int>() 

subject 
    // #1 catch Error 추가
    .catchErrorJustReturn(-1) 
    .subscribe { print($0) } 
    disposed(by: bag) 
    
subject.onError(MyError.error) 

/*
next(-1)
completed 
*/
```
subject로 에러 이벤트가 전달되고, #1에서 파라미터로 전달한 값이 구독자에게 전달됩니다. 

Source Observable 은 더 이상 다른 이벤트를 전달할 수 없고, 파라미터로 전달한 것은 Observable 이 아니라 그냥 하나의 값이기 때문에 더 이상은 전달될 이벤트가 없습니다. 

그래서 바로 completed event 를 전달하고 구독이 종료됩니다.

## Retry Error Operator
> 재시도

* `retry()` : 가장 간단한 방법, 에러가 발생할 경우 시퀀스를 재생성하여 Error 가 나지 않도록 처리
* `retry(_ maxAttemptCount: Int)` : 횟수를 제한할 수 있는 에러 처리
* `retryWhen(_ notificationHandler:)` : notificationHandler 의 타임은 TriggerObservable (= Observable 이거나 Subject 형)

<img width=500 src="https://user-images.githubusercontent.com/44978839/113126804-03492c00-9253-11eb-8da6-f6a559d291e3.png">

두 번째 방법은 에러가 발생한 경우 Observable 을 다시 구독하는 방법입니다. 
이때는 retry 연산자를 사용하고, 에러가 발생하지 않을 때까지 무한정 재시도하거나, 재시도 횟수를 제한할 수 있습니다.

Observable 에서 에러가 발생하면, Observable 에 대한 구독을 해제하고 새로운 구독을 시작하기 때문에 당연히 Observable 시퀀스는 처음부터 다시 시작됩니다. 

Observable 에서 에러가 발생하지 않는다면 정상적으로 종료되고, 에러가 발생하면 또 다시 새로운 구독을 시작합니다.

```swift
let bag = DisposeBag() 

enum MyError: Error { 
  case error 
} 

var attempts = 1 

let source = Observable<Int>.create { observer in 
    let currentAttempts = attempts 
    print("#\(currentAttempts) START") // #1 
    
    if attempts < 3 { 
        bserver.onError(MyError.error) 
        attempts += 1 
    } 
    
    observer.onNext(1) 
    observer.onNext(2) 
    observer.onCompleted() 
    
    return Disposables.create { 
        print("#\(currentAttempts) END") // #2 
    } 
} 

source 
// #3 
    .subscribe { print($0) } 
    .disposed(by: bag) 
    
/* 
#1 START 
error(error) 
#1 END 
*/
```
이 코드는 attempts 변수에 저장된 값이 3 보다 작다면 에러 이벤트를 방출하고 변수를 1 증가시킵니다.

그리고 #1, #2 를 보면 시퀀스의 시작과 끝을 확인할 수 있는 로그가 추가되어있습니다.

코드를 실행해보면 구독자에게 바로 에러 이벤트가 전달되고 실행이 중지됩니다.

이제 #3 에 retry 연산자를 추가해봅시다.

### Retry()
```swift
let bag = DisposeBag() 

enum MyError: Error { 
    case error 
}

var attempts = 1

let source = Observable<Int>.create { observer in 
    let currentAttempts = attempts 
    print("#\(currentAttempts) START") 
    
    if attempts < 3 { // #2 
        observer.onError(MyError.error) 
        attempts += 1 
    } 
    
    observer.onNext(1) 
    observer.onNext(2) 
    observer.onCompleted()
     
    return Disposables.create { 
        print("#\(currentAttempts) END") 
    } 
} 

source 
    .retry() // #1 
    .subscribe { print($0) } 
    .disposed(by: bag) 

/* 
#1 START 
#1 END 
#2 START 
#2 END 
#3 START 
next(1) 
next(2) 
completed 
#3 END 
*/
```

## Materialize / Dematerialize ??
> Sequence 를 제어해서 처리 

[참고](https://okanghoon.medium.com/rxswift-5-error-handling-example-9f15176d11fc)
