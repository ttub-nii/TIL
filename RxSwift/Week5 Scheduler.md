# Week5 Scheduler
> Scheduler 에 대해 알아보쟈 !

> 설명은 해당 [깃헙](https://github.com/ReactiveX/RxSwift/blob/main/Documentation/Schedulers.md#serial-vs-concurrent-schedulers)을 참고했습니다.

- [Scheduler](#scheduler-란?)
  - [Do](#do)
  - [Delay](#delay)
  - [ObserveOn](#observeon)
  - [Subscribe](#subscribe)
  - [SubscribeOn](#subscribeon)
  - [Materialize, Dematerialize](#materialize-dematerialize)
  - [TimeOut](#timeout)
  - [Using](#using)

# Scheduler 란?
> 다른 스케쥴러를 지정하는 역할

## Do
## Delay
## ObserveOn
## Subscribe
## SubscribeOn
## Materialize
## Dematerialize
## TimeOut
## Using

---
아래에서 Scheduler 의 종류를 살펴보겠습니다.
## Serial VS Concurrent
> Since schedulers can really be anything, and all operators that transform sequences need to preserve additional implicit guarantees, it is important what kind of schedulers are you creating.

스케줄러는 실제로 무엇이든 될 수 있고(?) 시퀀스를 변환하는 모든 operator 들은 추가적인 암묵적 보증을 보존해야 하므로 어떤 스케줄러를 생성하는지가 중요합니다.

> In case the scheduler is concurrent, Rx's observeOn and subscribeOn operators will make sure everything works perfectly.

스케줄러가 concurrent 인 경우, Rx 의 observeOn 및 subscribOn 연산자는 모든 것이 완벽하게 작동하는지 확인합니다.

> If you use some scheduler that Rx can prove is serial, it will be able to perform additional optimizations.

Rx 가 직렬임을 증명할 수 있는 일부 스케줄러를 사용하면, 추가적으로 최적화를 수행할 수 있습니다.

> So far it only performs those optimizations for dispatch queue schedulers.

그렇지 않으면 디스패치 큐 스케줄러에 대해서만 이러한 최적화를 수행합니다.

> In case of serial dispatch queue schedulers, observeOn is optimized to just a simple dispatch_async call.

직렬 디스패치 큐 스케줄러의 경우, observeOn 은 간단한 dispatch_async 호출에만 최적화되어 있습니다.

## Custom
* current 스케줄러 외에도 스케줄러를 직접 작성할 수 있습니다.
* 작업을 즉시 수행해야 하는 사용자를 설명하려면 ImmediateScheduler 프로토콜을 구현하여 직접 스케줄러를 작성할 수 있습니다.
```swift
public protocol ImmediateScheduler {
    func schedule<StateType>(state: StateType, action: (/*ImmediateScheduler,*/ StateType) -> RxResult<Disposable>) -> RxResult<Disposable>
}
```

* 시간 기반의 작업을 지원하는 새로운 스케줄러를 만들려면, 스케줄러 프로토콜을 구현해야 합니다.
```swift
public protocol Scheduler: ImmediateScheduler {
    associatedtype TimeInterval
    associatedtype Time

    var now : Time {
        get
    }

    func scheduleRelative<StateType>(state: StateType, dueTime: TimeInterval, action: (StateType) -> RxResult<Disposable>) -> RxResult<Disposable>
}
```

* 스케줄러에 주기적인 스케줄링 기능만 있는 경우, PeriodicScheduler 프로토콜을 구현하여 Rx에 알릴 수 있습니다.
* 스케줄러가 PeriodicScheduling 기능을 지원하지 않는 경우, Rx 는 주기적 스케줄링을 투명하게 에뮬레이트합니다.
```swift
public protocol PeriodicScheduler : Scheduler {
    func schedulePeriodic<StateType>(state: StateType, startAfter: TimeInterval, period: TimeInterval, action: (StateType) -> StateType) -> RxResult<Disposable>
}
```

## Built In
Rx 는 모든 유형의 스케줄러를 사용할 수 있지만, 스케줄러가 직렬이라면 추가적인 최적화를 수행할 수도 있습니다.  
현재 지원되는 스케줄러는 다음과 같습니다.

## CurrentThreadScheduler (Serial scheduler)
현재 스레드에서 작업 단위를 예약합니다. elements 를 생성하는 operators 의 기본 스케줄러입니다.
이 스케줄러는 "trampoline scheduler (트램펄린 스케줄러)" 라고도 불립니다.
* 만약 CurrentThreadScheduler.instance.schedule(state) { } 가 어떤 스레드에서 처음으로 호출되면, 스케줄 된 작업이 즉시 실행되며 모든 재귀적으로 스케줄 된 작업이 일시적으로 대기열에 포함되도록 hidden 큐가 생성됩니다.

* 호출 스택의 부모 프레임이 이미 CurrentThreadScheduler.instance.schedule(state) { } 을 실행 중인 경우, 스케줄 된 작업은 현재 실행 중인 작업과 이전에 실행된 모든 작업 실행이 완료되면 대기열에 저장되고 실행됩니다.

## MainScheduler (Serial scheduler)
* 메인 스레드에서 수행해야 하는 작업을 추상화합니다.

* 메인 스레드에서 스케줄 메서드가 호출되는 경우 스케줄링 없이 작업을 즉시 수행합니다.

* 이 스케줄러는 일반적으로 UI 작업을 수행하는 데 사용됩니다.

## SerialDispatchQueueScheduler (Serial scheduler)
* 특정 dispatch_queue_t에서 수행해야 하는 작업을 추상화합니다.

* concurrent 디스패치 큐가 전달되더라도 직렬로 변환하는 것을 보장합니다.

* serial 스케줄러는 observeOn 에 대한 최적화를 가능하게 합니다.

* 메인 스케줄러는 SerialDispatchQueueScheduler 의 인스턴스입니다.


## ConcurrentDispatchQueueScheduler (Concurrent scheduler)
* 특정 dispatch_queue_t 에서 수행해야 하는 작업을 추상화합니다.

* 또한 serial 디스패치 큐를 전달했을 때, 어떠한 문제도 발생하지 않아야 합니다.

* 이 스케줄러는 일부 작업을 백그라운드에서 수행해야 하는 경우에 적합합니다.

## OperationQueueScheduler (Concurrent scheduler)
* 특정 NSOperationQueue 에서 수행해야 하는 작업을 추상화합니다.

* 이 스케줄러는 백그라운드에서 수행해야 하는 큰 작업 덩어리들이 있고 maxConcurrentOperationCount 를 사용하여 동시 처리를 세심하게 작업하려는 경우에 적합합니다.
