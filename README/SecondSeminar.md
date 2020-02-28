# Second Seminar

> [2020.02.22] 밀린 세미나 지금하기 🤦🏻‍♀️

<br/>

# Contents
- [기본 카메라](#Default-Camera)
- [커스텀 카메라](#Custom-Camera)

<br />

### 1. Default Camera VS Custom Camera
   - UIImagePickerControllerDelegate, UINavigationControllerDelegate
   - AVCapturePhotoCaptureDelegate
<br />


# Default Camera

### 2. Usage
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
  
### 3. Screenshot

<div>
   
  * **showsCameraControls = false / showsCameraControls = true / allowsEditing = true**  
  <img height="550" src="https://user-images.githubusercontent.com/44978839/75059391-341f4380-5520-11ea-946d-ac1fde43913f.PNG"> <img height="550" src="https://user-images.githubusercontent.com/44978839/75059453-51eca880-5520-11ea-9d02-ef6aa292b83f.PNG"> <img height="550" src="https://user-images.githubusercontent.com/44978839/75059520-7ba5cf80-5520-11ea-94ab-1ddddcf2a51f.PNG">

</div>
<br />

# Custom Camera
* ref | [Creating a Custom Camera View](https://guides.codepath.com/ios/Creating-a-Custom-Camera-View#step-4-define-instance-variables)

### 2. Usage
> *  1. Use AVFoundation & AVCapturePhotoCaptureDelegate

 ```swift
  import AVFoundation
 ```  
 
  ```swift
  class CustomViewController: UIViewController, AVCapturePhotoCaptureDelegate
 ```
  <br />
  
> *  2. Define Instance Variables

 ```swift
  var image: UIImage?
  var session: AVCaptureSession!
  var stillImageOutput: AVCapturePhotoOutput!
  var videoPreviewLayer: AVCaptureVideoPreviewLayer!
 ```
  <br />

> *  3. Setup Session in viewDidAppear

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
 
 > *  4. Configure the Live Preview
 
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
  
> *  5. Taking the picture

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
  
> *  6. Process the captured photo

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
  
> *  7. Clean up when the user leaves

  ```swift
  override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
  ```
  
   <br/>
  
### 3. Screenshot

<div align="center">
  
  ![ezgif-2-6e3f3732081b](https://user-images.githubusercontent.com/44978839/75061775-c590b480-5524-11ea-8966-bd2858d87627.gif)
  
</div>
