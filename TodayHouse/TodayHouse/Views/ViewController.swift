//
//  ViewController.swift
//  TodayHouse
//
//  Created by toby.with on 2021/07/28.
//

import UIKit

class ViewController: UIViewController, CustomTabbarDelegate {
    private var direction = 0
    @IBOutlet weak var customTabbar: CustomTabbar! {
        didSet {
            customTabbar.delegate = self
        }
    }
    @IBOutlet weak var pageCollectionView: UICollectionView! {
        didSet {
            pageCollectionView.delegate = self
            pageCollectionView.dataSource = self
            pageCollectionView.backgroundColor = .gray
            pageCollectionView.showsHorizontalScrollIndicator = false
            pageCollectionView.isPagingEnabled = true
            pageCollectionView.register(UINib(nibName: PageCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PageCell.reuseIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Delegate
    func changePage(to index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        self.pageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
    
    /// page 의 스크롤이 끝났을 때, tab의 index 변경을 위한 method
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let itemAt = Int(targetContentOffset.pointee.x / self.view.frame.width)
        let indexPath = IndexPath(item: itemAt, section: 0)
        customTabbar.tabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageCollectionView.frame.width, height: pageCollectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
