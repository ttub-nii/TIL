//
//  ViewController.swift
//  TodayHouse
//
//  Created by toby.with on 2021/07/28.
//

import UIKit

class ViewController: UIViewController, CustomTabbarDelegate {
    @IBOutlet weak var customTabbar: CustomTabbar! {
        didSet {
            customTabbar.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame.height
        self.view.intrinsicContentSize.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // MARK: Delegate
    func changePage(to index: Int) {
//        let vc = viewsList[index]
//        pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reuseIdentifier, for: indexPath) as! PageCell
        cell.label.text = "\(customTabbar.tabTitleList[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customTabbar.tabTitleList.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        customTabbar.indicatorViewLeadingConstraint.constant = scrollView.contentOffset.x / 6
        
        /*
        /// 스크롤 방향을 알아내기 위한 로직
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        
        if velocity.x < 0 {
            // -: 오른쪽에서 왼쪽 <<<
            direction = -1
        } else if velocity.x > 0 {
            // +: 왼쪽에서 오른쪽 >>>
            direction = 1
        }
        
        if direction == -1 {
            direction = customTabbar.tabTitleList.count - 1
            changePage(to: direction)
        } else if direction == customTabbar.tabTitleList.count {
            direction = 0
            changePage(to: direction)
        }
        print("direction", direction)
        */
    }
}
