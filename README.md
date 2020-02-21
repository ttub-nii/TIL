<h1 align="center">ttub-nii</h1>

<div style="display:flex;" align="center">
  <img src="https://img.shields.io/badge/study-iOS-ff69b4" />
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/iOS-SOPT-iNNovation/ttub-nii?logo=2020.01.21">
  <img alt="GitHub" src="https://img.shields.io/github/license/iOS-SOPT-iNNovation/ttub-nii">
</div>

<div align="center">
  :25.5th iOS Study since 2020.01.21 Tue
</div>

<div align="center">
  iOS 스터디 & 플젝 리팩토링 과제 
</div>

## Table of Contents

- [First Seminar](#first-seminar)
- [Third Seminar](#third-seminar)
- [Fourth Seminar](#fourth-seminar)

## First Seminar

> [2020.02.01]

1. Core Data
   - Use Single View Application Template
   - Check "Use Core Data"
   - Check .xcdatamodeld File Created
   - Add date attribute 1, string attribute 3
<br />

2. Screenshot
   <div>
  
  * **Check "Use Core Data" When Create a New Project**  
      <img width="205" alt="스크린샷 2020-02-01 오후 1 36 22" src="https://user-images.githubusercontent.com/44978839/73586925-d8046900-44f7-11ea-8237-79dcb18612ae.png">
<br />
  
  * **Add attribute to .xcdatamodeld File**  
      <img width="305" alt="스크린샷 2020-02-01 오후 1 40 15" src="https://user-images.githubusercontent.com/44978839/73586984-a0e28780-44f8-11ea-9552-a3f2b5922100.png">
   </div>
<br />

3. Usage

* **Root ViewController**
> *  1. Import CoreData in the Root Controller

 ```swift
 import CoreData
 ```
  <br />
  
> *  2. Create NSManagedObject to save info
 
 ```swift
 var friends: [NSManagedObject] = []
 ```
 <br />
 
> *  3. Add fetch Code in viewDidAppear
 
 ```swift
 override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Friends")
        
        // sorting
        let sortDescriptor = NSSortDescriptor (key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do
        {
            friends = try context.fetch(fetchRequest)
        }
        catch let error as NSError
        {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
```

```swift
 func getContext () -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
```
<br />

* **Save ViewController**
> *  4. Save Data Code in the Save Controller
```swift
@IBAction func savePressed(_ sender: UIBarButtonItem)
    {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Friends", in: context)
        
        // friend record를 새로 생성함
        // context안에 있는 object에 저장
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textName.text, forKey: "name")
        object.setValue(textPhone.text, forKey: "phone")
        object.setValue(textMemo.text, forKey: "memo")
        object.setValue(Date(), forKey: "saveDate")
        do
        {
            try context.save()
            print("saved!")
        }
        catch let error as NSError
        {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.navigationController?.popViewController(animated: true)
    }// savePressed
```

<br />
<br />







## Third Seminar

> [2020.02.15]

1. Map Kit
   - Add Map Kit View From Object library panel
   - Set MKMapType's Enum value defined in map property (.standard, .satellite, .hybrid)
   - Create NSObject for saving Location
   - Let's Add & Delete Map Annotation with MKAnnotation protocol
<br />

2. Screenshot
   <div>
  
  * **Find "Map Kit View" in Object library Panel**  
      <img width="505" alt="스크린샷 2020-02-15 오전 10 08 02" src="https://user-images.githubusercontent.com/44978839/74580141-2d567500-4fe4-11ea-8866-87b8082fa7c4.png">
<br />
  
  * **Create NSObject managing Locations list**  
      <img width="305" alt="스크린샷 2020-02-15 오전 10 09 23" src="https://user-images.githubusercontent.com/44978839/74580302-dd78ad80-4fe5-11ea-896a-4a6f17d75211.jpg">
   </div>
<br />

3. Usage

* **Root ViewController**
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
 
* **TableViewController**
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

<br/>
<br/>








## Fourth Seminar

> [2020.02.22]

1. ScrollView Delegate
   - Create TableView and TopView just for Test
   - TopView Should place in front of the TableView
   - Add top contraints for each object
   - Let's transform these When scrollViewDidScroll
<br />

2. Screenshot
   <div>
  
  * **Usage Example**  
  
  ![Feb-22-2020 02-08-19](https://user-images.githubusercontent.com/44978839/75055491-717fd300-5518-11ea-9898-b7141e0a7a0b.gif)
   </div>
<br />

3. Usage

* **Root ViewController**
> *  1. Import CoreData in the Root Controller

 ```swift
 import CoreData
 ```
  <br />
  
> *  2. Create @IBOutlet & Top Contraints
 
 ```swift
    @IBOutlet var logo: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewContraint: NSLayoutConstraint!
 ```
 <br />
 
> *  3. Use scrollViewDidScroll function with PanGestureRecognizer
 
 ```swift
 // 스크롤 시 Top View 올리고 내리기
extension ViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 이동 제스처는 화면에서 손가락의 움직임을 감지하고 이 움직임을 콘텐츠에 적용하는 데 사용되며 PanGestureRecognizer 클래스로 구현합니다.
        let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        
        // velocity 는 Pan Gesture의 속도입니다. 리턴값은 CGPoint값이며 초당 포인트(점)로 표시됩니다. 속도는 수평 및 수직 구성요소로 나뉩니다. 속력과 속도의 차이.. 아시죠?
        if yVelocity > 0 {
            downHomeView()
            
        } else if yVelocity < 0 {
            upHomeView()
        }
    }
    
    // 뷰 올려서 안 보이게 하기
    func upHomeView() {
        self.tableViewContraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            // 사라지는데 효과를 주고 싶다면 opacity 값, 애니메이션 등을 사용해보세요.
            //self.logo.alpha = 0
            self.logo.textColor = .black
            
            // 상단바 위치 올리기
            self.topView.transform = CGAffineTransform(translationX: 0, y: -115)
            self.view.layoutIfNeeded()
        })
    }
    
    // 뷰 내려서 보이게 하기 (원 위치)
    func downHomeView() {
        self.tableViewContraint.constant = 213
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            // self.logo.alpha = 1
            self.logo.textColor = .white
            
            // identity 는 CGAffineTransform의 속성 값을 원래대로 되돌리는 private key로 적용된 모든 변환을 제거하는 방법입니다.
            // static var identity: CGAffineTransform { get }
            self.topView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
}
```
<br />
