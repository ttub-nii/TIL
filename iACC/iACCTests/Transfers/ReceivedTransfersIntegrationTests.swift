//
// Copyright © 2021 Esreceivedial Developer. All rights reserved.
//

import XCTest
@testable import iACC

///
/// When dealing with legacy code, you most likely won't be able to test screens independently
/// because all dependencies are accessed directly through Singletons or passed from one
/// view controller to another.
///
/// So the simplest way to start testing legacy code is to write Integration Tests covering the
/// behavior from the view controllers all the way to deeper dependencies such as database
/// and network classes.
///
/// Writing fast and reliable Integration Tests before making changes to a legacy codebase can
/// give you confidence that you don't break existing behavior. If you trust those tests and they
/// still pass after a change, you're sure you didn't break anything.
///
/// That's why it's important to write tests you trust before making a change in legacy code.
///
/// So good Integration Tests can give you the confidence you didn't break anything when they pass.
/// But when they fail, it can be hard to find out *why it failed* and *where is the problem* because
/// many components are being tested together. The problem could be in a view, or in a model,
/// or in the database, or in the network component... You probably will have to debug to find the issue.
///
/// Thus, Integration Tests shouldn't be your primary testing strategy. Instead, you should focus on
/// testing components in isolation. So if the tests fail, you know exactly why and where.
///
/// But Integration Tests can be a simple way to start adding coverage to a legacy project until you can
/// break down the components and test them in isolation.
///
/// So to make this legacy project realistic, we kept the entangled legacy classes to show how you can start
/// testing components in integration without making massive changes to the project.
///
class ReceivedTransfersIntegrationTests: XCTestCase {
	
	override func tearDown() {
		SceneBuilder.reset()
		
		super.tearDown()
	}
	
	func test_receivedTransfersList_navigationTitle() throws {
		let receivedTransfersList = try SceneBuilder().build().receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.navigationItem.title, "Received", "title")
	}
	
	func test_receivedTransfersList_hasRequestMoneyButton() throws {
		let receivedTransfersList = try SceneBuilder().build().receivedTransfersList()
		
		XCTAssertTrue(receivedTransfersList.hasRequestMoneyButton, "request money button not found")
	}
	
	func test_receivedTransfersList_sendMoneyButton_showsRequestMoneyViewOnTap() throws {
		let receivedTransfersList = try SceneBuilder().build().receivedTransfersList()
		
		XCTAssertFalse(receivedTransfersList.isPresentingRequestMoneyView, "precondition: shouldn't present request money view before tapping button")
		
		receivedTransfersList.tapRequestMoneyButton()
		
		XCTAssertTrue(receivedTransfersList.isPresentingRequestMoneyView, "should present request money view after tapping button")
	}
	
	func test_receivedTransfersList_showsOnlyReceivedTranfers_whenAPIRequestSucceeds() throws {
		let transfer0 = aTranfer(description: "a description", amount: 10.75, currencyCode: "USD", sender: "Bob", recipient: "Mary", sent: false, date: .APR_01_1976_AT_12_AM)
		let transfer1 = aTranfer(sent: true)
		let transfer2 = aTranfer(description: "another description", amount: 99.99, currencyCode: "GBP", sender: "Bob", recipient: "Mary", sent: false, date: .JUN_29_2007_AT_9_41_AM)
		
		let receivedTransfersList = try SceneBuilder()
			.build(transfersAPI: .once([transfer0, transfer1, transfer2]))
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.numberOfReceivedTransfers(), 2, "receivedTransfers count")
		XCTAssertEqual(receivedTransfersList.transferTitle(at: 0), "$ 10.75 • a description", "receivedTransfer title at row 0")
		XCTAssertEqual(receivedTransfersList.transferSubtitle(at: 0), "Received from: Bob on 4/1/76, 12:00 AM", "receivedTransfer subtitle at row 0")
		XCTAssertEqual(receivedTransfersList.transferTitle(at: 1), "£ 99.99 • another description", "receivedTransfer title at row 1")
		XCTAssertEqual(receivedTransfersList.transferSubtitle(at: 1), "Received from: Bob on 6/29/07, 9:41 AM", "receivedTransfer subtitle at row 1")
	}
	
	func test_cardsList_canRefreshData() throws {
		let refreshedTransfer0 = aTranfer(description: "a description", amount: 0.01, currencyCode: "EUR", sender: "Bob", recipient: "Mary", sent: false, date: .APR_01_1976_AT_12_AM)
		let refreshedTransfer1 = aTranfer(sent: true)
		
		let receivedTransfersList = try SceneBuilder()
			.build(transfersAPI: .results([
				.success([]),
				.success([refreshedTransfer0, refreshedTransfer1])
			]))
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.numberOfReceivedTransfers(), 0, "cards count before refreshing")
		
		receivedTransfersList.simulateRefresh()
		
		XCTAssertEqual(receivedTransfersList.numberOfReceivedTransfers(), 1, "cards count after refreshing")
		XCTAssertEqual(receivedTransfersList.transferTitle(at: 0), "€ 0.01 • a description", "receivedTransfer name at row 0")
		XCTAssertEqual(receivedTransfersList.transferSubtitle(at: 0), "Received from: Bob on 4/1/76, 12:00 AM", "receivedTransfer phone at row 0")
	}
	
	func test_receivedTransfersList_showsLoadingIndicator_untilAPIRequestSucceeds() throws {
		let receivedTransfersList = try SceneBuilder()
			.build(transfersAPI: .resultBuilder {
				let receivedTransfersList = try? ContainerViewControllerSpy.current.receivedTransfersList()
				XCTAssertEqual(receivedTransfersList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request completes")
				return .success([])
			})
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request completes")
		
		receivedTransfersList.simulateRefresh()
		
		XCTAssertEqual(receivedTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request completes")
	}
	
	func test_receivedTransfersList_showsLoadingIndicator_untilAPIRequestFails() throws {
		let receivedTransfersList = try SceneBuilder()
			.build(transfersAPI: .resultBuilder {
				let receivedTransfersList = try? ContainerViewControllerSpy.current.receivedTransfersList()
				XCTAssertEqual(receivedTransfersList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request fails")
				return .failure(anError())
			})
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request fails")
		
		receivedTransfersList.simulateRefresh()
		
		XCTAssertEqual(receivedTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request fails")
	}
	
	func test_receivedTransfersList_showsError_afterRetryingFailedAPIRequestOnce() throws {
		let receivedTransfersList = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
				transfersAPI: .results([
					.failure(NSError(localizedDescription: "request error")),
					.failure(NSError(localizedDescription: "retry error")),
				])
			)
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.numberOfReceivedTransfers(), 0, "receivedTransfers count")
		XCTAssertEqual(receivedTransfersList.errorMessage(), "retry error", "error message")
	}
	
	func test_receivedTransfersList_refreshData_retriesOnceOnAPIFailure() throws {
		let receivedTransfersList = try SceneBuilder()
			.build(
				transfersAPI: .results([
					.failure(NSError(localizedDescription: "request error")),
					.failure(NSError(localizedDescription: "request retry error")),
					
					.failure(NSError(localizedDescription: "refresh error")),
					.failure(NSError(localizedDescription: "refresh retry error")),
				])
			)
			.receivedTransfersList()
		
		XCTAssertEqual(receivedTransfersList.errorMessage(), "request retry error", "error message before refresh")
		
		receivedTransfersList.hideError()
		
		XCTAssertEqual(receivedTransfersList.errorMessage(), nil, "error message after hiding error")
		
		receivedTransfersList.simulateRefresh()
		
		XCTAssertEqual(receivedTransfersList.errorMessage(), "refresh retry error", "error message after refresh")
	}
	
	func test_receivedTransfersList_canSelectTransfer() throws {
		let transfer0 = aTranfer(sent: false)
		let transfer1 = aTranfer(sent: false)
		
		let receivedTransfersList = try SceneBuilder()
			.build(transfersAPI: .once([transfer0, transfer1]))
			.receivedTransfersList()
		
		receivedTransfersList.selectTransfer(at: 0)
		XCTAssertTrue(receivedTransfersList.isShowingDetails(for: transfer0), "should show transfer details at row 0")
		
		receivedTransfersList.selectTransfer(at: 1)
		XCTAssertTrue(receivedTransfersList.isShowingDetails(for: transfer1), "should show transfer details at row 1")
	}
	
}

private extension ContainerViewControllerSpy {
	///
	/// Provides ways of extracting the "received transfers" list view controller from the root tab bar
	/// without coupling the tests with internal implementation details, such as the tab item index.
	/// So we can later change those internal details easily without breaking the tests.
	///
	func receivedTransfersList() throws -> ListViewController {
		let navigation = try rootTab(atIndex: 1) as SegmentNavigationViewController
		
		if navigation.selectedSegmentIndex != 1 {
			navigation.selectedSegmentIndex = 1
		}
		
		let vc = try XCTUnwrap(navigation.topViewController as? ListViewController, "couldn't find received transfers list")
		vc.triggerLifecycleIfNeeded()
		return vc
	}
}

///
/// This `ListViewController` test helper extension provides ways of extracting values
/// from the view controller without coupling the tests with internal implementation details, such as
/// table views, labels, and buttons. So we can later change those internal details without
/// breaking the tests.
///
private extension ListViewController {
	func numberOfReceivedTransfers() -> Int {
		numberOfRows(atSection: receivedTransfersSection)
	}
	
	func transferTitle(at row: Int) -> String? {
		title(at: IndexPath(row: row, section: receivedTransfersSection))
	}
	
	func transferSubtitle(at row: Int) -> String? {
		subtitle(at: IndexPath(row: row, section: receivedTransfersSection))
	}
	
	func selectTransfer(at row: Int) {
		select(at: IndexPath(row: row, section: receivedTransfersSection))
		RunLoop.current.run(until: Date())
	}
	
	func isShowingDetails(for transfer: Transfer) -> Bool {
		let vc = navigationController?.topViewController as? TransferDetailsViewController
		return vc?.transfer == transfer
	}

	var hasRequestMoneyButton: Bool {
		navigationItem.rightBarButtonItem?.title == "Request"
	}
	
	var isPresentingRequestMoneyView: Bool {
		navigationController?.topViewController is RequestMoneyViewController
	}
	
	func tapRequestMoneyButton() {
		navigationItem.rightBarButtonItem?.simulateTap()
		RunLoop.current.run(until: Date())
	}
	
	private var receivedTransfersSection: Int { 0 }
}
