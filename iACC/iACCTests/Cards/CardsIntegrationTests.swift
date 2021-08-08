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
class CardsIntegrationTests: XCTestCase {
	
	override func tearDown() {
		SceneBuilder.reset()
		
		super.tearDown()
	}
	
	func test_cardsList_title() throws {
		let cardsList = try SceneBuilder().build().cardsList()
		
		XCTAssertEqual(cardsList.title, "Cards", "title")
	}
	
	func test_cardsList_hasAddCardButton() throws {
		let cardsList = try SceneBuilder().build().cardsList()
		
		XCTAssertTrue(cardsList.hasAddCardButton, "add card button not found")
	}
	
	func test_cardsList_addCardButton_showsAddCardViewOnTap() throws {
		let cardsList = try SceneBuilder().build().cardsList()
		
		XCTAssertFalse(cardsList.isPresentingAddCardView, "precondition: shouldn't present add card view before tapping button")
		
		cardsList.tapAddCardButton()
		
		XCTAssertTrue(cardsList.isPresentingAddCardView, "should present add card view after tapping button")
	}
	
	func test_cardsList_showsCards_whenAPIRequestSucceeds() throws {
		let card0 = aCard(number: "a number", holder: "a holder")
		let card1 = aCard(number: "another number", holder: "another holder")
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .once([card0, card1]))
			.cardsList()
		
		XCTAssertEqual(cardsList.numberOfCards(), 2, "cards count")
		XCTAssertEqual(cardsList.cardNumber(at: 0), card0.number, "card number at row 0")
		XCTAssertEqual(cardsList.cardHolder(at: 0), card0.holder, "card holder at row 0")
		XCTAssertEqual(cardsList.cardNumber(at: 1), card1.number, "card number at row 1")
		XCTAssertEqual(cardsList.cardHolder(at: 1), card1.holder, "card holder at row 1")
	}
	
	func test_cardsList_showsError_whenAPIRequestFails() throws {
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .once(NSError(localizedDescription: "an error")))
			.cardsList()
		
		XCTAssertEqual(cardsList.errorMessage(), "an error")
	}
	
	func test_cardsList_canRefreshData() throws {
		let refreshedCard = aCard(number: "refreshed number", holder: "refreshed holder")
		
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .results([
				.success([]),
				.success([refreshedCard])
			]))
			.cardsList()
		
		XCTAssertEqual(cardsList.numberOfCards(), 0, "cards count before refreshing")
		
		cardsList.simulateRefresh()
		
		XCTAssertEqual(cardsList.numberOfCards(), 1, "cards count after refreshing")
		XCTAssertEqual(cardsList.cardNumber(at: 0), refreshedCard.number, "refreshed card number at row 0")
		XCTAssertEqual(cardsList.cardHolder(at: 0), refreshedCard.holder, "refreshed card holder at row 0")
	}
	
	func test_cardsList_showsLoadingIndicator_untilAPIRequestSucceeds() throws {
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .resultBuilder {
				let cardsList = try? ContainerViewControllerSpy.current.cardsList()
				XCTAssertEqual(cardsList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request completes")
				return .success([aCard()])
			})
			.cardsList()
		
		XCTAssertEqual(cardsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request completes")
		
		cardsList.simulateRefresh()
		
		XCTAssertEqual(cardsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request completes")
	}
	
	func test_cardsList_showsLoadingIndicator_untilAPIRequestFails() throws {
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .resultBuilder {
				let cardsList = try? ContainerViewControllerSpy.current.cardsList()
				XCTAssertEqual(cardsList?.isShowingLoadingIndicator(), true, "should show loading indicator until API request fails")
				return .failure(anError())
			})
			.cardsList()
		
		XCTAssertEqual(cardsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API request fails")
		
		cardsList.simulateRefresh()
		
		XCTAssertEqual(cardsList.isShowingLoadingIndicator(), false, "should hide loading indicator once API refresh request fails")
	}
	
	func test_cardsList_canSelectCard() throws {
		let card0 = aCard(number: "a number", holder: "a holder")
		let card1 = aCard(number: "another number", holder: "another holder")
		let cardsList = try SceneBuilder()
			.build(cardsAPI: .once([card0, card1]))
			.cardsList()

		cardsList.selectCard(at: 0)
		XCTAssertTrue(cardsList.isShowingDetails(for: card0), "should show card details at row 0")

		cardsList.selectCard(at: 1)
		XCTAssertTrue(cardsList.isShowingDetails(for: card1), "should show card details at row 1")
	}
	
}

private extension ContainerViewControllerSpy {
	///
	/// Provides ways of extracting the "cards" list view controller from the root tab bar
	/// without coupling the tests with internal implementation details, such as the tab item index.
	/// So we can later change those internal details easily without breaking the tests.
	///
	func cardsList() throws -> ListViewController {
		let vc = try XCTUnwrap((rootTab(atIndex: 2) as UINavigationController).topViewController as? ListViewController, "couldn't find card list")
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
	func numberOfCards() -> Int {
		numberOfRows(atSection: cardsSection)
	}
	
	func cardNumber(at row: Int) -> String? {
		title(at: IndexPath(row: row, section: cardsSection))
	}
	
	func cardHolder(at row: Int) -> String? {
		subtitle(at: IndexPath(row: row, section: cardsSection))
	}
	
	func selectCard(at row: Int) {
		select(at: IndexPath(row: row, section: cardsSection))
		RunLoop.current.run(until: Date())
	}
	
	func isShowingDetails(for card: Card) -> Bool {
		let vc = navigationController?.topViewController as? CardDetailsViewController
		return vc?.card == card
	}

	var hasAddCardButton: Bool {
		navigationItem.rightBarButtonItem?.systemItem == .add
	}
	
	var isPresentingAddCardView: Bool {
		navigationController?.topViewController is AddCardViewController
	}
	
	func tapAddCardButton() {
		navigationItem.rightBarButtonItem?.simulateTap()
		RunLoop.current.run(until: Date())
	}
	
	private var cardsSection: Int { 0 }
}
