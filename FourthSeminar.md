## Fourth Seminar

> [2020.02.22]

1. ScrollView Delegate
   - Create TableView and TopView just for Test
   - TopView Should place in front of the TableView
   - Add top contraints for each object
   - Let's transform these When scrollViewDidScroll
<br />

2. Usage Example
   <div>
  ![Feb-22-2020 02-08-19](https://user-images.githubusercontent.com/44978839/75055491-717fd300-5518-11ea-9898-b7141e0a7a0b.gif)
   </div>
<br />

3. Usage

> *  1. Create @IBOutlet & Top Contraints
 
 ```swift
    @IBOutlet var logo: UILabel!
    @IBOutlet var topView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewContraint: NSLayoutConstraint!
 ```
 <br />
 
> *  2. Use scrollViewDidScroll function with PanGestureRecognizer
 
 ```swift
 // 스크롤 시 Top View 올리고 내리기
extension ViewController : UIScrollViewDelegate {
    
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
            
            // 상단바 위치 올리기
            self.topView.transform = CGAffineTransform(translationX: 0, y: -115)
            self.view.layoutIfNeeded()
        })
    }
    
    // 뷰 내려서 보이게 하기 (원 위치)
    func downHomeView() {
        self.tableViewContraint.constant = 213
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            // self.logo.alpha = 1
            self.logo.textColor = .white
            
            // identity 는 CGAffineTransform의 속성 값을 원래대로 되돌리는 private key로 적용된 모든 변환을 제거하는 방법입니다.
            // static var identity: CGAffineTransform { get }
            self.topView.transform = .identity
            self.view.layoutIfNeeded()
        })
    }
}
```
