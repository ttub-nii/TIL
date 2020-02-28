## Fifth Seminar

> [2020.02.29]

1. Login Apple Development Account
   - ref | https://developer.apple.com
   - Click Add button next to Certificates
<br />

2. Usage Example
   <div>
  <img width="242" alt="스크린샷 2020-02-29 오전 1 38 03" src="https://user-images.githubusercontent.com/44978839/75567046-2f184200-5a94-11ea-8915-418c3431f959.png">

<br />

3. Usage

> *  1. Select type of certificate
 
 <img width="500" alt="스크린샷 2020-02-29 오전 1 39 53" src="https://user-images.githubusercontent.com/44978839/75567160-6686ee80-5a94-11ea-8cff-875810c1d5ec.png">

Apple Push Notification service 라고 적혀있는 것이 두 가지가 보이는데,  
Sandbox 만 있는 것이 Development(개발용), 
아래에 있는 것이 모두 포함한 Production(앱스토어용) 으로 분리되어있다.  
필요에 따라 생성하면 되는데, 우선 Development용을 발급받는다.

 <br />
 
> *  2. Choose Platform and AppID
 
 <img width="500" alt="스크린샷 2020-02-29 오전 1 44 27" src="https://user-images.githubusercontent.com/44978839/75567540-0d6b8a80-5a95-11ea-9e0b-5c060ebccc7f.png">  

나의 개발자 계정으로 생성한 프로젝트들이 자동으로 로드되고, 이 중에서 발급받을 AppID를 선택한다.  

 <br />

> * 3. Create CSR

<img width="500" alt="스크린샷 2020-02-29 오전 1 46 51" src="https://user-images.githubusercontent.com/44978839/75567824-7f43d400-5a95-11ea-8c05-37b65d532d45.png">  

개발자 계정을 발급받기 위해선 CSR(인증서 서명 요청)이 필요하다.  
Mac의 키체인 접근을 통해 CSR(인증서 서명 요청)을 생성할 수 있다.

<img width="500" alt="스크린샷 2020-02-29 오전 1 50 22" src="https://user-images.githubusercontent.com/44978839/75568885-72c07b00-5a97-11ea-9669-108cc49c676e.png">  

⌘(cmd)+space 를 누르면 Spotlight 검색이 가능한데, 키체인 접근을 실행시킨다.

<img width="200" alt="스크린샷 2020-02-29 오전 1 53 11" src="https://user-images.githubusercontent.com/44978839/75569023-ac918180-5a97-11ea-8a44-e106fdac3d6f.png"> <img width="300" alt="스크린샷 2020-02-29 오전 1 53 16" src="https://user-images.githubusercontent.com/44978839/75569031-b0bd9f00-5a97-11ea-9700-1340ace65d0f.png">  

'키체인 접근 > 인증서 지원 > 인증 기관에서 인증서 요청'을 선택한다.

<img width="500" alt="스크린샷 2020-02-29 오전 1 55 42" src="https://user-images.githubusercontent.com/44978839/75569140-e82c4b80-5a97-11ea-8eb5-899930e30707.png">  

그러면 위 창이 뜨는데, 일반 이름 필드에 키 이름을 입력하고 CA 이메일 주소 필드는 비워둔 뒤 ‘디스크에 저장됨’을 선택한다.  
*참고* Apple Pay 지불 처리 인증서를 생성하는 경우에는 키 쌍 정보를 명시해야한다. ECC 및 256비트 키 쌍을 선택한다. 중국용 Apple Pay 지불 처리 인증서에는 키 쌍을 명시할 필요가 없다.

<img width="500" alt="스크린샷 2020-02-29 오전 1 55 56" src="https://user-images.githubusercontent.com/44978839/75569143-eb273c00-5a97-11ea-89a0-adb9cbc1b0c9.png">

성공적으로 인증서를 요청하여 생성했다.

 <br />
 
> * 4. Choose CSR file and download Certificate

<img width="800" alt="스크린샷 2020-02-29 오전 2 11 02" src="https://user-images.githubusercontent.com/44978839/75569587-bd8ec280-5a98-11ea-953d-aa05f1f09e3a.png">  

Push 인증서를 발급 받았다.  
참고로 Push 인증서는 앱 인증서처럼 개발 맥북에 등록하여 사용하는 것이 아니고, iOS앱에 Push Notification을 발생시킬 때 사용한다.

> * 5. XCode 프로젝트 설정

<img width="600" alt="스크린샷 2020-02-29 오전 2 17 21" src="https://user-images.githubusercontent.com/44978839/75570137-df3c7980-5a99-11ea-99ba-681c5f69f340.png">

이제 XCode를 열고 '프로젝트 파일 > Capabilities 탭' 으로 들어가면 Push Notifications가 추가되어있는 것을 볼 수 있다.
