# Third Supplementary

> [2020.03.07]

<br />

# Contents
- [Firebase 와 연동하기 위한 준비과정](#준비-단계)
- [디바이스에서 테스트해보기](#확인-단계)

<br />

## 준비 단계

1. [Firebase](https://firebase.google.com/?authuser=0) 접속해서 새로운 프로젝트 생성
2. Xcode 프로젝트 열어서 app bundle 추가하고 info.plist 다운로드 후 프로젝트에 추가
3. pod 설치하기
``` 
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for your project
  pod ‘Firebase/Core'
  pod ‘Firebase/RemoteConfig’ 
  pod 'Firebase/Database'
  pod 'Firebase/Auth'
``` 

<br />

4. App delegate 에 아래 코드 추가
```swift
import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:
      [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure() // 이 부분
    return true
  }
}
``` 

<br />

5. RemoteConfig 에서 서버 연결 테스트를 위한 parameter 생성

Xcode 프로젝트 내에서 서버와 연결이 되었을 때 값인지, 로컬 값인지 구분하기 위해서 임시로 parameter 를 생성하여 색상 key 값을 생성한다.  
모든 parameter 추가 후에는 반드시 '변경사항 게시' 버튼을 눌러서 저장해야한다.

<img width="800" alt="스크린샷 2020-03-07 오후 8 49 29" src="https://user-images.githubusercontent.com/44978839/76142886-43bc9180-60b5-11ea-9b61-f8271f7b94b8.png">

<img width="800" alt="스크린샷 2020-03-07 오후 8 55 03" src="https://user-images.githubusercontent.com/44978839/76142959-f391ff00-60b5-11ea-88b0-cb98f4f33613.png">

<br />

6. 스플래시 ViewController 에서 remoteConfig 초기화

```swift
import Firebase

override func viewDidLoad() {
    super.viewDidLoad()

    //remoteConfig 변수 초기화
    remoteConfig = RemoteConfig.remoteConfig()

    let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
    remoteConfig.configSettings = remoteConfigSettings
    remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")	 // 서버랑 연결이 안될 경우 대비 defaults 값
} 
``` 

7. RemoteConfigDefaults 이름의 plist 파일 생성

Firebase RemoteConfig 에 추가했던 parameter 명을 그대로 사용하되, defaults 값을 다르게 설정하여 로컬 값을 부여한다.

<img width="500" alt="스크린샷 2020-03-07 오후 8 54 05" src="https://user-images.githubusercontent.com/44978839/76142960-f4c32c00-60b5-11ea-9841-cc8f635cca5d.png">

<br />

8. 서버 값을 적용받는 코드

expirationDuration 값은 요청하는 시간을 말하는 건데, 0초를 넣게 되면 앱을 킬 때마다 요청하고 3600을 넣으면 한 시간마다 요청하게 된다.

```swift
override func viewDidLoad() {
        super.viewDidLoad()
        
        ...
        
        // 서버 값을 받아오는 부분
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)){(status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched() // 요청이 성공했을 때
            }
            else {
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
            self.displayWelcome()
        }
    }
```

9. 통신이 성공했을 때 메소드 선언

이 부분을 작성할 때, 키 값에서 오타가 있다면 디버그 메시지도 안 뜨고 앱도 안 죽지만 서버와 연결이 안되는 문제가 발생한다.  
반드시 오타 없이 키 값을 잘 명시할 것 !

```swift
func displayWelcome(){
    let color = remoteConfig["splash_background"].stringValue
    let caps = remoteConfig["splash_message_caps"].boolValue
    let message = remoteConfig["splash_message"].stringValue

    // caps 값이 true 이면 앱이 원격으로 종료되게끔
    if(caps) {
        let alert = UIAlertController(title: "공지사항", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            exit(0) // exit이 0 이면 앱이 종료된다.
        }))

        self.present(alert, animated: true, completion: nil)
    }
    self.view.backgroundColor = UIColor(hex: color!)
}
```

10. hex code 컬러 사용하는 extension
> 16 진수 color code 를 사용할 수 있게 된다.
```swift
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
```

## 확인 단계


<img width="400" alt="스크린샷 2020-03-07 오후 9 29 19" src="https://user-images.githubusercontent.com/44978839/76143429-bed47680-60ba-11ea-8b4e-9d6a2cb4c00b.png">
