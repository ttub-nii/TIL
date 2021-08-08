//
// Copyright © 2021 Essential Developer. All rights reserved.
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
class SentTranfersIntegrationTests: XCTestCase {
	
	override func tearDown() {
		SceneBuilder.reset()
		
		super.tearDown()
	}
	
	func test_sentTransfersList_navigationTitle() throws {
		let sentTransfersList = try SceneBuilder().build().sentTransfersList()
		
		XCTAssertEqual(sentTransfersList.navigationItem.title, "Sent", "title")
	}
	
	func test_sentTransfersList_hasSendMoneyButton() throws {
		let sentTransfersList = try SceneBuilder().build().sentTransfersList()
		
		XCTAssertTrue(sentTransfersList.hasSendMoneyButton, "send money button not found")
	}
	
	func test_sentTransfersList_sendMoneyButton_showsSendMoneyViewOnTap() throws {
		let sentTransfersList = try SceneBuilder().build().sentTransfersList()
		
		XCTAssertFalse(sentTransfersList.isPresentingSendMoneyView, "precondition: shouldn't present send money view before tapping button")
		
		sentTransfersList.tapSendMoneyButton()
		
		XCTAssertTrue(sentTransfersList.isPresentingSendMoneyView, "should present send money view after tapping button")
	}
	
	func test_sentTransfersList_showsOnlySentTranfers_whenAPIRequestSucceeds() throws {
		let transfer0 = aTranfer(description: "a description", amount: 10.75, currencyCode: "USD", sender: "Bob", recipient: "Mary", sent: true, date: .APR_01_1976_AT_12_AM)
		let transfer1 = aTranfer(sent: false)
		let transfer2 = aTranfer(description: "another description", amount: 99.99, currencyCode: "GBP", sender: "Bob", recipient: "Mary", sent: true, date: .JUN_29_2007_AT_9_41_AM)

		let sentTransfersList = try SceneBuilder()
			.build(transfersAPI: .once([transfer0, transfer1, transfer2]))
			.sentTransfersList()
		
		XCTAssertEqual(sentTransfersList.numberOfSentTransfers(), 2, "sentTransfers count")
		XCTAssertEqual(sentTransfersList.transferTitle(at: 0), "$ 10.75 • a description", "sentTransfer title at row 0")
		XCTAssertEqual(sentTransfersList.transferSubtitle(at: 0), "Sent to: Mary on April 1, 1976 at 12:00 AM", "sentTransfer subtitle at row 0")
		XCTAssertEqual(sentTransfersList.transferTitle(at: 1), "£ 99.99 • another description", "sentTransfer title at row 1")
		XCTAssertEqual(sentTransfersList.transferSubtitle(at: 1), "Sent to: Mary on June 29, 2007 at 9:41 AM", "sentTransfer subtitle at row 1")
	}
	
	func test_cardsList_canRefreshData() throws {
		let refreshedTransfer0 = aTranfer(description: "a description", amount: 0.01, currencyCode: "EUR", sender: "Bob", recipient: "Mary", sent: true, date: .APR_01_1976_AT_12_AM)
		let refreshedTransfer1 = aTranfer(sent: false)

		let sentTransfersList = try SceneBuilder()
			.build(transfersAPI: .results([
				.success([]),
				.success([refreshedTransfer0, refreshedTransfer1])
			]))
			.sentTransfersList()
		
		XCTAssertEqual(sentTransfersList.numberOfSentTransfers(), 0, "cards count before refreshing")
		
		sentTransfersList.simulateRefresh()
		
		XCTAssertEqual(sentTransfersList.numberOfSentTransfers(), 1, "cards count after refreshing")
		XCTAssertEqual(sentTransfersList.transferTitle(at: 0), "€ 0.01 • a description", "sentTransfer name at row 0")
		XCTAssertEqual(sentTransfersList.transferSubtitle(at: 0), "Sent to: Mary on April 1, 1976 at 12:00 AM", "sentTransfer phone at row 0")
	}

	func test_sentTransfersList_showsLoadingIndicator_untilAPIRequestSucceeds() throws {
		let sentTransfersList = try SceneBuilder()
			.build(transfersAPI: .resultBuilder {
				let sentTransfersList = try? ContainerViewControllerSpy.current.sentTransfersList()
				XCTAssertEqual(sentTransfersList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request completes")
				return .success([])
			})
			.sentTransfersList()

		XCTAssertEqual(sentTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request completes")

		sentTransfersList.simulateRefresh()

		XCTAssertEqual(sentTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request completes")
	}
	
	func test_sentTransfersList_showsLoadingIndicator_untilAPIRequestFails() throws {
		let sentTransfersList = try SceneBuilder()
			.build(
				transfersAPI: .resultBuilder {
					let sentTransfersList = try? ContainerViewControllerSpy.current.sentTransfersList()
					XCTAssertEqual(sentTransfersList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request fails")
					return .failure(anError())
				}
			)
			.sentTransfersList()
		
		XCTAssertEqual(sentTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request fails")
		
		sentTransfersList.simulateRefresh()
		
		XCTAssertEqual(sentTransfersList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request fails")
	}


	func test_sentTransfersList_showsError_afterRetryingFailedAPIRequestOnce() throws {
		let sentTransfersList = try SceneBuilder()
			.build(
				user: nonPremiumUser(),
				transfersAPI: .results([
					.failure(NSError(localizedDescription: "request error")),
					.failure(NSError(localizedDescription: "retry error")),
				])
			)
			.sentTransfersList()

		XCTAssertEqual(sentTransfersList.numberOfSentTransfers(), 0, "sentTransfers count")
		XCTAssertEqual(sentTransfersList.errorMessage(), "retry error", "error message")
	}

	func test_sentTransfersList_refreshData_retriesOnceOnAPIFailure() throws {
		let sentTransfersList = try SceneBuilder()
			.build(
				transfersAPI: .results([
					.failure(NSError(localizedDescription: "request error")),
					.failure(NSError(localizedDescription: "request retry error")),

					.failure(NSError(localizedDescription: "refresh error")),
					.failure(NSError(localizedDescription: "refresh retry error")),
				])
			)
			.sentTransfersList()

		XCTAssertEqual(sentTransfersList.errorMessage(), "request retry error", "error message before refresh")

		sentTransfersList.hideError()

		XCTAssertEqual(sentTransfersList.errorMessage(), nil, "error message after hiding error")

		sentTransfersList.simulateRefresh()

		XCTAssertEqual(sentTransfersList.errorMessage(), "refresh retry error", "error message after refresh")
	}
	
	func test_sentTransfersList_canSelectTransfer() throws {
		let transfer0 = aTranfer(sent: true)
		let transfer1 = aTranfer(sent: true)
		
		let sentTransfersList = try SceneBuilder()
			.build(transfersAPI: .once([transfer0, transfer1]))
			.sentTransfersList()
		
		sentTransfersList.selectTransfer(at: 0)
		XCTAssertTrue(sentTransfersList.isShowingDetails(for: transfer0), "should show transfer details at row 0")
		
		sentTransfersList.selectTransfer(at: 1)
		XCTAssertTrue(sentTransfersList.isShowingDetails(for: transfer1), "should show transfer details at row 1")
	}

}

private extension ContainerViewControllerSpy {
	///
	/// Provides ways of extracting the "sent transfers" list view controller from the root tab bar
	/// without coupling the tests with internal implementation details, such as the tab item index.
	/// So we can later change those internal details easily without breaking the tests.
	///
	func sentTransfersList() throws -> ListViewController {
		let vc = try XCTUnwrap((rootTab(atIndex: 1) as UINavigationController).topViewController as? ListViewController, "couldn't find sent transfers list")		
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
	func numberOfSentTransfers() -> Int {
		numberOfRows(atSection: sentTransfersSection)
	}
	
	func transferTitle(at row: Int) -> String? {
		title(at: IndexPath(row: row, section: sentTransfersSection))
	}
	
	func transferSubtitle(at row: Int) -> String? {
		subtitle(at: IndexPath(row: row, section: sentTransfersSection))
	}
	
	func selectTransfer(at row: Int) {
		select(at: IndexPath(row: row, section: sentTransfersSection))
		RunLoop.current.run(until: Date())
	}
	
	func isShowingDetails(for transfer: Transfer) -> Bool {
		let vc = navigationController?.topViewController as? TransferDetailsViewController
		return vc?.transfer == transfer
	}

	var hasSendMoneyButton: Bool {
		navigationItem.rightBarButtonItem?.title == "Send"
	}
	
	var isPresentingSendMoneyView: Bool {
		navigationController?.topViewController is SendMoneyViewController
	}
	
	func tapSendMoneyButton() {
		navigationItem.rightBarButtonItem?.simulateTap()
		RunLoop.current.run(until: Date())
	}
	
	private var sentTransfersSection: Int { 0 }
}
