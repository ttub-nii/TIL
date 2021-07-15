//
//  CallableStoryBoard.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/14.
//

import UIKit

enum StoryBoardCategory: String {
    case Onboarding
    case Home
}

protocol CallableStoryBoard {
    static var storyboardId: String { get }
    static var storyBoardCategory: StoryBoardCategory { get }
    static func fromStoryBoard(with info: Any?) -> Self
}

extension CallableStoryBoard where Self: UIViewController {
    static var storyboardId: String {
        return String(describing: self)
    }
    
    static func fromStoryBoard(with info: Any? = nil) -> Self {
        let storyBoard = UIStoryboard(name: storyBoardCategory.rawValue, bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
            fatalError("Please check your viewcontroller's storyboard identifier. Now, This viewController's identifier is \(storyboardId)")
        }
        
        return viewController
    }
}
