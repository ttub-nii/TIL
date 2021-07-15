//
//  BottomSheetViewController.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/15.
//

import UIKit

protocol AgencySheetDelegate: AnyObject {
    func selectAgency(text: String)
}

class BottomSheetViewController: UIViewController {
    weak var delegate: AgencySheetDelegate?
    
    @IBOutlet weak var titleView: UIView!
    
    override func viewDidLoad() {
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        titleView.layer.cornerRadius = 13
        titleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleView.clipsToBounds = true
    }
    
    @IBAction func selectAgency(_ sender: UIButton) {
        delegate?.selectAgency(text: sender.titleLabel?.text ?? "")
    }
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension BottomSheetViewController: CallableStoryBoard {
    static var storyBoardCategory: StoryBoardCategory {
        return .Onboarding
    }
}
