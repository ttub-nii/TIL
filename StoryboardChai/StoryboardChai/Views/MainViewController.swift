//
//  MainViewController.swift
//  StoryboardChai
//
//  Created by toby.with on 2021/07/15.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: CallableStoryBoard {
    static var storyBoardCategory: StoryBoardCategory {
        return .Home
    }
}
