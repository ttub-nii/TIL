//
//  ViewController.swift
//  CustomCamera
//
//  Created by 황수빈 on 22/02/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openCamera))
        self.view.addGestureRecognizer(gesture)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: UIButton) {
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.showsCameraControls = true
            // picker.automaticallyAdjustsScrollViewInsets = true
            // 'automaticallyAdjustsScrollViewInsets' was deprecated in iOS 11.0: Use UIScrollView's contentInsetAdjustmentBehavior instead
            
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
    
    @IBAction func openAlbum(_ sender: UIButton) {
        picker.sourceType = .photoLibrary
        
        present(picker, animated: false, completion: nil)
    }
}
