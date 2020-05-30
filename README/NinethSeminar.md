# Nineth Seminar
> [2020.05.30]

<br />

# Contents
- 셀 안의 버튼을 처리하는 여러가지 방법(#Handling-Button)
- Closure 타입 변수를 선언하여 셀 안의 버튼 처리하기(#Closure-Source-code)

<br />

## Handling Button
TableView 또는 CollectionView 안에 있는 버튼을 처리하기 위한 레퍼런스를 조사하다보니 개발자마다, 상황마다 선호하는 여러가지 방법들이 있었다.

**1. tag 로 처리**

* 장점: 버튼마다 고유한 식별이 가능하고 IBOutlet 선언 대신으로 사용하는 경우 편리학 사용이 가능하다.
* 단점: 애초에 셀의 인덱스를 저장하기 위해 사용되는 것이 아니기 때문에 100개 버튼이면 100개의 태그.. multiple selection하면 악몽 수준

**2. delegate 로 처리**

* 장점: cellForRowAt메서드에 할당해서 row 삽입 / 삭제 가 있는 경우에 indexPath 핸들링에 유리하다.
* 단점: 버튼이나 화면이 많아지면 딜리게이트 프로토콜을 선언하고 뷰 컨트롤러를 상속해야해서 과정이나 네이밍이 귀찮다. 추적하기도 어렵다.

**3. Observer & Notification 로 처리**

* 장점: 느슨한 결합으로 인하여 시스템이 유연해지고, 객체간의 의존성을 제거할 수 있다.
pull 방식이 아닌 push 방식을 사용함으로써 직관적으로 이해하기 쉽습니다.
<p align="center"> 
<img width="600" alt="스크린샷 2020-05-30 오후 11 45 07" src="https://user-images.githubusercontent.com/44978839/83331230-c24d5780-a2cf-11ea-8b9e-b1fcce6ed7ec.png">
</p>

> 출처: https://coloredrabbit.tistory.com/86

* 단점: 너무 많이 사용하게 되면, 콜백헬의 늪에 빠져 상태 관리가 힘들 수 있다. 비동기 방식이기 때문에 이벤트 구독을 원하는 순서대로 받지 못할 수 있다.

**4. call back closure 로 처리**

* 장점: 관련 메서드들이 하나의 클로저안에 모두 있기에 그 안에서만 처리할 수 있다.
* 단점: 각각의 셀이 클로저 변수(버튼이 탭됐을 때 실행할 행동)를 저장하기 위해 메모리에 할당되어야 한다. 이 접근 방법은 함수가 커지면 꽤 많은 메모리를 차지할 수 있다.

<br />

## 내가 처리해야하는 요구사항
<img width=400 src=https://user-images.githubusercontent.com/44978839/83329454-91b3f080-a2c4-11ea-9a98-0efac4a64022.gif>

<br />

## Closure Source code
### 1. UICollectionViewCell.swift
```swift
// input이 없고 void를 반환하는 클로저 타입 변수 선언
var accept : (() -> ()) = {}
var refuse : (() -> ()) = {}
```

```swift
@IBAction func acceptChat(_ sender: UIButton) {
    //Call your closure here
    accept()
}

@IBAction func refuseChat(_ sender: UIButton) {
    refuse()
}
```

### 2. UIViewController.swift
```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestCell", for: indexPath) as! RequestCVCell
    
    // 시작하기 버튼 눌렀을 때 실행할 함수 선언
    cell.accept = { [unowned self] in
        // 1. 새로운 채팅방 개설하기 위해 DB에 채팅 데이터 추가하는 함수 호출
        // 2. DB 에서 요청 데이터 삭제하기
        self.destinationUid = request.userID
        self.createRoom(uid: self.myUid!, destinationUid: request.userID)
        Database.database().reference().child("chatrooms").child(request.chatIdx).removeValue()
        self.requestList.remove(at: indexPath.row)
        self.requestCV.reloadData()
    }
    
    // 거절하기 버튼 눌렀을 때 실행할 함수 선언
    cell.refuse = { [unowned self] in
        // 1. DB 에서 요청 데이터 삭제하기
        Database.database().reference().child("chatrooms").child(request.chatIdx).removeValue()
        self.requestList.remove(at: indexPath.row)
        self.requestCV.reloadData()
    }
    return cell
}
```

## unowned self
* [unowned self] 가 cell.accept / cell.refuse 클로저의 시작 부분에 들어가 있는 것을 볼 수 있다.  

* 이는 뷰 컨트롤러가 테이블 뷰를 소유하고, 테이블 뷰는 셀을 소유하고, 셀은 다시 cell.accept / cell.refuse 클로저를 소유하는 retain 싸이클을 방지해준다.  

* 만약 클로저를 weak/unowned reference 로 만들지 않고 내부에 self 키워드를 사용하게 되면, 다음과 같은 싸이클이 생길 것이다.
> 번역: https://cmindy.github.io/ios/2019/10/04/TableViewCellButton/
> 원문: https://fluffy.es/handling-button-tap-inside-uitableviewcell-without-using-tag/#whynot

<p align="center"> 
<img height=400 src=https://iosimage.s3.amazonaws.com/2018/33-uibutton-uitableviewcell-tap/cycle.png>
</p>

## 참고: Observer & Notification pattern으로 셀 안의 버튼 처리하기
### 1. UICollectionViewCell.swift
```swift
let name = Notification.Name(rawValue: notificationKey")
NotificationCenter.default.post(name: name, object: nil)
```

### 2. UIViewController.swift
```swift
let notificationKey = "acceptButtonPressed"
```

```swift
// class 안에 선언
let accept = Notification.Name(rawValue: "notificationKey")

// observer 를 제때 제거해주지 않으면 메모리 누수가 일어날 수 있다.
deinit{
  NotificationCenter.default.removeObserver(self)
}

func createObservers() {
  NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.createChatrooms), name: accept, object: nil)
}

@objc func createChatrooms(notification: NSNotification) {
  // 실행하고 싶은 함수 구현
}
```
