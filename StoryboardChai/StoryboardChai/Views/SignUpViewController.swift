//
//  SignUpViewController.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

class SignUpViewController: UIViewController {
    private let titleResidentString = "주민번호 앞 7자리를\n입력해주세요"
    public var agencyString = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topPhoneNumberConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerBorderViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var residentNumberView: UIView!
    @IBOutlet weak var agencyView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var activeBorderView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var phoneTextField: ChaiTextField! {
        didSet {
            phoneTextField.delegate = self
            phoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet var residentTextField: ChaiTextField! {
        didSet {
            residentTextField.delegate = self
            residentTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet var agencyTextField: ChaiTextField! {
        didSet {
            agencyTextField.delegate = self
            agencyTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    @IBOutlet var nameTextField: ChaiTextField! {
        didSet {
            nameTextField.delegate = self
            nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawUI()
        clearNavigationBarBackground()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case phoneTextField:
            if textField.text?.isValidPhone() ?? false {
                animateNextStep()
            }
        case residentTextField:
            if textField.text?.isValidResident() ?? false && phoneTextField.text?.isValidPhone() ?? false {
                print(textField.text?.isValidResident())
                let signUpCheckVC = SignUpCheckViewController.fromStoryBoard()
                self.navigationController?.pushViewController(signUpCheckVC, animated: true)
            }
        default:
            break
        }
    }
    
    private func animateNextStep() {
        residentNumberView.isHidden = false
        topPhoneNumberConstraint.constant = 150
        centerBorderViewConstraint.constant = -110
        residentTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    private func drawUI() {
        confirmButton.isEnabled = false
        residentNumberView.isHidden = true
        agencyView.isHidden = true
        nameView.isHidden = true
        activeBorderView.layer.shadowOpacity = 0.8
        activeBorderView.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        activeBorderView.layer.shadowColor = UIColor.gray.cgColor
    }
    
    @IBAction func checkTerms(_ sender: UIButton) {
        let signUpCheckVC = SignUpCheckViewController.fromStoryBoard()
        self.navigationController?.pushViewController(signUpCheckVC, animated: true)
    }
}

private extension SignUpViewController {
    func clearNavigationBarBackground() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == residentTextField {
            centerBorderViewConstraint.constant = -110
        } else {
            centerBorderViewConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        return true
    }
}

extension SignUpViewController: CallableStoryBoard {
    static var storyBoardCategory: StoryBoardCategory {
        return .Onboarding
    }
}
