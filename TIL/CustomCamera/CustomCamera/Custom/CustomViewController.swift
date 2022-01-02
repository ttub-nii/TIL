//
//  CustomViewController.swift
//  CustomCamera
//
//  Created by 황수빈 on 22/02/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit
import AVFoundation

class CustomViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet var previewView: UIView!
    
    var image: UIImage?
    var session: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.session.stopRunning()
    }
    
    // MARK: - The bulk of the camera setup will happen
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
    
    @IBAction func didTakePhoto(_ sender: UIButton) {
        // JPEG를 캡처하려면 캡처 한 사진을 전달할 설정과 위임을 제공해야한다. 이 대리자는이 ViewController가되므로 AVCapturePhotoCaptureDelegate 프로토콜도 준수해야한다.
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // MARK: - UIView인 previewView의 화면에 카메라가 실제로 보이는 것을 실제로 표시하기 위한 작업.
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
    
    // MARK: -  캡처 된 사진을 현재 ViewController 인 지정된 대리자에게 전달한다.
    // 사진은 AVCapturePhoto로 제공되어 UIImage보다 Data / NSData로 쉽게 변환 할 수 있다.
      func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imageData = photo.fileDataRepresentation()
            else { return }

        image = UIImage(data: imageData)

        let dvc = self.storyboard?.instantiateViewController(identifier: "CustomDetailViewController") as! CustomDetailViewController

        dvc.captureImg = self.image
        present(dvc, animated: true, completion: nil)
    }
}
