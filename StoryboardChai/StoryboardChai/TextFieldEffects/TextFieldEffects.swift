//
//  TextFieldEffects.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

extension String {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

/**
텍스트가 입력되거나 사라지는 시점에 애니메이션 효과를 주기 위한 UITextField 템플릿
*/
open class TextFieldEffects : UITextField {
    /**
     애니메이션 타입을 지정
     
     - TextEntry: 텍스트 필드가 활성화되었을 때
     - TextDisplay: 텍스트 필드가 비활성화되었을 때
     */
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    /** 애니메이션이 끝났을 때 실행되는 클로저 */
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    public let placeholderLabel = UILabel()
    
    /**
    Creates all the animations that are used to leave the textfield in the "entering text" state.
    */
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
    Creates all the animations that are used to leave the textfield in the "display input text" state.
    */
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    /**
     The animation completion handler is the best place to be notified when the text field animation has ended.
     */
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    /**
    Draws the receiver’s image within the passed-in rectangle.
    
    - parameter rect:    The portion of the view’s bounds that needs to be updated.
    */
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: - Overrides
    
    override open func draw(_ rect: CGRect) {
        // FIXME: Short-circuit if the view is currently selected. iOS 11 introduced
        // a setNeedsDisplay when you focus on a textfield, calling this method again
        // and messing up some of the effects due to the logic contained inside these
        // methods.
        // This is just a "quick fix", something better needs to come along.
        guard isFirstResponder == false else { return }
        drawViewsForRect(rect)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {
        // Don't draw any placeholders
    }
    
    override open var text: String? {
        didSet {
            if let text = text, !text.isEmpty || isFirstResponder {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    // MARK: - UITextField Observing
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    /**
    The textfield has started an editing session.
    */
    @objc open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    /**
    The textfield has ended an editing session.
    */
    @objc open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: - Interface Builder
    
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}
