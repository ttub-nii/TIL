//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
import XCTest
@testable import iACC

///
/// This `ContainerViewControllerSpy` test helper provides a simple way of extracting
/// view controllers from the root tab bar controller. It also captures all presented view controllers
/// to facilitate testing modal view controller presentations.
///
/// ---
///
/// When dealing with legacy code, you most likely won't be able to test screens independently
/// because all dependencies are accessed directly through Singletons or passed from one
/// view controller to the other.
///
/// So the simplest way to start testing legacy code is to extract the app's view controllers
/// from the root view controller (in this app, the root view controller is a UITabBarController).
///
/// Extracting the view controllers is not necessary when you have a proper architecture,
/// where every view controller is independent and can be tested in isolation.
///
/// But it's a simple way to start testing legacy code until you can separate all view controllers
/// with proper separation of concerns.
///
/// So to make this legacy project realistic, we kept the entangled view controllers setup
/// to show how you can start testing components without making massive changes to the project.
///
class ContainerViewControllerSpy: UIViewController {
	private(set) static var current = ContainerViewControllerSpy()
	private var rootTabBar: UITabBarController?
	
	convenience init(_ rootViewController: UITabBarController) {
		self.init()
		
		ContainerViewControllerSpy.current = self
		
		rootTabBar = rootViewController
		addChild(rootViewController)
		rootViewController.view.frame = view.frame
		view.addSubview(rootViewController.view)
		rootViewController.didMove(toParent: self)
	}
	
	private var capturedPresentedViewController: UIViewController?

	override var presentedViewController: UIViewController? {
		return capturedPresentedViewController
	}
	
	override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
		capturedPresentedViewController = viewControllerToPresent
	}
	
	override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
		capturedPresentedViewController = vc
	}
	
	override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
		capturedPresentedViewController = nil
	}

	func rootTab<T>(atIndex index: Int) throws -> T {
		let root = try XCTUnwrap(rootTabBar, "root tab bar not set")
		
		if root.selectedIndex != index {
			root.selectedIndex = index
		}
		
		return try XCTUnwrap(root.selectedViewController as? T, "controller type at tab \(index) should be \(String(describing: T.self))")
	}
}
