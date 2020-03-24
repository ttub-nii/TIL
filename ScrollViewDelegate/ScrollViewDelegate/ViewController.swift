//
//  ViewController.swift
//  ScrollViewDelegate
//
//  Created by 황수빈 on 22/02/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var logo: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ViewController : UITableViewDelegate {}
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        return cell
    }
}

// 스크롤 시 Top View 올리고 내리기
extension ViewController : UIScrollViewDelegate {
    /*
     navigationItem.searchController = searchController
     navigationItem.hidesSearchBarWhenScrolling = true
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 이동 제스처는 화면에서 손가락의 움직임을 감지하고 이 움직임을 콘텐츠에 적용하는 데 사용되며 PanGestureRecognizer 클래스로 구현합니다.
        let yVelocity = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        
        // velocity 는 Pan Gesture의 속도입니다. 리턴값은 CGPoint값이며 초당 포인트(점)로 표시됩니다. 속도는 수평 및 수직 구성요소로 나뉩니다. 속력과 속도의 차이.. 아시죠?
        if yVelocity > 0 {
            downHomeView()
            
        } else if yVelocity < 0 {
            upHomeView()
        }
    }
    
    // 뷰 올려서 안 보이게 하기
    func upHomeView() {
        self.tableViewContraint.constant = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            
            // 사라지는데 효과를 주고 싶다면 opacity 값, 애니메이션 등을 사용해보세요.
            //self.logo.alpha = 0
            self.logo.textColor = .black
            self.topView.backgroundColor = .black
            
            // 상단바 위치 올리기
            self.topView.transform = CGAffineTransform(translationX: 0, y: -115)
            // self.topView.transform = CGAffineTransform(translationX: 0, y: -self.tableView.contentOffset.y)
            self.view.layoutIfNeeded()
        })
    }
    
    // 뷰 내려서 보이게 하기 (원 위치)
    func downHomeView() {
        self.tableViewContraint.constant = 213
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            // self.logo.alpha = 1
            self.logo.textColor = .white
            self.topView.backgroundColor = .systemPink
            
            // identity 는 CGAffineTransform의 속성 값을 원래대로 되돌리는 private key로 적용된 모든 변환을 제거하는 방법입니다.
            // static var identity: CGAffineTransform { get }
            self.topView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
}
