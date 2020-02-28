# Fifth Seminar

> [2020.02.29]

<br />

# Contents
- [준비 단계 | Push 인증서 발급 받기](#준비-단계)
- [실행 단계 | Push 테스트 해보기](#실행-단계)
- [확인 단계 | 디바이스에서 동작해보기](#확인-단계)

<br />

## 준비 단계
> Push 인증서 발급 받기  

### 1. Login Apple Development Account
   - ref | https://developer.apple.com
   - Click Add button next to Certificates

### 2. Usage Example
   <div>
  <img width="242" alt="스크린샷 2020-02-29 오전 1 38 03" src="https://user-images.githubusercontent.com/44978839/75567046-2f184200-5a94-11ea-8915-418c3431f959.png">

<br />

### 3. Usage

> *  1. Select type of certificate
 
 <img width="800" alt="스크린샷 2020-02-29 오전 1 39 53" src="https://user-images.githubusercontent.com/44978839/75567160-6686ee80-5a94-11ea-8cff-875810c1d5ec.png">

Apple Push Notification service 라고 적혀있는 것이 두 가지가 보이는데,  
Sandbox 만 있는 것이 Development(개발용), 
아래에 있는 것이 모두 포함한 Production(앱스토어용) 으로 분리되어있다. 필요에 따라 생성하면 되는데, 우선 Development용을 발급받는다.

 <br />
 
> *  2. Choose Platform and AppID
 
 <img width="500" alt="스크린샷 2020-02-29 오전 1 44 27" src="https://user-images.githubusercontent.com/44978839/75567540-0d6b8a80-5a95-11ea-9e0b-5c060ebccc7f.png">  

나의 개발자 계정으로 생성한 프로젝트들이 자동으로 로드되고, 이 중에서 발급받을 AppID를 선택한다.  

 <br />

> * 3. Create CSR

<img width="500" alt="스크린샷 2020-02-29 오전 1 46 51" src="https://user-images.githubusercontent.com/44978839/75567824-7f43d400-5a95-11ea-8c05-37b65d532d45.png">  

개발자 계정을 발급받기 위해선 CSR(인증서 서명 요청)이 필요하다.  
Mac의 키체인 접근을 통해 CSR(인증서 서명 요청)을 생성할 수 있다.

<img width="600" alt="스크린샷 2020-02-29 오전 1 50 22" src="https://user-images.githubusercontent.com/44978839/75568885-72c07b00-5a97-11ea-9669-108cc49c676e.png">  

⌘(cmd)+space 를 누르면 Spotlight 검색이 가능한데, 키체인 접근을 실행시킨다.

<img width="300" alt="스크린샷 2020-02-29 오전 1 53 11" src="https://user-images.githubusercontent.com/44978839/75569023-ac918180-5a97-11ea-8a44-e106fdac3d6f.png"> <img width="450" alt="스크린샷 2020-02-29 오전 1 53 16" src="https://user-images.githubusercontent.com/44978839/75569031-b0bd9f00-5a97-11ea-9700-1340ace65d0f.png">  

'키체인 접근 > 인증서 지원 > 인증 기관에서 인증서 요청'을 선택한다.

<img width="600" alt="스크린샷 2020-02-29 오전 1 55 42" src="https://user-images.githubusercontent.com/44978839/75569140-e82c4b80-5a97-11ea-8eb5-899930e30707.png">  

그러면 위 창이 뜨는데, 일반 이름 필드에 키 이름을 입력하고 CA 이메일 주소 필드는 비워둔 뒤 ‘디스크에 저장됨’을 선택한다.  
*참고: Apple Pay 지불 처리 인증서를 생성하는 경우에는 키 쌍 정보를 명시해야한다. ECC 및 256비트 키 쌍을 선택한다. 중국용 Apple Pay 지불 처리 인증서에는 키 쌍을 명시할 필요가 없다.*

<img width="600" alt="스크린샷 2020-02-29 오전 1 55 56" src="https://user-images.githubusercontent.com/44978839/75569143-eb273c00-5a97-11ea-89a0-adb9cbc1b0c9.png">

성공적으로 인증서를 요청하여 생성했다.

 <br />
 
> * 4. Choose CSR file and download Certificate

<img width="900" alt="스크린샷 2020-02-29 오전 2 11 02" src="https://user-images.githubusercontent.com/44978839/75569587-bd8ec280-5a98-11ea-953d-aa05f1f09e3a.png">  

Push 인증서를 발급 받았다.  
참고로 Push 인증서는 앱 인증서처럼 개발 맥북에 등록하여 사용하는 것이 아니고, iOS앱에 Push Notification을 발생시킬 때 사용한다. 그리고 발급 받은 aps_development.cer 파일을 더블 클릭하면 키체인 접근에 등록이 된다. <push 테스트를 위해서라도 반드시 해야한다.>

<br/>

> * 5. XCode 프로젝트 설정

<img width="600" alt="스크린샷 2020-02-29 오전 2 17 21" src="https://user-images.githubusercontent.com/44978839/75570137-df3c7980-5a99-11ea-99ba-681c5f69f340.png">

이제 XCode를 열고 '프로젝트 파일 > Capabilities 탭' 으로 들어가면 Push Notifications가 추가되어있는 것을 볼 수 있다.

<br/>

## 실행 단계
> Push 테스트 해보기

<br/>

> *  1. Get Push Permission

 AppDelegate파일의 didFinishLaunchingWithOptions 메소드에 다음의 코드를 작성한다.  
 
 ```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     // Override point for customization after application launch.

     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
         (granted, error) in
         guard granted else { return }
         DispatchQueue.main.async {
             application.registerForRemoteNotifications()
         }
     }
     return true
 }
  ```

<img width="400" alt="스크린샷 2020-02-29 오전 2 29 26" src="https://user-images.githubusercontent.com/44978839/75570829-56264200-5a9b-11ea-9700-ac2961167cc0.png">

Push도 위치 정보, 사진 정보 등과 같이 Native를 활용하기 때문에 사용자의 권한 동의가 필요하다.  
위의 코드를 넣으면 앱 실행시 사용자에게 다음과 같은 Alert으로 알람 동의를 얻는다.

 <br />
 
 > *  2. Check Device Token

디바이스 토큰 확인을 위해 AppDelegate파일에 didRegisterForRemoteNotificationsWithDeviceToken 메소드를 오버라이드 한다.
*참고: 시뮬레이터에서는 다르게 동작할 수 있기 때문에 정확한 테스트를 위해 실제 디바이스에서 진행해야 한다.*

 ```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("device token: \(tokenString)")
 }
  ```

앱을 실행하고 Push 권한을 허용하면 콘솔창에 로그가 찍힌다.

 <br />
 
 > *  2. Push Test
 
AppStore에서 EasyAPN 을 설치한다.  
 
 <img width="300" alt="스크린샷 2020-02-29 오전 2 39 10" src="https://user-images.githubusercontent.com/44978839/75571731-1a8c7780-5a9d-11ea-8d6f-8718002d298e.png">

키체인에 Push Certificate 을 더블 클릭하여 등록하였기 때문에 선택할 수 있다.  

<img width="800" alt="스크린샷 2020-02-29 오전 2 59 43" src="https://user-images.githubusercontent.com/44978839/75573370-072edb80-5aa0-11ea-91d6-fe2b80039268.png">

그리고 Device Token 부분에 토큰 키 값을 입력한다.  
payload 부분에는 아래와 같이 명시하고 Send 버튼을 누른다.

```Json
{
	"aps" : 
	{
		"alert" : "You have a notification",
		"badge" : 1,
		"sound" : "default"
	}
}
```

*참고: [APNS Payload](https://distriqt.github.io/ANE-PushNotifications/m.iOS%20APNS%20Payload): 알림 메시지, 뱃지 숫자, 소리를 동반하는 가장 단순한 형태의 payload 이다.*

<br/>

## 확인 단계
> 디바이스에서 동작해보기

<img width="400" src="https://user-images.githubusercontent.com/44978839/75576810-fed89f80-5aa3-11ea-9cbf-48ec05f58a02.jpeg"> <img width="400" src="https://user-images.githubusercontent.com/44978839/75574776-3e9e8780-5aa2-11ea-9523-8befd3112b7d.jpeg">
