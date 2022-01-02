# Third Seminar

> [2020.02.15]

<br/>

# Contents
- [준비 단계 | Push 인증서 발급 받기](#Root-ViewController)
- [실행 단계 | Push 테스트 해보기](#TableViewController)
- [확인 단계 | 디바이스에서 동작해보기](#확인-단계)

<br />

### 1. Map Kit
   - Add Map Kit View From Object library panel
   - Set MKMapType's Enum value defined in map property (.standard, .satellite, .hybrid)
   - Create NSObject for saving Location
   - Let's Add & Delete Map Annotation with MKAnnotation protocol
<br />

### 2. Screenshot
   <div>
  
  * **Find "Map Kit View" in Object library Panel**  
      <img width="505" alt="스크린샷 2020-02-15 오전 10 08 02" src="https://user-images.githubusercontent.com/44978839/74580141-2d567500-4fe4-11ea-8866-87b8082fa7c4.png">
<br />
  
  * **Create NSObject managing Locations list**  
      <img width="305" alt="스크린샷 2020-02-15 오전 10 09 23" src="https://user-images.githubusercontent.com/44978839/74580302-dd78ad80-4fe5-11ea-896a-4a6f17d75211.jpg">
   </div>
<br />

## Root ViewController
### 3. Usage

> *  1. Import MapKit in the Root Controller

 ```swift
 import MapKit
 
 @IBOutlet var map: MKMapView!
 ```
  <br />
  
> *  2. Create Swift file & NSObject to save Location info
 
 ```swift
 import UIKit
 import CoreLocation
 import MapKit

// MKAnnotation is necessary for Adding Annotation
// 해당 프로토콜을 따르기 위해서 변수의 이름은 정확히 coordinate 이어야 한다.
class University: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init (title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.coordinate = CLLocationCoordinate2D()
        self.coordinate.latitude = latitude
        self.coordinate.longitude = longitude
    }
}
 ```
 <br />

> *  3. Create & Use Annotation object
 
 ```swift
  var universityAnnotation: University? = nil
 ```
 
  ```swift
   // 기존의 맵에 annotation이 있었다면 삭제
   if let annotation = universityAnnotation {
       self.map.removeAnnotation(annotation)
   }
        
   // 새로운 annotation 위치가 있다면 추가
   if let annotation = univ {
       self.universityAnnotation = annotation
       self.map.addAnnotation(self.universityAnnotation!)
   }
 ```
 <br />
 
## TableViewController
### 3. Usage

> *  1. Declare necessary variables in the TableViewController
```swift
  // 대학 정보를 저장하기 위함
  var universities: [University] = []

  // 지도가 있는 상위 View: 선택한 대학 정보를 전달해 주기 위함
  var mainVC: ViewController? = nil
```

 <br />
 
> *  2. Setup University with test Locations in viewDidLoad
```swift
  override func viewDidLoad() {
      super.viewDidLoad()

      var univ: University
      univ = University(title:"서울여자대학교", latitude:37.6291, longitude:127.0897)
      self.universities.append(univ)
      univ = University(title: "고려대학교", latitude:37.5894, longitude:127.0323)
      self.universities.append(univ)
      univ = University(title: "부산대학교", latitude:35.2332, longitude:129.0794)
      self.universities.append(univ)
      univ = University(title: "Harvard University", latitude:42.36402, longitude:-71.12482)
      self.universities.append(univ)
      univ = University(title: "Michigan State Univ.", latitude:42.72401, longitude:-84.48137)
      self.universities.append(univ)
      univ = University(title: "New York University", latitude:40.7247, longitude:-73.9903)
      self.universities.append(univ)
  }
```

 <br />

> *  3. You can also use Table Cell's accessory Type
```swift
  // selected Index
  cell.accessoryType = .checkmark

  // unselected Index
  cell.accessoryType = .none
```
