//
//  LoginViewController.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/15.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var passwordImage: [UIImageView]!
    @IBOutlet var keyboardButton: [UIButton]!
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawShadow()
        drawKeyboard()
    }
    
    private func drawShadow() {
        for i in 0...5 {
            passwordImage[i].layer.shadowRadius = 1.0
            passwordImage[i].layer.shadowOpacity = 0.2
            passwordImage[i].layer.shadowOffset = CGSize(width: 0.0, height: 4)
            passwordImage[i].layer.shadowColor = UIColor.darkGray.cgColor
            passwordImage[i].clipsToBounds = false
        }
    }
    
    private func drawKeyboard() {
        for i in 0...9 {
//            arc4random() % 10;
            keyboardButton[i].setTitle(String(i), for: .normal)
        }
    }
    
    private func updateIndicator() {
        for i in 0...password.count {
            passwordImage[i].isHighlighted = true
        }
    }
    
    @IBAction func enterPassword(_ sender: UIButton) {
        if password.count < 6 {
            updateIndicator()
            password = password + (sender.titleLabel?.text)!
        }
        if password.count == 6 {
            let mainVC = MainViewController.fromStoryBoard()
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            self.present(mainVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func enterBackspace(_ sender: UIButton) {
        password = String(password.dropLast())
        passwordImage[password.count].isHighlighted = false
        print(password)
    }
    
}

extension LoginViewController: CallableStoryBoard {
    static var storyBoardCategory: StoryBoardCategory {
        return .Onboarding
    }
}
