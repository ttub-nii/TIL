//
//  UIView+Onboarding.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

extension UIView {
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            self.layer.borderColor = uiColor.cgColor
        }
        
        get {
            guard let color = self.layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
