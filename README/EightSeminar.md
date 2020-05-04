# Eighth Seminar
> [2020.05.04]

<br />

# Contents
- [Estimate Size가 궁금해진 배경](#Issue-정리)
- [Estimate Size는 무슨 프로퍼티일까?](#Estimate-Size)

<br />

## Issue 정리
Estimate Size 에 대해 알아보기 이전에, 왜 이 부분에 대해서 알아보고 싶어졌는지 이슈를 발견한 배경에 대해 정리해보도록 하겠다.
**CollectionView** 로 티켓의 리스트를 구현하고 있는 중이었다. Autolayout 을 스토리보드 상으로 제약을 걸고 시뮬레이터로 번갈아 실행해보던 중에 iphone8 디바이스와 iphone pro max에서 레이아웃이 차이가 나는 것을 발견하게 되었다.
<img width="400" alt="8기준으로 작업했을 때" src="https://user-images.githubusercontent.com/44978839/80938973-fdb24e80-8e15-11ea-9c16-cd215934a827.png"> <img width="400" alt="스크린샷 2020-05-03 오후 5 51 02" src="https://user-images.githubusercontent.com/44978839/80938982-02770280-8e16-11ea-9054-0ee476070751.png">

### 부끄러운 사고의 흐름 정리
1. 평상시에 iphone 8 디바이스로 작업하기 때문에 이 문제는 내가 적절하게 오토레이아웃을 잡지 않았기 때문에 발생하는 문제일 것이라고 당연하게 생각하고 attribute 와 constraint 값을 수정하기 시작했다.

2. 혹시 inset 의 문제인가, 아니면 Layout Margins 의 문제일까 싶어서 Size inspector 에 있는 속성을 활성화시켰다가 비활성화시켰다가, 해보면서 어떤 속성이 영향을 미치는지 확인해보기 시작했다.

3. 그러다가 내가 pro max 보다 작은 디바이스인 8 으 기준으로 셀의 사이즈를 고정했기 때문인가 싶어, interface 를 큰 디바이스에서 layout 을 잡으면 작은 디바이스에서는 공간이 작아진 만큼 알아서(?) 작게 나오지 않을까? 하는 생각이 들었다.

4. pro max 를 기준으로 constraint 를 걸고 시뮬에서 실행시키니 이전과 별반 차이점이 없었다. 다만 그 상태에서 interface 를 8로 변경하면 뷰 밖으로 튀어나온 UI Component 에 대해 autolayout Warnings 가 떴다.

5. 그러던 중에 Cell Size 속성에 "Estimate Size" 속성 값을 변경해보았고 **none, automatic, custom** 중에 어떤 것을 선택하느냐에 따라 레이아웃이 달라지는 것을 보면서 아, 이것이 영향을 미치는 구나. 어떤 속성일까 알아봐야겠다는 생각에 도달하게 된다.

### Estimate Size 에 대해 커지는 궁금증

Xcode 가 11로 업데이트 되면서 생겼다는 Estimate Size 는 **none, automatic, custom** 3가지의 속성을 가지고 있었고 **Collection View** 와 **Collection View Cell** 각각 갖고 있었다.
첫번째로 첨부했던 [사진](#Issue-정리)은 iphone8을 기준으로 작업한 환경이고 Collection View(이하 CV) 와 Collection View Cell(이하 CVC) 모두 automatic 으로 설정되어있었다.

* interface 를 iPhone pro max 환경에서 작업한 채로, CV 와 CVC 모두 automatic 으로 설정하고 시뮬을 돌려보면 아래와 같이 보였다.
* 보다시피 pro max 에서는 그리드가 예쁘게 잡혀있지만 8 에서는 큰 컴포넌트들이 뷰를 뚫고 나왔다.

<img width="400" alt="253 PM" src="https://user-images.githubusercontent.com/44978839/80939791-abbef800-8e18-11ea-85f6-559a25435f4f.png"> <img width="400" alt="Melon Music Awards - MMA 2019" src="https://user-images.githubusercontent.com/44978839/80939781-a2359000-8e18-11ea-869d-ee2c942f9e10.png">

* 위 상황을 겪고 나니 적어도 UI 컴포넌트들이 화면 밖으로 튀어나오는 일은 없어야겠다는 생각이 들었다.
* CV 의 속성 값을 수정할까, CVC 의 속성 값을 수정해볼까 하다가 CV 의 영역에 제약을 주고 그 안에서 CVC 를 automatic 으로 해야겠다는 생각이 들었다.

<img width="400" alt="CV를 custom으로 했을 때" src="https://user-images.githubusercontent.com/44978839/80939868-f6407480-8e18-11ea-99bc-7b1a2021ae3b.png"> <img width="400" alt="스크린샷 2020-05-03 오후 5 54 45" src="https://user-images.githubusercontent.com/44978839/80939878-fb9dbf00-8e18-11ea-99ee-7882cd284866.png">

## Estimate Size
> estimatedItemSize 속성과 다른 값인가?

* 구글 검색창에 "Estimate Size"라고 검색하자 estimatedItemSize 에 관한 [개발자 문서](https://developer.apple.com/documentation/uikit/uicollectionviewflowlayout/1617709-estimateditemsize)가 가장 먼저 나왔다. 하지만 estimatedItemSize 는 CGSize 값이었다.

* UICollectionViewFlowLayout 에서는 estimatedItemSize 프로퍼티 값으로 초기에 셀들의 위치를 임시 배치하고 Autolayout 연산이 되어 크기가 변경된다면 그에 따라 Collection View 의 ContentSize 값을 갱신한다고 한다.

* Estimate Size 와 estimatedItemSize 가 같은 값인지는 모르겠지만 아예 연관이 없지는 않은 것 같았다. WWDC 2014에서 애플이 공개한 iOS 8 업데이트 내용 중 UICollectionView에 Self-sizing 메커니즘이 도입되면서 같이 생길 수 밖에 없는 개념인 것 같았다.
  > 출처: https://blog.skcc.com/2546 [SK(주) C&C 블로그]

* 하단에 첨부한 Stackoverflow [링크](https://stackoverflow.com/a/58369142) 에 달린 답변 중 "layout.estimatedItemSize = .zero" 라는 코드를 선언하면 Estimate Size 를 none 으로 선언한 것과 같은 효과를 볼 수 있다는 답변도 있었다.

* 하지만, 다른 점이 있다면 Estimate Size 는 Xcode 11로 업데이트 되면서 스토리보드의 inspector 에 추가된 속성이었다. Stackoverflow 에 찾아보니 UICollectionViewDelegateFlowLayout 를 확장하여 overriding 하려는 개발자들에게 Estimated Size 를 none 으로 속성을 변경한 것이 꽤나 많은 분들에 해결책을 주었던 것 같았다.

* 만약 Cell 의 크기를 동적으로 변하게 하거나, 코드로 custom 하고 싶을 때, Estimate Size 속성을 none 으로 변경하지 않는 경우에는 뷰가 첫 로드 되었을 때 Cell 이 적절하게 배치되지 않다가 스크롤이 발생하면 제 위치를 찾아가거나, 또는 스크롤이 발생하면 크기가 망가지는 것과 같이 Cell 이 Self-size 를 원하는 대로 하지 못하는 문제가 발생하는 것 같다.
  > 참고한 Stackoverflow 링크들:  
  >> [UICollectionView always auto sizing cells. Not using sizes returned from delegate](https://stackoverflow.com/questions/58262024/uicollectionview-always-auto-sizing-cells-not-using-sizes-returned-from-delegat)  
  >> [How to set UICollectionViewCell Width and Height programmatically](https://stackoverflow.com/questions/38028013/how-to-set-uicollectionviewcell-width-and-height-programmatically)  
  >> [UICollectionViewCell content wrong size on first load](https://stackoverflow.com/questions/32593117/uicollectionviewcell-content-wrong-size-on-first-load)  
  >> [Why on Xcode 11, UICollectionViewCell changes size as soon as you scroll](https://stackoverflow.com/questions/56840665/why-on-xcode-11-uicollectionviewcell-changes-size-as-soon-as-you-scroll-i-alre)
