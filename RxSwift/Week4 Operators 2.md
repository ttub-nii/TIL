# Week4 Operators 2
> Operators 에 대해 알아보쟈 2 !

> Code example 은 해당 [사이트](https://usinuniverse.bitbucket.io/blog/filteringoperator.html)를 참고했습니다.

- [Filtering Observables](#filtering-observables)
    - [Debounce](#debounce)
    - [Throttle](#throttle)
    - [DistinctUntilChanged](#distinctuntilchanged)
    - [ElementAt](#elementat)
    - [Filter](#filter)
    - [First](#first)
    - [IgnoreElements](#ignoreelements)
    - [Last](#last)
    - [Sample](#sample)
    - [Skip](#skip)
    - [Take](#take)
- [Combining Observables](#combining-observables)
    - [CombineLatest](#combinelatest)
    - [WithLatestFrom](#withlatestfrom)
    - [Merge](#merge)
    - [SwitchLatest](#switchlatest)
    - [Zip](#zip)
    - [Concat](#concat)
    - [Amb](#amb)
    - [StartWith](#startwith)

# Filtering Observables
> Operators that selectively emit items from a source Observable.

Observable (stream) 에서 선택적으로 아이템을 emit 추출? 해오는 Operators

### Debounce
> only emit an item from an Observable if a particular timespan has passed without it emitting another item

<img width=500 src="https://user-images.githubusercontent.com/44978839/111897775-27438b00-8a65-11eb-9a54-4b4e226eea8a.png">

* 지정한 시간 범위 이내의 방출된 마지막 이벤트를 기준으로 지정한 시간이 지난 이후 가장 최근의 이벤트만을 흘려보냅니다. 
* 위 그림에서 지정된 시간(timespan)이 1초라고 가정했을 때, 1이 방출되고 1초가 흐른 후 스트림으로 1이 흘려보내진 것을 알 수 있습니다.
* 마찬가지로, 1초 안에 2,3,4,5 이벤트가 발생했을 때, 2,3,4의 데이터는 무시되고 가장 마지막 이벤트인 5만 흘려보내진 것을 알 수 있습니다.
```swift
let buttonTap = Observable<String>.create { observer in
    DispatchQueue.global().async {
        for i in 1...10 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.3) 
            // 0.3초 주기마다 Tap \(i) 이벤트 전달, debounce의 파라미터가 1초이기 때문에 모두 무시
        }
        
        Thread.sleep(forTimeInterval: 1) 
        // 여기에서 1초가 지났으므로 마지막 이벤트인 next(Tap 10)이 전달
        
        for i in 11...20 {
            observer.onNext("Tap \(i)")
            Thread.sleep(forTimeInterval: 0.5) 
            // 0.5초 주기마다 Tap \(i) 이벤트 전달, debounce의 파라미터가 1초이기 때문에 모두 무시
        }
        // 이후 1초 동안 새로운 이벤트가 없기 때문에 마지막 이벤트 next(Tap 20)이 전달되고 completed 된다.
        observer.onCompleted()
    }
    
    return Disposables.create {
        
    }
}

buttonTap
    .debounce(.seconds(1), scheduler: MainScheduler.instance) // 마지막 이벤트가 방출된지 1초가 지나야만 이벤트를 전달한다.
    .subscribe { print($0) } // next(Tap 10) -> next(Tap 20) -> completed
```

### Throttle
> 
* Debounce와 달리 이벤트가 발생하면 일단 흘려보냅니다. 그리고 지정된 시간 안에 발생된 이벤트는 무시되고 시간이 지난 이후(타이머가 만료된 이후) 2번째 latest 인자에 따라 결과가 달라집니다.
* latest가 true이면 trottle에서 지정해준 타이머가 끝나는 시점에 발행된 마지막 값을 가져오고 false면 가져오지 않습니다.
```swift
Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(5)
    .throttle(.seconds(2), latest: true, scheduler: MainScheduler.instance)
    .subscribe { print($0) } // next(0) -> next(4) -> completed

Observable<Int>.interval(.milliseconds(300), scheduler: MainScheduler.instance)
    .take(5)
    .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
    .subscribe { print($0) } // next(0) -> completed
```
  * 예를 들어볼까요? 2번째 latest 인자값이 만약에,
  * latest == true : 타이머가 돌아가던 중에 발생했던 이벤트들 중 가장 마지막 이벤트(즉, 최신 이벤트)가 전달됩니다. 이후 다시 타이머가 돌아갑니다. 만약 타이머가 돌아가던 도중 이벤트가 발생하지 않았다면 아무런 이벤트가 발생하지 않고, 다음 이벤트가 발생할 때에 그 이벤트를 내보내고 타이머가 돌아갑니다.  
  <img width=500 src="https://user-images.githubusercontent.com/44978839/112245785-e6ca5400-8c94-11eb-93e4-cb5648ecca28.png">
  
  * latest == false : 타이머만 만료되고 아무일도 일어나지 않습니다. 이후에 이벤트가 발생하면, 해당 이벤트를 방출하고 타이머가 돌아갑니다.  
  <img width=500 src="https://user-images.githubusercontent.com/44978839/112245807-f8abf700-8c94-11eb-9a20-bea3e1bccf54.png">

---
### Debounce VS Throttle
* 공통점 : 타이머 시간을 지정할 수 있음
* 차이점 : Debounce 는 '마지막' 이벤트를 기준으로, Throttle 은 '트리거 된 최초' 이벤트를 기준으로
---

### DistinctUntilChanged
> The Distinct operator filters an Observable by only allowing items through that have not already been emitted.

<img width=500 src="https://user-images.githubusercontent.com/44978839/112246091-76700280-8c95-11eb-9cd7-cf5f22943711.png">

* 연달아 중복된 값이 올 때 무시합니다.  
* 동일한 항목이 연속적으로 방출되지 않도록 방지하는 연산자입니다.
* 바로 전 방출된 요소가 동일한지 여부만 신경씁니다.
```swift
Observable
    .from([1, 1, 1, 1, 1, 2, 1, 2, 2, 1, 1, 2])
    .distinctUntilChanged()
    .subscribe { print($0) } // next(1) -> next(2) -> next(1) -> next(2) -> next(1) -> next(2) -> completed
```

### ElementAt
> emit only item n emitted by an Observable

<img width="500" src="https://user-images.githubusercontent.com/44978839/112246375-e41c2e80-8c95-11eb-8e6f-bc4a6cb76d02.png">

* 특정 인덱스에 위치한 값을 전달합니다.
```swift
Observable
    .from([1, 2, 3, 4, 5])
    .elementAt(1)
    .subscribe { print($0) } // next(2) -> completed
```

### Filter
> emit only those items from an Observable that pass a predicate test
```swift
Observable
    .from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    .filter { $0.isMultiple(of: 3) }
    .subscribe { print($0) } // next(3) -> next(6) -> next(9) -> completed
```
### First
> emit only the first item, or the first item that meets a condition, from an Observable

### IgnoreElements
> do not emit any items from an Observable but mirror its termination notification

* 모든 이벤트를 무시하고 completed 혹은 error 이벤트만을 전달합니다.
* 주로 이벤트의 성공, 실패 여부에만 관심이 있는 경우 사용합니다.
```swift
let observable = Observable.from([1, 2, 3, 4, 5, 6, 7])
observable
    .ignoreElements()
    .subscribe { print($0) } // completed
```

### Last
> emit only the last item emitted by an Observable
### Sample
> emit the most recent item emitted by an Observable within periodic time intervals

### Skip
> suppress the first n items emitted by an Observable
* 파라미터로 전달된 정수만큼 skip 합니다.
```swift
Observable
    .from([1, 2, 3, 4, 5, 6])
    .skip(5) // 총 5회까지 무시
    .subscribe { print($0) } // next(6) -> completed
```

### skipWhile
* 클로져에서 true를 리턴하는 동안 skip 합니다.
* 한 번 false 리턴하게 되면 더 이상 조건을 판단하지 않습니다.
```swift
Observable
    .from([1, 2, 3, 4, 5, 6])
    .skipWhile({ $0 <= 4 })
    .subscribe { print($0) } // next(5) -> next(6) -> completed
```

### skipUntil
* Observable을 파라미터로 받는데, 이 Observable이 next 이벤트를 전달하기 전까지 원본 Observable이 전달하는 이벤트를 무시합니다.
```swift
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject
    .skipUntil(trigger)
    .subscribe { print($0) }

subject.onNext(1) // 무시
trigger.onNext(5) // 무시 (trigger가 next 이벤트를 전달했지만 publishPusbject는 이미 이벤트가 업)
subject.onNext(2) // next(2)
```

### skipLast
> suppress the last n items emitted by an Observable

<img width=500 src="https://user-images.githubusercontent.com/44978839/112303848-20747c80-8ce0-11eb-909f-7f712d7df0ba.png">

### Take
> emit only the first n items emitted by an Observable
* take는 skip의 정반대 개념입니다.
* skip은 처음 발생하는 n개의 이벤트를 무시하는 기능이었다면, take는 처음 발생하는 n개의 이벤트만 받고 나머지는 무시합니다.

<img width="500" alt="take" src="https://user-images.githubusercontent.com/44978839/112304103-6fbaad00-8ce0-11eb-93f5-a194e9e9ef41.png">

### takeWhile
<img width=500 src="https://user-images.githubusercontent.com/44978839/112304329-b4dedf00-8ce0-11eb-947e-613a1f9ab9c3.png">

* `skipWhile(_:)` 연산자와 반대로 조건이 false가 되기 전까지 모든 이벤트를 전달합니다.
* 한 번 false를 리턴하게 되면 더 이상 값을 전달하지 않습니다.
```swift
Observable
    .from([1, 2, 3, 4, 5])
    .takeWhile({ $0 <= 3 })
    .subscribe { print($0) } // next(1) -> next(2) -> next(3) -> completed
```

### takeUntil
<img width=500 src="https://user-images.githubusercontent.com/44978839/112305187-bceb4e80-8ce1-11eb-9ce8-8f3cbfd65a8e.png">

* `skipUntil(_:)` 연산자와 반대로 trigger가 next 이벤트를 전달하기 전까지 모든 이벤트를 전달합니다.
```swift
let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject
    .takeUntil(trigger)
    .subscribe { print($0) }

subject.onNext(1) // next(1)
subject.onNext(2) // next(2)
trigger.onNext(5) // completed
subject.onNext(3) // 무시
```

### takeLast
> emit only the last n items emitted by an Observable

<img width="640" alt="takeLast n" src="https://user-images.githubusercontent.com/44978839/112305353-ee641a00-8ce1-11eb-85ef-b4903cc3e9ce.png">

* 파라미터로 전달된 정수만큼 가지고 있다가 Observable이 completed가 되는 순간 전달합니다.
* 반대로 error 이벤트는 error만 전달한다.
```swift
let subject = PublishSubject<Int>()
subject
    .takeLast(3)
    .subscribe { print($0) }

subject.onNext(1)
subject.onNext(2)
subject.onNext(3)
subject.onNext(4)
subject.onCompleted() // next(2) -> next(3) -> next(4) -> completed

enum CustomError: Error {
    case error
}

let subject2 = PublishSubject<Int>()
subject2
    .takeLast(3)
    .subscribe { print($0) }

subject2.onNext(1)
subject2.onNext(2)
subject2.onNext(3)
subject2.onNext(4)
subject2.onError(CustomError.error) // error(error)
```

# Combining Observables
>
combining 은 연결고리가 있는 몇가지 이벤트들을 같이 처리해야 할 때 사용할 수 있습니다.
* url request 두 개의 응답을 받아서 처리하고 싶을 때
* 아이디, 비밀번호 입력을 받고 각각의 이벤트들을 섞어서 유효성을 검사하고 싶을 때

### CombineLatest
> when an item is emitted by either of two Observables, combine the latest item emitted by each Observable via a specified function and emit items based on the results of this function
* 2개의 sequence 가 하나의 시퀀스로 결합됩니다.
* 합쳐진 sequence 는 sub sequence 에서 이벤트가 발생할 때마다, 이벤트를 발생시킵니다.
* 합쳐진 sequence 는 두 sub sequence 의 Element 를 조합하여 새로운 Element 를 전달합니다.
```swift
let left = PublishSubject<String>() 
let right = PublishSubject<String>()

// 하나로 합쳐진 sequence 생성
let observable = Observable.combineLatest(left, right, resultSelector: { (lastLeft, lastRight) in 
    "\(lastLeft) \(lastRight)" 
})
let disposable = observable.subscribe(onNext: { (string) in print(string) })

print("> Sending a value to Left") 
left.onNext("Hello,") 
print("> Sending a value to Right") 
right.onNext("world") 
print("> Sending another value to Right") 
right.onNext("RxSwift") 
print("> Sending another value to Left") 
left.onNext("Have a good day,")

disposable.dispose()

/*
> Sending a value to Left 
> Sending a value to Right 
Hello, world 
> Sending another value to Right 
Hello, RxSwift 
> Sending another value to Left 
Have a good day, RxSwift
*/
```

* 깔끔하게 코드 쓰는 작성 예시
```swift
let observable = Observable.combineLatest(left, right, { ($0, $1) }.filter { !$0.0.isEmpty }
```

### WithLatestFrom
* 두 개의 Observable 을 합성하지만, 한 쪽 Observable 의 이벤트가 발생할 때에 합성해줍니다.
* 합성할 다른 쪽 이벤트가 없다면 이벤트는 스킵됩니다.
```swift
// 직원은 4명이며, 중간에 잭은 3타임을 일한다. 파트타임 시간 간격은 2시간
let employee = Observable<Int>.interval(2, scheduler: MainScheduler.instance).take(6).map {
    ["tom", "jhon", "jack". "", "", "park"][$0]
}.filter {
    !$0.isEmpty
}

// 임금은 1시간 단위로 10달러를 지급하며, 현재 출근해 있는 직원에게 지급한다.
let payWard = Observable<Int>.interval(1, scheduler: MainScheduler.instance).take(12).map {
    ("\($0)o'clock", "$10")
}

payWard.withLastestFrom(employee, resultSelector: {
    (pay: (String, String), name: String) in
    return (pay.0, pay.1, name)
}).subscribe(onNext: {
    event in
    print(event)
}).disposed(by: disposeBag)
```

### Merge
* 같은 타입의 이벤트를 발생하는 Observable 을 합성하는 함수이며, 각각의 이벤트를 모두 수신할 수 있습니다.
```swift
// 블루팀과 레드팀의 선수들이 계주를 한다.
// 레드팀의 선수들은 1초에 한번 트랙을 돌고, 블루팀은 2초에 한번 돈다.
// 각 팀의 선수가 출발하는 모든 시간을 기록해두고 싶다고 가정하면 모든 이벤트의 시간을 측정하면 된다.
// merge 를 사용하면 두 Observable 모든 이벤트가 발생할 때 처리가 가능하다.

let readTeam = Observable<Int>.interval(1, scheduler: MainScheduler.instance).map { "red : \($0)}
let blueTeam = Observable<Int>.interval(2, scheduler: MainScheduler.instance).map { "blue : \($0)}

let startTime = Date().timeIntervalSince1970
Observable.of(redTeam, blueTeam).merge().subscribe {
    event in
    print("\(event): \(Int(Date().timeIntervalSince1970 - startTime))")
}.disposed(by: disposeBag)
```

### SwitchLatest
* Observable 을 switch 할 수 있는 Observable 입니다.
* 이벤트를 수신하고 싶은 Observable 로 바꾸면 해당 이벤트가 발생하는 것을 수신할 수 있습니다.

### Zip
* 두 Observable 의 발생 순서가 같은 이벤트를 조합해서 이벤트를 발생합니다.
* 이벤트가 조합되지 않으면 이벤트가 발생하지 않는 것에 주목!
```swift
// 결혼식장에서 신랑과 신부가 함께 식장으로 들어가는 이벤트를 만들었다.
// 각 대기실에서 신랑과 신부가 순서대로 나오면 합쳐서 입장한다.

let boys = Observable.from(["tom", "jhon", "jack"])
let girls = Observable.from(["annie", "amanda", "jane"])

Observable.zip(boys, girls) {
    ($0, $1)
}.subscribe {
    event in
    print(event)
}.disposed(by: disposeBag)

/*
next(("tom", "annie"))
next(("jhon", "amanda"))
next(("jack", "jane"))
*/
```

### Concat
* 2개 이상의 Observable 을 직렬로 연결합니다.
* 하나의 Observable 이 완료될 때까지 그 이벤트들을 전달하고 완료가 되면 그 다음 Observable 의 이벤트를 연이어 전달합니다.
* 두 번째 Observable 이 complete 되면 종료됩니다.
```swift
// 콘서트 장에서 골드 좌석 티켓을 가진 사람들이 우선 입장하고
// 일반석 티켓은 이 다음에 입장한다.

let gold = Observable.from(["tom", "jhon", "jack"])
let normal = Observable.from(["annie", "amanda", "jane"])

gold.concat(normal).subscribe {
    event in
    print(event)
}.disposed(by: disposeBag)

/*
next(tom)
next(jhon)
next(jack)
next(annie)
next(amanda)
next(jane)
*/
```

### Amb
* 맨 처음 발생한 Observable 의 이벤트만 사용합니다.
> 내가 이해안되서 추가하는 시나리오 예시
* 111언제 쓰느냐? 많은 서버 연결 시도 중, 가장 먼저 응답을 준 서버와 통신을 계속한다 이런 시나리오에 적합한 operator 라고 볼 수 있다.
* 222언제 쓰느냐? 네트워크 통신 시, network observables 과 timeout observables 가 있을 때 더 빨리 들어오는 것만 처리하겠다. timeout 이 먼저 들어오면 그냥 timeout 시키고 끝내버리겠다! 요런식
```swift
// 플레이어 A 는 5초, B 는 2초, C 는 3초 뒤에 이벤트가 발생한다.
// B 가 가장 먼저 이벤트가 발생했으므로 B 의 이벤트만 받는다.
// 다른 A, C 의 이벤트는 전달되지 않는다.

let playerA = Observable<Int>.interval(5, scheduler: MainScheduler.instance).map { "matched player A: \($0)" }
let playerB = Observable<Int>.interval(2, scheduler: MainScheduler.instance).map { "matched player B: \($0)" }
let playerC = Observable<Int>.interval(3, scheduler: MainScheduler.instance).map { "matched player C: \($0)" }

playerA.amb(playerB).amb(playerC).subscribe(onNext: {
    event in
    print(event)
}).disposed(by: disposeBag)

/*
matched player B : 0
matched player B : 1
*/
```

### StartWith
* 처음 이벤트 값을 넣어줄 수 있습니다.
```swift
let peoples = Observable.from(["spider man", "iron man"])

peoples.startWith("super hero").debug().subscribe().disposed(by: disposeBag)

/*
(startWithTest()) -> subscribed
(startWithTest()) -> Event next(super hero)
(startWithTest()) -> Event next(spider man)
(startWithTest()) -> Event next(iron man)
(startWithTest()) -> Event completed
(startWithTest()) -> isDisposed
*/
```