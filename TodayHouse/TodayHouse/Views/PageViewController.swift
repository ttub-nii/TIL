//
//  PageViewController.swift
//  TodayHouse
//
//  Created by toby.with on 2021/08/12.
//

import UIKit

class PageViewController: UIViewController {
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var currentIndex : Int {
        guard let vc = viewsList.first else { return 0 }
        return viewsList.firstIndex(of: vc) ?? 0
    }
    
    let viewsList : [UIViewController] = {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc1 = storyBoard.instantiateViewController(withIdentifier: "GreenViewController")
        let vc2 = storyBoard.instantiateViewController(withIdentifier: "RedViewController")
        let vc3 = storyBoard.instantiateViewController(withIdentifier: "BlueViewController")
        
        return [vc1, vc2, vc3]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
    }

    private func setPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstVC = viewsList.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        return previousIndex < 0 ? viewsList.last : viewsList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewsList.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        return nextIndex >= viewsList.count ? viewsList.first : viewsList[nextIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let indexPath = IndexPath(item: currentIndex, section: 0)
//            customTabbar.tabBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
    }
}
