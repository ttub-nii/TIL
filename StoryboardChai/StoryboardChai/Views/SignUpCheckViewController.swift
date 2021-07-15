//
//  SignUpCheckViewController.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

class SignUpCheckViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var activeBorderView: UIView!
    @IBOutlet weak var progressView: CircularProgressView!
    @IBOutlet weak var checkTextField: ChaiTextField! {
        didSet {
            checkTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTimer()
        activeBorderView.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func createTimer() {
        var timeLimit: Int = 180
        _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            timeLimit -= 1
            
            self.timerToLabel(sec: timeLimit)
            self.progressView.progress = CGFloat(180 - timeLimit) / 180
            print(self.progressView.progress)
            if timeLimit == 0 {
                timer.invalidate()
            }
        })
    }
    
    func timerToLabel(sec: Int) {
        let minute = (sec % 3600) / 60
        let second = (sec % 3600) % 60
        
        if second < 10 {
            timerLabel.text = String(minute) + ":0" + String(second)
        } else {
            timerLabel.text = String(minute) + ":" + String(second)
        }
    }
}

extension SignUpCheckViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.activeBorderView.isHidden = false
        })
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3, animations: {
            self.activeBorderView.isHidden = true
        })
        
        if textField.text?.isValidNumber() ?? false {
            let loginVC = LoginViewController.fromStoryBoard()
            self.navigationController?.pushViewController(loginVC, animated: true)
        } else {
            print("toast 띄우기")
        }
    }
}

extension SignUpCheckViewController: CallableStoryBoard {
    static var storyBoardCategory: StoryBoardCategory {
        return .Onboarding
    }
}
