# Week6 RxCocoa
> RxCocoa 에 대해 알아보쟈 !

> 설명은 해당 [사이트](https://joycestudios.tistory.com/90)를 참고했습니다.

- [RxCocoa 란?](#RxCocoa-란?)

- [ObserverType, ObservableType](#observerType-observableType)
    - ControlProperty
    - Binder

- [Observable Binding](#observable-binding)
    - bind(to:)

- [RxRelay](#rxrelay)
    - Publish Relay
    - Behavior Relay
  
- [Drive](#drive)

- [Traits](#traits)
  - [Single](#single)
  - [Maybe](#maybe)
  - [Completable](#completable)

# RxCocoa 란?
> 기존 Cocoa Framework 에 Rx 기능을 합친 RxSwift 라이브러리
> 다양한 protocol을 extension 한 것들과 UIKit을 위한 rx 영역을 제공하는 프레임워크

## ObserverType ObservableType
### ObserverType
* 값을 주입시킬 수 있는 타입
* 이벤트를 보낼 수 있는 프로토콜
* ObserverType 은 Event 를 다루도록 정의합니다.
```swift
protocol ObserverType {
    associatedtype Element // 옵저버가 볼 수 있는 시퀀스의 요소 타입

    // 시퀀스 이벤트에 대해 옵저버에게 알림.
    //
    // - parameter event: 발생된 이벤트
    func on(_ event: Event<Element>)
}
```

### ObservableType
* 값을 관찰할 수 있는 타입
* 이벤트를 관찰할 수 있는 프로토콜
* ObservableType 은 Observable 이 이벤트를 Observer 에게 전달하면, Observer 가 처리할 수 있도록 정의합니다
```swift
protocol ObservableType {
    associatedtype Element

    // Observable을 구독하여 observer에 Event를 전달. 
    // Observer의 E와 E를 비교하여 타입 제약함.
    //
    // - Parameter observer: Event를 전달받을 Observer
    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.Element == Element
}
```

### ControlProperty
* ControlPropertyType 은 ObserverType 과 ObservableType 을 채택한 Struct
```swift
public protocol ControlPropertyType : ObservableType, ObserverType {

    /// - returns: `ControlProperty` interface
    func asControlProperty() -> ControlProperty<Element>
}
```
> 출처: https://github.com/ReactiveX/RxSwift/blob/main/RxCocoa/Traits/ControlProperty.swift

### Binder
* data binding 을 위한 타입
* ObserverType 을 준수합니다.
* Main Scheduler 에서 binding 합니다.
* 따라서 값을 생성해내고 주입할 수는 있으나 값을 관찰할 수는 없습니다.
* error event 를 방출할 수 없습니다. (error 는 binding 불가)

## Observable Binding
* RxCocoa 에서 binding 은 Publisher 에서 Subscriber 로 향하는 단방향 binding 입니다.
* Producer -> Receiver

### bind(to:)
* bind(to:) 메소드는 subscribe() 의 별칭입니다.
* bind(to: observer) 를 호출하게 되면 subscrive(observer) 가 실행됩니다.

## RxRelay
* Relay 클래스를 가지고 있는 라이브러리
* RxCocoa 내부에 import 되어있습니다.
* Observable 과 Relay 를 bind 하는 메소드를 제공해주고 있습니다.

*Relay 를 bind 하면 안되나요?*
> Relay에 대해서 찾아보신 분들은 ‘Relay 를 bind 하는 것은 지양해야 한다’는 말을 들어보신 적이 있을 것입니다.  
> 하지만 RxRelay 에서는 Observable 과 Relay 를 bind 하는 메소드를 제공해주고 있습니다.  
> 에러가 발생했을 때는 에러가 발생했다는 처리를 반환해주는 게 아니라 fatal Error 를 바로 내기 때문에 (in Debug) 릴리즈 모드 일 때는 print 만 되고 error 출력이 안됨. 팝업을 띄우는 것과 같은 UI 작업을 할 수 없다. 이걸 하려면 추가적으로 do(onError:) 와 같은 장치가 필요.  
> error 나 complete 처리에서 뭐가 있다고 하는데(swift 과거 버전에만 해당되는 내용인가...?) Relay 는 accept 로 next 만 줄 수 있어서 별로 상관 없다고 생각합니다.  

### Publish Relay
* PublishSubject 의 Wrapper 클래스
* 구독한 시점부터 전달
* 초기값이 없는 상태
```swift
//PublishRelay에 대한 bind 메소드. BehaviorRelay도 타입 빼고 같은 내용의 메소드가 있다.
public func bind(to relays: PublishRelay<Element>...) -> Disposable {
        return bind(to: relays)
    }

private func bind(to relays: [PublishRelay<Element>]) -> Disposable {
        return subscribe { e in
            switch e {
            case let .next(element):
                relays.forEach {
                    $0.accept(element) // Relay 내부의 Subject에 next이벤트를 흘려보낸다.
                }
            case let .error(error):
                // 디버그 모드면 런타임 에러를, 릴리즈 모드면 그냥 에러 메시지를 print만 한다.
                // 즉, 어떻게 해서든 내부 subject에 에러가 흘러가지를 않는다.
                rxFatalErrorInDebug("Binding error to publish relay: \(error)")
            case .completed:
                break
            }
        }
    }
```
> 출처: https://jcsoohwancho.github.io/2019-08-05-RxSwift%EA%B8%B0%EC%B4%88-Relay/

### Behavior Relay
* BehaviorSubject의 Wrapper 클래스
* 초기값이 있는 상태

## Driver
RxSwift 는 다른 언어의 Rx 구현체와는 다르게 Driver 라는 unit 을 제공합니다. 

Driver 는 UI layer 에서 좀 더 직관적으로 사용하도록 제공하는 unit 입니다. 

Observable 은 상황에 따라 MainScheduler 와 BackgroundScheduler 를 지정해줘야 하지만 Driver는 MainScheduler 에서 사용합니다.

> 설명 출처 : [[ReactiveX][RxSwift]Observable과 Driver - 민소네](http://minsone.github.io/programming/reactive-swift-observable-vs-driver)

*언제 쓰는 것이 좋을까?*
> UI 관련된 것에는 Driver 를 쓰는 것이 좋습니다. Observable 을 쓰게 되면 Thread 를 지정해줘야 하는데, 실수가 발생할 수도 있기 때문입니다.

---
## Driver VS Observable
username 과 password 가 입력되었는지 확인하고 로그인 버튼을 활성화하는 코드 작성해보기

### Driver 버전
```swift
let usernameValid = loginUsernameTextField.rx_text().asDriver().map { $0.utf8.count > 0 }
let passwordValid = loginPasswordTextField.rx_text().asDriver().map { $0.utf8.count > 0 }

let credentialsValid: Driver<Bool> = Driver.combineLatest(usernameValid, passwordValid) { $0 && $1 }

credentialsValid.driveNext { [weak self] valid in
    self?.loginBtn.enabled = valid
}
.addDisposableTo(disposeBag)
```
* asDriver로 UI 에 subscription 을 만듭니다.
* credentialsValid 는 subscription 을 combine 으로 두 개의 결과를 AND 연산을 통해 활성화 여부를 내보냅니다.
* driveNext 에서 loginBtn 버튼을 활성화 또는 비활성화합니다.

### Observable 버전
```swift
let usernameValid = loginUsernameTextField.rx_text.asObservable().observeOn(MainScheduler.instance).shareReplay(1).map { $0.utf8.count > 0 }
let passwordValid = loginPasswordTextField.rx_text.asObservable().observeOn(MainScheduler.instance).shareReplay(1).map { $0.utf8.count > 0 }

let credentialsValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }.observeOn(MainScheduler.instance)
credentialsValid.subscribeNext { [weak self] valid in
    self?.loginBtn.enabled = valid
    }
.addDisposableTo(disposeBag)
```
* Observer 에게 어떤 Scheduler 를 사용할 것인지 일일이 다 지정을 해줍니다.
* subscription 공유도 설정해줘야 합니다.
* UI 와 관련되었을 때는 Driver 를 통해 작성하는 것이 훨씬 더 간편한 것을 알 수 있습니다.
---

## RxSwift 의 Traits
 Traits는 모든 경계에서 사용할수 있는 원시 Observable과 비교할때 인터페이스 경계에서 observable 프로퍼티를 전달하고 보장하며, 문법적으로도 더 쉽고 구체적인 사용 사례를 타켓팅하는데 도움이 됩니다.(한마디로 코드적으로 간단하고 쉽게 Rx의 흐름을 파악할 수 있도록 도와주는 특성을 가진 객체들입니다.)
> 출처 : https://medium.com/@priya_talreja/rxswift-traits-4408d66cb6ad

### Single
<img height=200 src="https://user-images.githubusercontent.com/44978839/113841524-c1793200-97cc-11eb-8995-283925ee8086.png">

Observable 의 변형으로 일련의 요소를 방출하는 대신 항상 단일 요소 또는 오류를 방출하도록 보장합니다.  
Single의 큰 특징은 아래와 같습니다.
 
* 정확히 하나의 요소 또는 error 를 방출합니다.
* 부수작용을 공유하지 않습니다.
* ex. DB Fetch Operations, Network Requests

ex) 응답, 오류만 반환할 수 있는 HTTP 요청을 수행하는데 사용되지만 단일요소를 사용하여 무한 스트림 요소가 아닌 단일 요소만 관리하는 경우에 사용할 수 있습니다.

```swift
public let isUserValid: Bool = true
private let disposeBag = DisposeBag()
public enum KnownError: Error {
        case notValidUser
}

func getData() -> Single<[String:String]> {
        return Single.create(subscribe: { [weak self] (event) -> Disposable in
            guard let self = self else { return Disposables.create() }
            if self.isUserValid { // Some condition can be added
                event(.success(["name":"John Doe","designation":"iOS Developer"]))
            } else {
                event(.error(KnownError.notValidUser))
            }
            return Disposables.create {
                print("Disposed trait resources")
            }
        })
}

// Subscribe
let single = getData()
single.subscribe(onSuccess: { (value) in
       print("Value is \(value)")
}) { (err) in
       print("Error is \(err.localizedDescription)")
}.disposed(by: disposeBag)
```

*주의사항*
> Stream에서 Single을 사용한다면 Single로 시작해야 합니다. Observable로 시작해서 중간에 asSingle로 바꿔 Single을 엮는다거나 하면 문제가 발생합니다.  
> 이는 Single은 좁은 범위에서의 Observable 이기 때문입니다. Observable은 다량의 next 이벤트를 발행할 수 있으며, complete 또한 발행할 수 있습니다.  
> 하지만 Single은 complete 이벤트를 발행할 수 없습니다. Single의 이벤트인 success 자체가 next, complete 두 개의 속성을 다 포함하고 있기 때문입니다.

### Maybe
<img height=200 src="https://user-images.githubusercontent.com/44978839/113841537-c4742280-97cc-11eb-96a8-e750f37d4f28.png">

Maybe 는 Single 과 Completable 사이에 있는 Observable 의 변형입니다.  
Maybe 의 큰 특징은 아래와 같습니다.
 
* 완료된 이벤트, 싱글 이벤트 또는 오류를 방출합니다. `.success` or `.completed` or `.error`
* 부수작용을 공유하지 않습니다. ??
* 원소를 방출할 필요가 없는 사용 사례에 사용할 수 있습니다.
* ex. Fetching Data from Cache

```swift
private let disposeBag = DisposeBag()
public enum SomeError: Error {
   case genericError(String)
}

let maybe = Maybe<String>.create { event in
    let dividend = Int.random(in: 20...30)
    let divisor = Int.random(in: 0...5)
        
    if divisor == 0 {
       event(.error(SomeError.genericError("Divisor is 0")))
    } else {
       let value = dividend / divisor
       if value > 5 {
          event(.success("Number is greater than 5"))
       } else {
          event(.completed)
       }
    }
    return Disposables.create {
        print("Disposed trait resources")
    }
}

//Subscribe
maybe.subscribe(onSuccess: { (value) in
      print("Value is \(value)")
}, onError: { (err) in
      print("Error is \(err.localizedDescription)")
}) {
      print("Completed Event")
}.disposed(by: disposeBag)
```

### Completable
<img height=200 src="https://user-images.githubusercontent.com/44978839/113841533-c342f580-97cc-11eb-8085-4b1fde20f975.png">

Completable 은 변화무쌍한 Observable 입니다.  
complete 하거나, error 를 방출하고, 아무 요소도 방출하지 않는 것을 보장합니다.  
Completable 은 완료에 따른 요소에 신경쓰지 않은 경우 사용하면 유용합니다.  
요소를 내보낼 수 없는 경우 Observable 을 사용하여 비교할 수 있습니다.

* 제로 요소 방출 (No data)
* 완료 이벤트 또는 에러 방출 `.completed` or `.error`
* 부수작용을 공유하지 않습니다.
* ex. Updating a Cache

```swift
private let disposeBag = DisposeBag()
public enum SomeError: Error {
   case genericError(String)
}

let completable = Completable.create { event in
        let someError = false
        if someError {
            event(.error(SomeError.genericError("Error occurred")))
        } else {
            event(.completed)
        }
        return Disposables.create {
            print("Disposed trait resources")
        }
}

//Subscribe
completable.subscribe(onCompleted: {
       print("Completed Event")
}) { (err) in
       print("Error is \(err.localizedDescription)")
}.disposed(by: disposeBag)
```

## RxCocoa 의 Traits
* ControlProperty: 컨트롤에 data 를 binding 하기 위해 사용
* ControlEvent: 컨트롤의 event 를 수신하기 위해 사용
* Drvier: error 를 방출하지 않고 메인 스레드에서 처리됨
* Signal: Driver 과 거의 동일하나 자원을 공유하지 않음

### RxCocoa 에서 Traits 의 특징
* error 를 방출하지 않는다.
* 메인 스케줄러에서 observe 된다.
* 메인 스케줄러에서 subscribe 된다.
* Signal 을 제외한 나머지 Traits 들은 자원을 공유한다.
* (bind(to:) 메소드는 메인 스레드 실행을 보장한다.)