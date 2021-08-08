//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

class SegmentNavigationViewController: UINavigationController {
	private let segments: [UIViewController]
	
	private lazy var segmentControl: UISegmentedControl = {
		UISegmentedControl(
			items: segments.map { $0.navigationItem.title ?? "" }
		)
	}()
	
	var selectedSegmentIndex: Int {
		get { segmentControl.selectedSegmentIndex }
		set {
			segmentControl.selectedSegmentIndex = newValue
			segmentControl.sendActions(for: .valueChanged)
		}
	}
	
	init(first: UIViewController, second: UIViewController) {
		self.segments = [first, second]
		super.init(rootViewController: first)
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.segments = []
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
		selectedSegmentIndex = 0
	}
	
	@objc private func segmentChanged(_ segmentControl: UISegmentedControl) {
		let newSelection = segments[segmentControl.selectedSegmentIndex]
		newSelection.navigationItem.titleView = segmentControl
		setViewControllers([newSelection], animated: false)
	}
}
