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
- [Second Seminar](#second-seminar)
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

## Second Seminar

> [2020.02.22] 밀린 세미나 지금하기 🤦🏻‍♀️

1. Default Camera VS Custom Camera
   - UIImagePickerControllerDelegate, UINavigationControllerDelegate
   - AVCapturePhotoCaptureDelegate
<br />

2. Usage

* **Default Camera**

> *  1. Simple Usage

 ```swift
  func openCamera(){
    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
      picker.sourceType = .camera
      present(picker, animated: false, completion: nil)
    }
    else{
      print("Camera not available")
    }
  }
  
  func openAlbum(){
    picker.sourceType = .photoLibrary
    present(picker, animated: false, completion: nil)
  }
 ```
  <br />
  
> *  2.Can Use Many Options

 ```swift
   func openCamera(){
     if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.showsCameraControls = true
        // picker.automaticallyAdjustsScrollViewInsets = true
        // 'automaticallyAdjustsScrollViewInsets' was deprecated in iOS 11.0: Use UIScrollView's contentInsetAdjustmentBehavior instead (iOS 7 ~ iOS 11 이하)

        present(picker, animated: false, completion: nil)
     }
     
     else{
        print("Camera not available")
     }
  }
 ```
  <br />
  
> *  3.Screenshot
   <div>
  
  * **showsCameraControls = false / showsCameraControls = true / allowsEditing = true**  
  <img height="550" src="https://user-images.githubusercontent.com/44978839/75059391-341f4380-5520-11ea-946d-ac1fde43913f.PNG"> <img height="550" src="https://user-images.githubusercontent.com/44978839/75059453-51eca880-5520-11ea-9d02-ef6aa292b83f.PNG"> <img height="550" src="https://user-images.githubusercontent.com/44978839/75059520-7ba5cf80-5520-11ea-94ab-1ddddcf2a51f.PNG">

<br />

* **Custom Camera**
* ref | [Creating a Custom Camera View](https://guides.codepath.com/ios/Creating-a-Custom-Camera-View#step-4-define-instance-variables)

> *  1. Use AVFoundation & AVCapturePhotoCaptureDelegate

 ```swift
  import AVFoundation
 ```  
 
  ```swift
  class CustomViewController: UIViewController, AVCapturePhotoCaptureDelegate
 ```
  <br />
  
> *  2.Define Instance Variables

 ```swift
  var image: UIImage?
  var session: AVCaptureSession!
  var stillImageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
 ```
  <br />

> *  2.Setup Session in viewDidAppear

   ```swift
    override func viewDidAppear(_ animated: Bool) {

      // session 생성. 세션이 디바이스 카메라의 입출력 데이타를 묶어준다.
      session = AVCaptureSession()
      session.sessionPreset = .medium

      // 후방 카메라를 사용할 수 있도록 추가해준다. 전면 카메라, 마이크 등의 장비를 추가할 수도 있다.
      guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
          else {
              print("Unable to access back camera!")
              return
      }
      
      // AVCaptureDeviceInput은 입력 장치인 후방 카메라를 세션에 연결하는 매개체
      do {
          let input = try AVCaptureDeviceInput(device: backCamera)
          
          // AVCapturePhotoOutput을 사용하여 출력물을 세션에 첨부 할 수 있다.
          stillImageOutput = AVCapturePhotoOutput()

          // 오류가 없다면 계속해서 입출력물을 세션에 추가한다.
          if session.canAddInput(input) && session.canAddOutput(stillImageOutput) {
              session.addInput(input)
              session.addOutput(stillImageOutput)
              setupLivePreview()
          }
      }
      catch let error  {
          print("Error Unable to initialize back camera:  \(error.localizedDescription)")
      }
  }
 ```
 
 <br/>
 
 > *  3.Configure the Live Preview
 
  ```swift
  // UIView인 previewView의 화면에 카메라가 실제로 보이는 것을 실제로 표시하기 위한 작업.
  func setupLivePreview() {
        
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)

      videoPreviewLayer.videoGravity = .resizeAspect
      videoPreviewLayer.connection?.videoOrientation = .portrait
      previewView.layer.addSublayer(videoPreviewLayer)

      // Start the Session on the background thread
      // 라이브 뷰를 시작하려면 세션에서 -startRunning을 호출해야 하는데 -startRunning은 메인 스레드에서 실행 중인 경우 UI를 차단하는 블로킹 메소드. 따라서 background thread에서 실행시킨다.
      DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
          self.session.startRunning()
          
          // Size the Preview Layer to fit the Preview View
          // 라이브 뷰가 시작되면 미리보기 레이어를 맞추고 메인 스레드로 돌아와야한다.
          DispatchQueue.main.async {
              self.videoPreviewLayer.frame = self.previewView.bounds
          }
      }
  }
  ```
  
  <br/>
  
> *  3.Taking the picture

  ```swift
  class CustomViewController: UIViewController, AVCapturePhotoCaptureDelegate {
      ...
  
      @IBAction func didTakePhoto(_ sender: Any) {
      
      // JPEG를 캡처하려면 캡처 한 사진을 전달할 설정과 위임을 제공해야한다. 이 대리자는이 ViewController가되므로 AVCapturePhotoCaptureDelegate 프로토콜도 준수해야한다.
      
      let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
    stillImageOutput.capturePhoto(with: settings, delegate: self)
      }
  ```
  
  <br/>
  
> *  4.Process the captured photo

  ```swift
  // 캡처 된 사진을 현재 ViewController 인 지정된 대리자에게 전달한다.
  // 사진은 AVCapturePhoto로 제공되어 UIImage보다 Data / NSData로 쉽게 변환 할 수 있다.
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

    guard let imageData = photo.fileDataRepresentation()
        else { return }

    image = UIImage(data: imageData)

    let dvc = self.storyboard?.instantiateViewController(identifier: "CustomDetailViewController") as! CustomDetailViewController

    dvc.captureImg = self.image
    present(dvc, animated: true, completion: nil)
}
  ```
  
    <br/>
  
> *  5.Clean up when the user leaves

  ```swift
  override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
  ```
  
   <br/>
  
> *  3.Screenshot

<div align="center">
  ![ezgif-2-6e3f3732081b](https://user-images.githubusercontent.com/44978839/75061775-c590b480-5524-11ea-8966-bd2858d87627.gif)
</div>
<br/>
<br/>

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

2. Usage Example
   <div>
  ![Feb-22-2020 02-08-19](https://user-images.githubusercontent.com/44978839/75055491-717fd300-5518-11ea-9898-b7141e0a7a0b.gif)
   </div>
<br />

3. Usage

> *  1. Create @IBOutlet & Top Contraints
 
 ```swift
    @IBOutlet var logo: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewContraint: NSLayoutConstraint!
 ```
 <br />
 
> *  2. Use scrollViewDidScroll function with PanGestureRecognizer
 
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
