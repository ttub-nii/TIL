//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

enum Formatters {
	static var date = DateFormatter()
	static var number = NumberFormatter()
}

extension UIViewController {
	var presenterVC: UIViewController {
		parent?.presenterVC ?? parent ?? self
	}
}

extension DispatchQueue {
	static func mainAsyncIfNeeded(execute work: @escaping () -> Void) {
		if Thread.isMainThread {
			work()
		} else {
			main.async(execute: work)
		}
	}
}
