# Second Supplementary

> [2020.03.01]

<br />

## Pop up

* opacity는 자식들에게 영향을 주지 않는다. 따라서 부모 뷰에다가 속성을 적용한다 하더라도 영향을 주지 않기 때문에 Superview의 색상을 #000000, opacity 값을 조정하여 깔끔하게 어둠 처리를 할 수 있다.
* addGestureRecognizer 를 사용하여 팝업 뷰가 사라지게도 할 수 있지만, touchesBegan UIResponder 에다가 팝업뷰를 사라지도록 하는 dismiss 메소드를 실행하면 동일한 효과를 줄 수 있다.
* 팝업을 그릴 때는 작은 디바이스(SE 등) 에서도 보일 수 있도록 사이즈 설정이 중요하다. 팝업 뷰의 사이즈가 작다면 AutoLayout 을 center x, y로 잡아도 상관 없지만 leading, trailing 으로 AutoLayout 잡는 것을 권장한다.

<br />

## iOS UIModalPresentationStyle 알아보기  

modalPresentationStyle 에는 다음과 같은 4가지의 스타일이 있다.
스타일을 따로 세팅하지 않으면 기본 값인 fullScreen 이 적용된다.

* 참고 | [[iOS 앱 개발 - Swift] 모달이 뭘까? ( Modal )](https://etst.tistory.com/87)

* **UIModalPresentationFullScreen**
  * 전체 화면을 완전히 덮어 화면 전체에 새로운 뷰를 보여주는 방식의 프레젠테이션 스타일. 제일 기본적인 방법.
* **UIModalPresentationCurrentContext**
  * FullScreen 스타일이 전체 화면을 덮는 방식이라면 ( 장치 스크린의 크기에 대응된다 ), CurrentContext 스타일은 현재 뷰에 대응해 새로운 뷰를 보여주는 방식. 만약에 화면의 뷰를 작게 만들었다면, CurrentContext로 올려준 뷰도 작은 크기로 나온다. 스플릿 뷰 등을 통해 화면을 분할한 상태여서 뷰가 스크린 크기보다 작을 때 사용하는 스타일.
* **UIModalPresentationOverFullScreen / OverCurrentContext**
  * 새로 생성하는 뷰의 투명도(알파값)를 정해 기존의 뷰를 볼 수 있는 스타일. 위의 프레젠테이션 스타일들은 아래에 깔리는 뷰를 context에서 삭제해버리고 위에 새로운 뷰로 덮어버리지만, 이 두 스타일들은 기존 뷰를 그대로 남겨두고 위에 뷰를 덮기 때문에 투명도를 조절해 반투명 상태로 만들어주면 새로운 뷰 아래에 기존 뷰를 볼 수 있다.
* **UIModalPresentationPageSheet**
  * 뷰의 가로를 늘이지 않고 그대로 보여주는 프레젠테이션 스타일.
* **UIModalPresentationFormSheet**
  * 화면 가장자리에서 상하좌우 모두 여백을 가지고 섬처럼 떠있는 방식의 프레젠테이션 스타일.
* **UIModalPresentationPopover**
  * 팝오버뷰로 새로운 뷰를 나타낸다. 추가 정보, 선택한 것에 대한 추가 옵션 등을 나타내는데 주로 사용된다. 참고로 이 스타일은 iPad 기기에서만 지원한다.
  * <img width="300" alt="R1280x0" src="https://user-images.githubusercontent.com/44978839/75610710-e8d7e700-5b56-11ea-9b76-70e28ac9da4b.png">
<br/>

애플은 개발자 문서에서 다음과 같이 말하고 있다.

``` 
"Modal presentation styles available when presenting view controllers."
``` 

즉, present 할때 사용할 수 있는 modal 프레젠테이션 스타일이다.

<img width="300" src="https://user-images.githubusercontent.com/44978839/75610782-a4008000-5b57-11ea-890f-472b03e4890d.gif">

> CurrentContext 스타일로 전환하는 모습. FullScreen 전환 방식과의 차이를 단적으로 보여줘서 갖고 왔다.  
> 출처 | [마기의 개발 블로그](https://magi82.github.io/ios-modal-presentation-style-01/)

## definesPresentationContext 프로퍼티에 대해

``` 
Determines which parent view controller’s view should be presented over for presentations of type UIModalPresentationCurrentContext.
If no ancestor view controller has this flag set, then the presenter will be the root view controller.
``` 

모달 뷰 컨트롤러가 CurrentContext 스타일로 present 될 때 두 가지의 경우가 있다.

1. present 를 지시한 뷰 컨트롤러의 최상위 계층 컨트롤러가 표시중인 뷰
2. definesPresentationContext 프로퍼티가 true인 뷰 컨트롤러의 뷰

즉, 더이상 상위가 없는 루트 뷰 컨트롤러의 뷰에서 표시가 되거나, 최상위 뷰를 찾으러 올라가다가 해당 프로퍼티가 true인게 체크가 되면 
최상위 뷰를 찾으러 올라가다가 해당 프로퍼티가 true인게 체크가 되면 해당 뷰컨트롤러의 뷰에 표시가 된다.

- **1: self.definesPresentationContext = true**  
**2: self.navigationController?.definesPresentationContext = false**  
<img width="300" src="https://user-images.githubusercontent.com/44978839/75611725-69e7ac00-5b60-11ea-9e97-235a58ec9fec.gif"> <img width="300" src="https://user-images.githubusercontent.com/44978839/75611836-6e609480-5b61-11ea-8120-1207343209ad.gif">

예를 들어서, 일반 뷰 컨트롤러는 해당 프로퍼티가 기본적으로 false 이고, TabbarController, NavigationController는 
기본적으로 true로 세팅이 되어있다. 그래서 CurrentContext 스타일로 그냥 적용시키게 된다면 최상위 뷰컨롤러를 찾다가 네비게이션 뷰컨롤러의 프로퍼티를 보고 네비게이션 뷰컨롤러의 뷰에서  나타나기 때문에 하단 탭바는 보이지만 네비게이션 바가 보이지 않는다.

### 1

``` 
self.definesPresentationContext = true
``` 

실제 컨텐츠 뷰 컨트롤러의 프로퍼티를 true로 세팅하면 탭바와 네비게이션바 모두 보이고,

### 2

``` 
self.navigationController?.definesPresentationContext = false
``` 

하위 뷰 컨트롤러들의 해당 프로퍼티를 false 세팅하면 상위 클래스인 tabBarController의 view 위에 표시된다.
