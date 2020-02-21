//
//  CustomDetailViewController.swift
//  CustomCamera
//
//  Created by 황수빈 on 22/02/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class CustomDetailViewController: UIViewController {

    @IBOutlet var capturedImageView: UIImageView!
    
    var captureImg: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        capturedImageView.image = captureImg
    }
}
