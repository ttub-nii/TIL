//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This test helper method provides a way of creating `Transfer` models without coupling the
/// tests with the `Transfer` initializer. This way, we can change the `Transfer` dependencies
/// and initializer without breaking tests (we just need to update the helper method).
///
func aTranfer(
	id: Int = Int.random(in: 0...Int.max),
	description: String = "any description",
	amount: Double = Double.random(in: 0...10000),
	currencyCode: String = "USD",
	sender: String = "any sender",
	recipient: String = "any recipient",
	sent: Bool,
	date: Date = .distantPast
) -> Transfer {
	Transfer(id: id, description: description, amount: Decimal(amount), currencyCode: currencyCode, sender: sender, recipient: recipient, isSender: sent, date: date)
}
