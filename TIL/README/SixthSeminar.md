# Sixth Seminar

> [2020.03.07]

<br />

# Contents
- [1 단계 | iOS App Extension 이란 무엇인가?](#1-단계)
- [2 단계 | Today Extension 타겟 추가하기](#2-단계)
- [3 단계 | 원하는대로 Widget 만들기](#3-단계)

<br />

## 1 단계
> iOS App Extension 이란 무엇인가?

### 1. [애플에서 허용한 익스텐션 종류](https://developer.apple.com/app-extensions/)
   * **Share**  
      - By providing more sharing options, iOS and macOS enable your app to share photos, videos, websites, and other content with users on social networks and other sharing services.
       
   * **Today**  
      - Your apps can now display widgets in the Today view of Notification Center, providing quick updates or enabling brief tasks. For example, posting updates on package deliveries, the latest surf reports, or breaking news stories.
        
   * **Photo Editing** 
      - Embed your filters and editing tools directly into the Photos or Camera app, so users can easily apply your effects to images and videos.
        
   * **Custom Keyboard**
      - With iOS, you can provide custom keyboards with different input methods and layouts for users to install and use systemwide.
      
   * **File Provider** 
      - You can now provide a document storage location that can be accessed by other apps. Apps that use a document picker view controller can open files managed by the storage provider or move files into the storage provider.
      
   * **Action**   
      - Create your own custom action buttons in the Action sheet to let users watermark documents, add something to a wish list, translate text to a different language, and more.
      
   * **Document Provider**   
      - If you offer remote storage of a user’s iOS documents, you can create an app extension that lets users directly upload and download documents in any compatible app.
      
   * **Finder Sync** 
      - Badge local macOS folders to let users know the status of items that are remotely synced. You can also implement contextual menus to let users directly manage their synced content.
      
   * **Audio** 
      - With Audio Unit Extensions, you can provide audio effects, sound generators, and musical instruments that can be used by Audio Unit host apps and distributed via the App Store.

<br />

### 2. Extension Container

정확한 용어는 Extension Container 이고 다음과 같은 특징을 가진다.

   * **앱이 아니다.**
      - life cycle 과 environment 가 완전히 다르다.
      
   * **애플 framework 코드를 통해서만 접근된다.**
      - 애플 framework 을 통해서만 호출되는 기능들의 집합이며, 호스트앱(host app)이 다이렉트로 익스텐션을 호출하지 못한다.
      - 이 사실만 제외하면 앱처럼 유저 인터페이스도 가질 수 있고, 이를 위한 ViewController, 리소스 등 모두 사용 가능하다.
      
   * **App to app IPC (Inter-Process Communication)가 아니다.**
   
   * **빌드될 때 추가적인 타겟을 통해 따로 빌드되며 설치될 때는 앱과 같이 설치, 삭제될 때도 앱과 함께 삭제된다.**
      - 바이너리 자체도 앱과 독립적이다.
      
   * **실행 시에도 앱과는 완전히 다른 독립 프로세스(process)로 실행되기 때문에 완전히 다른 주소공간(Isolated address space)을 가지게 된다.**

<img width="800" src="https://user-images.githubusercontent.com/44978839/76087510-a5b7c100-5ff9-11ea-96b6-c0e0b3066670.png">

 > 출처 | [Understand How an App Extension Works](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionOverview.html#//apple_ref/doc/uid/TP40014214-CH2-SW2), [MacOS 10.10 & iOS 8 새기능 익스텐션(Extensions) 개념 잡기](https://www.letmecompile.com/extensions-for-macos-10-10-ios-8/)

<br />

## 2 단계
> Today Extension 타겟 추가하기
 
Xcode 프로젝트 생성한 후 File > New > Target  
<img width="200" alt="스크린샷 2020-03-06 오후 2 44 15" src="https://user-images.githubusercontent.com/44978839/76069311-046b4380-5fd6-11ea-89f3-c99ff69894e0.png"> <img width="180" alt="스크린샷 2020-03-06 오후 2 44 28" src="https://user-images.githubusercontent.com/44978839/76069299-003f2600-5fd6-11ea-8bd7-9d261245e29b.png">

iOS 에서 제공되는 Application Extension 을 확인할 수 있다.

<img width="600" alt="스크린샷 2020-03-06 오후 6 14 21" src="https://user-images.githubusercontent.com/44978839/76069521-501ded00-5fd6-11ea-94c4-17d339faa48d.png">

Today Extension 을 검색해서 추가한다.

<img width="600" alt="스크린샷 2020-03-06 오후 2 46 33" src="https://user-images.githubusercontent.com/44978839/76069927-097cc280-5fd7-11ea-8420-55e5afe058ab.png">

Embed In Application 에는 기본적으로 HOST APP(메인 앱)이 선택되어있다.

<img width="600" alt="스크린샷 2020-03-06 오후 6 29 33" src="https://user-images.githubusercontent.com/44978839/76070786-780e5000-5fd8-11ea-8e69-922a070ab9a8.png">

Target 에 Today Extension 이 추가되었는데, 이는 기본적으로 Notification Center framework 내에서 제공하는 기능임을 알 수 있다.

<img width="600" alt="스크린샷 2020-03-06 오후 6 27 18" src="https://user-images.githubusercontent.com/44978839/76070873-9f651d00-5fd8-11ea-8087-c54be8dccd39.png">

Today Extension 의 Display Name 부분에 적는 이름이 실제 앱의 위젯 항목에 나타난다. 

<img width="600" alt="스크린샷 2020-03-06 오후 6 56 29" src="https://user-images.githubusercontent.com/44978839/76072955-32538680-5fdc-11ea-81d4-e9fbc0bdb162.png">

 > Today Extension 과 Weather Framework 사용하여 날씨 위젯 만든 예시
 
 <img width="300" src="https://user-images.githubusercontent.com/44978839/76085913-54f29900-5ff6-11ea-8379-3209de7168e1.gif">

 > 출처 | [Building a Simple Widget for the Today View](https://developer.apple.com/documentation/notificationcenter/building_a_simple_widget_for_the_today_view)

<br />

## 3 단계
> 원하는대로 Widget 만들기

### 1. Taget 을 생성 시 자동 생성되는 파일

기본적으로 스토리보드와 오토레이아웃을 지원하고 있으며 iOS 9.0 이상부터 사용이 가능하지만 대부분 iOS 9.0에서 deprecate 된 함수들이 많아서 iOS Target이 10.0부터 지원되는 앱에서 사용하길 추천한다.

<img width="300" alt="스크린샷 2020-03-06 오후 6 45 04" src="https://user-images.githubusercontent.com/44978839/76072040-9aa16880-5fda-11ea-808a-3c3101a0dcb3.png">

* **TodayViewController.swift**  
      - Contains the source code for the View Controller representing the widget in the Today view
    
* **MainInterface.storyboard**  
      - The storyboard file containing the user interface of the widget as it will appear within the Today view
    
* **Info.plist**  
      - The information property list for the extension.

<br />
 
###  2. 템플릿 코드 살펴보기

아래는 XCode에서 Today Extension Target 생성 시 자동으로 생성되는 템플릿 코드인데, 눈여겨 봐야할 것은 widgetPerformUpdate 메소드이다.
 
 ```swift
import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
}
 ```

NCWidgetProviding 은 NotificationCenter 내부의 프로토콜인데

<img width="850" alt="스크린샷 2020-03-06 오후 7 31 26" src="https://user-images.githubusercontent.com/44978839/76075859-14d4eb80-5fe1-11ea-81d9-c460f33a01fa.png">

> 출처 | [NotificationCenter Framework](https://developer.apple.com/documentation/notificationcenter)


NCWidgetProviding 은 아래와 같은 메소드를 포함한다.

<img width="850" alt="스크린샷 2020-03-06 오후 7 28 18" src="https://user-images.githubusercontent.com/44978839/76075609-a4c66580-5fe0-11ea-9c18-1618676c550f.png">

<br />

## 3 단계
###  3. 원하는대로 Widget 만들기

여기까지 하고 바로 시뮬레이터에서 동작시키면, 기본적으로 MainInterface.storyboard 에 셋팅되어있는 Hello World 라벨만 뜨게 될 것이다.

<img width="600" alt="스크린샷 2020-03-06 오후 8 24 52" src="https://user-images.githubusercontent.com/44978839/76086466-786a1380-5ff7-11ea-94c0-61d957345c38.png">

<img width="300" alt="스크린샷 2020-03-06 오후 8 21 23" src="https://user-images.githubusercontent.com/44978839/76082370-90896500-5fee-11ea-8dc6-0ada0215e43c.png">


이를 아무리 수정하려고 Storyboard 를 만져보아도 Storyboard UI 가 업데이트 되지 않아 난항을 겪었는데, 한번 따라해보자.

> * 1. 위젯의 사이즈를 width = 320, height = 110 으로 조절한다.

 ```
Set the view to 110pts tall and 320pts wide in the Size Inspector. This is the default iPhone widget size.
 ```

<br/>

> * 2. 앱과 위젯 간의 데이타를 update 하는 경우

App extension의 번들이 containing app 번들에 포함되어 있는 구조이기는 하지만, 실행 중인 app extension과 containing app는 각자의 컨테이너에 직접적으로 접근할 수 없다. 사실상 두 앱이 작동되는 것이므로 둘 사이에 데이터를 교환할 필요가 있을 경우에는 App Groups를 사용하여 shared container를 통해 데이터 공유를 가능하게 한다. containing app의 프로젝트 설정 > Capabilities 탭

<br/>

> * 3. 위젯이 “Unable to Load” 뜨는 경우

디바이스나 Simulator 가 실행 중인 상태에서 Xcode > Debug > Attach to Process 들어가서 위젯 이름을 찾는다.

<br />

> * 4. Xib 생성

처음에는 MainInterface.storyboard 에다가 아무리 UI 를 그려도 반영이 되지 않아 무엇이 문제인지 몰랐다.

구글링을 해보니, Custom Widget 과 관련된 모든 포스팅에서 xib 를 생성해서 ViewController 에다가 register 시켜서 사용하는 것을 보고 혹시나 이게 문제일까 싶어 따라했더니 반영되었다.
(정말 이게 문제가 맞는지 원인을 알고 싶다.)

 ```swift
 override func viewDidLoad() {
    super.viewDidLoad()

    // Allow the today widget to be expanded or contracted.
    extensionContext?.widgetLargestAvailableDisplayMode = .expanded

    // Register the table view cell.
    let ddayTableViewCellNib = UINib(nibName: "DdayTableViewCell", bundle: nil)
    tableView.register(ddayTableViewCellNib, forCellReuseIdentifier: DdayTableViewCell.reuseIdentifier)
}
 ```
 
<br/>

## 확인 단계
> 디바이스에서 동작해보기

<img width="400" alt="스크린샷 2020-03-06 오후 9 56 21" src="https://user-images.githubusercontent.com/44978839/76085670-deee3200-5ff5-11ea-8001-cdbe22ec9253.png">
