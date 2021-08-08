//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit
@testable import iACC

///
/// This `ListViewController` test helper extension provides ways of extracting performing
/// common operations and extracting values from the view controller without coupling the tests with
/// internal implementation details, such as table views, alerts, labels, and buttons. So we can later change
/// those internal details without breaking the tests.
///
extension ListViewController {
	func errorMessage() -> String? {
		presentedAlertView()?.message
	}
	
	func hideError() {
		presenterVC.dismiss(animated: false, completion: nil)
	}
	
	private func presentedAlertView() -> UIAlertController? {
		presenterVC.presentedViewController as? UIAlertController
	}
	
	func isShowingLoadingIndicator() -> Bool {
		refreshControl?.isRefreshing == true
	}
	
	func simulateRefresh() {
		refreshControl?.sendActions(for: .valueChanged)
	}
	
	func numberOfRows(atSection section: Int) -> Int {
		tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
	}
	
	func cell(at indexPath: IndexPath) -> UITableViewCell? {
		guard numberOfRows(atSection: indexPath.section) > indexPath.row else { return nil }
		
		return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
	}
	
	func title(at indexPath: IndexPath) -> String? {
		cell(at: indexPath)?.textLabel?.text
	}
	
	func subtitle(at indexPath: IndexPath) -> String? {
		cell(at: indexPath)?.detailTextLabel?.text
	}
	
	func select(at indexPath: IndexPath) {
		tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}
}
