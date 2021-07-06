# Week3 Operators
> Operators 에 대해 알아보쟈 !

- [Week3 Operators](#week3-operators)
- [Operators](#operators)
- [Creating Observables](#creating-observables)
- [Transforming Observables](#transforming-observables)

# Operators
Operator는 Rx의 기본 요소, Operator를 사용해 Observable에 의해 방출되는 이벤트를 변환하고 처리하여 대응할 수 있다.

# Creating Observables
Observable 을 생성하는 연산자

### Create
<img width="500" src="https://user-images.githubusercontent.com/44978839/111444626-e9392500-874d-11eb-96c0-47f305b5ae30.png">

* 함수로 Observable 을 처음 생성한다.
```swift
// .just
let disposeBag = DisposeBag()
    
func create() {
    Observable.just(1)
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}
```
```swift
// .of
let disposeBag = DisposeBag()

func create() {
    Observable.of([1,2,3])
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}
```
```swift
// .from
let disposeBag = DisposeBag()

func create() {
    Observable.from([1,2,3])
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}
```


### Deferred
<img width="500" src="https://user-images.githubusercontent.com/44978839/111446484-cdcf1980-874f-11eb-8492-5871b14202d1.png">

* Observer 가 구독하기 전까진 Observable 을 생성하지 않다가 각 Observer 에 대해 새로운 Observable 을 생성한다.

### Empty
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443003-4c29bc80-874c-11eb-864d-5979cb377dfe.png">

* 아무 아이템도 emit 하지 않지만 정상적으로 종료되는 Observable 을 생성한다.
  
### Never
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443356-a591eb80-874c-11eb-920a-7c63625e5567.png">

* 아무 아이템도 emit 하지 않고 종료되지도 않는 Observable 을 생성한다. 

### Throw
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443498-c9edc800-874c-11eb-94ba-454f1aac2d08.png">

* 아무 아이템도 emit 하지 않고 종료될 때 에러를 전달하는 Observable 을 생성한다.
  
### Interval
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443721-ff92b100-874c-11eb-94e1-6020b70ea9fb.png">

* 특정 간격을 두고 integer 시퀀스를 emit 하는 Observable 을 생성한다.
```swift
internal class Interval_Simple
{
    private static void Main()
    {
        IObservable<long> observable = Observable.Interval(TimeSpan.FromSeconds(1));

        using (observable.Subscribe(Console.WriteLine))
        {
            Console.WriteLine("Press any key to unsubscribe");
            Console.ReadKey();
        }

        Console.WriteLine("Press any key to exit");
        Console.ReadKey();
    }
}

/*
Result
0 (after 1s)
1 (after 2s)
2 (after 3s)
3 (after 4s)
*/
```

### Range
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443805-15a07180-874d-11eb-9b62-9ead5d9079f2.png">

* 특정 범위의 sequential 한 정수 값들을 emit 하는 Observable 을 생성한다.

### Repeat
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443910-336dd680-874d-11eb-936f-63562417f7db.png">
<img width="500" src="https://user-images.githubusercontent.com/44978839/111443934-38cb2100-874d-11eb-9db3-0fe08273510b.png">

* 특정 아이템을 여러번 emit 하는 Observable 을 생성한다.

### Timer
<img width="500" src="https://user-images.githubusercontent.com/44978839/111444227-8051ad00-874d-11eb-9a3d-af653ecd67c1.png">

* 특정 시간만큼 지연 후에 특정 아이템을 emit 하는 Observable 을 생성한다.
```swift
internal class Timer_Simple
{
    private static void Main()
    {
        Console.WriteLine(DateTime.Now);

        var observable = Observable.Timer(TimeSpan.FromSeconds(5), 
                                                       TimeSpan.FromSeconds(1)).Timestamp();

        // or, equivalently
        // var observable = Observable.Timer(DateTime.Now + TimeSpan.FromSeconds(5), 
        //                                                TimeSpan.FromSeconds(1)).Timestamp();

        using (observable.Subscribe(
            x => Console.WriteLine("{0}: {1}", x.Value, x.Timestamp)))
        {
            Console.WriteLine("Press any key to unsubscribe");
            Console.ReadKey();
        }

        Console.WriteLine("Press any key to exit");
        Console.ReadKey();
    }
}

/*
Result
03/12/2021 10:02:29
Press any key to unsubscribe
0: 03/12/2021 10:02:34(after 5s)
1: 03/12/2021 10:02:35 (after 6s)
2: 03/12/2021 10:02:36 (after 7s)
*/
```

# Transforming Observables
Observable에서 emit 되는 이벤트를 다른 이벤트로 변형하는 연산자

### Map
<img width="500" src="https://user-images.githubusercontent.com/44978839/111440150-6a41ed80-8749-11eb-9434-ee7ab0564503.png">

* 함수가 적용된 결과값을 emit 하는 Observable 을 반환한다.
* Observable에서 작동된다는 점을 제외하면 Swift 표준의 map 고차함수와 같다.

### FlatMap
<img width="500" src="https://user-images.githubusercontent.com/44978839/111439970-39fa4f00-8749-11eb-8f44-c1d90af5b32f.png">

* 이벤트 시퀀스를 다른 이벤트 시퀀스로 변형
* Observable sequence의 각 요소를 Observable sequence에 투영하고 Observable sequence를 Observable sequence로 병합한다.
* 쉽게 말하면 Observable의 이벤트를 받아 새로운 Observable로 변환한다.

### GroupBy
<img width="500" src="https://user-images.githubusercontent.com/44978839/111440341-95c4d800-8749-11eb-91ee-44e7dfd2683d.png">

* 기존 Observable 에서 다른 subset 들을 각각 emit 하는 Observable 집합체로 나눈다.

### Buffer
<img width="500" src="https://user-images.githubusercontent.com/44978839/111440460-b856f100-8749-11eb-9be5-ed5da7291c66.png">

* 주기적으로 Observable 에서 emit 된 아이템을 묶고 묶음 단위로 emit 한다.
