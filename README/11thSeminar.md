# 11th Seminar
UICollectionViewDrag & Drop Delegate + UIKit
> [2020.07.24]

<br/>

# Contents
- [0 단계 | Drag-and-Drop Interactions](#Drag-and-Drop-Interactions)
- [1 단계 | Drag Sources](#Drag-Sources)
- [2 단계 | CollectionView TableView](#CollectionView-TableView)

<br/>

# Drag-and-Drop Interactions
> 출처 | Documentation > UIKit > [Drag and Drop](https://developer.apple.com/documentation/uikit/drag_and_drop)

> 참고 | [HIG, drag and drop](https://developer.apple.com/design/human-interface-guidelines/ios/user-interaction/drag-and-drop/)

* 공식 문서에 따르면 드래그 앤 드롭은 **continuous 제스처**로 인터랙션 합니다. 즉, 중간에 끊어지는 행위 없이 "꾸-욱" 눌러서 손가락을 움직이는 행위로 드래그하고 드롭할 수 있습니다.

* UIKit 에서 제공하는 이 기능에는 인터랙션이 가능하도록 하는 여러가지의 클래스와 프로토콜들이 있습니다. 하나씩 살펴보겠습니다.

---
* **먼저 'Dragging, 'Dropping'과 같은 인터랙션을 가능하게 해주는 딜리게이트와 클래스입니다.**

* `protocol` UIDragInteractionDelegate
* `protocol` UIDropInteractionDelegate
* `class` UIDragInteraction
* `class` UIDropInteraction

<br/>

* **공식 문서를 읽다보면 눈에 띄는 것은, UIDrag & Drop Interaction은 Session의 호출에 응답한다는 점입니다. 세션은 뭘까요?**

* `protocol` UIDragDropSession
* `protocol` UIDragSession
* `protocol` UIDropSession

<br/>

# Drag Sources

딜리게이트 안에 반드시 선언해야하는 메소드들의 파라미터를 보면 각각 **UIDragSession**, **UIDropSession**이 선언되어있는 것을 볼 수 있습니다.
### protocol UIDragInteractionDelegate
```swift
extension ViewController : UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

    }
}
```

### protocol UIDropInteractionDelegate
```swift
extension ViewController : UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {

    }
}
```

`enum` UIDropOperation 

* cancel
* copy
* forbidden
* move

<br/>

# CollectionView TableView

CollectionView 또는 TableView에서 iOS11+ 버전부터 지원하는 기능으로, 드래그 / 드롭이 가능하도록 활성화하는 bool변수가 있습니다.

* `bool` hasActiveDrag
* `bool` hasActiveDrop

**hasActiveDrag**는 아이템이 드롭되기 전까지 아이템이 lift되었는지 아닌지 표시해주는 속성이며

**hasActiveDrop**는 collection view가 드롭 세션을 트랙킹하고 있는지 표시하는 속성입니다.

> 프로젝트 참고 | [Drag, Drop & Reorder Collection View Cells into One or More UICollectionView](https://medium.com/hackernoon/how-to-drag-drop-uicollectionview-cells-by-utilizing-dropdelegate-and-dragdelegate-6e3512327202)
