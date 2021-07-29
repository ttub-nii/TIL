//
//  ChaiTextField.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

@IBDesignable open class ChaiTextField: TextFieldEffects {
    @IBInspectable dynamic open var placeholderColor: UIColor = .black {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            updatePlaceholder()
        }
    }
    
    private let placeholderInsets = CGPoint(x: 15, y: 15)
    private let textFieldInsets = CGPoint(x: 15, y: 12)
    
    // MARK: - TextFieldEffects
    override open func drawViewsForRect(_ rect: CGRect) {
        let frame = CGRect(origin: CGPoint.zero, size: CGSize(width: rect.size.width, height: rect.size.height))
        
        placeholderLabel.frame = frame.insetBy(dx: placeholderInsets.x, dy: placeholderInsets.y)
        
        updatePlaceholder()
        addSubview(placeholderLabel)
    }
    
    override open func animateViewsForTextEntry() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: {
            self.placeholderLabel.frame.origin = CGPoint(x: self.placeholderInsets.x, y: 15)
            self.placeholderLabel.font = self.placeholderLabel.font.withSize(12)
        }, completion: { _ in
            self.animationCompletionHandler?(.textEntry)
        })
    }
    
    override open func animateViewsForTextDisplay() {
        if text!.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .beginFromCurrentState, animations: {
                self.layoutPlaceholderInTextRect()
                self.placeholderLabel.alpha = 1
                self.placeholderLabel.font = self.placeholderLabel.font.withSize(17)
            }, completion: { _ in
                self.animationCompletionHandler?(.textDisplay)
            })
        }
    }
    
    // MARK: - Private
    private func updatePlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.sizeToFit()
        layoutPlaceholderInTextRect()
        
        if isFirstResponder || text!.isNotEmpty {
            animateViewsForTextEntry()
        }
    }
    
    private func layoutPlaceholderInTextRect() {
        if text!.isNotEmpty {
            return
        }
        
        let textRect = self.textRect(forBounds: bounds)
        var originX = textRect.origin.x
        switch self.textAlignment {
        case .center:
            originX += textRect.size.width/2 - placeholderLabel.bounds.width/2
        case .right:
            originX += textRect.size.width - placeholderLabel.bounds.width
        default:
            break
        }
        placeholderLabel.frame = CGRect(x: originX, y: textRect.size.height/2 - 10,
            width: placeholderLabel.frame.size.width, height: placeholderLabel.frame.size.height)
    }
    
    // MARK: - Overrides
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y)
    }

}
