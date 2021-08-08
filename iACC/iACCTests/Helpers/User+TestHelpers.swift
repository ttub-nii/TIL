//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

func nonPremiumUser() -> User {
	aUser(isPremium: false)
}

func premiumUser() -> User {
	aUser(isPremium: true)
}

///
/// This test helper method provides a way of creating `User` models without coupling the
/// tests with the `User` initializer. This way, we can change the `User` dependencies
/// and initializer without breaking tests (we just need to update the helper method).
///
func aUser(id: UUID = UUID(), name: String = "any name", isPremium: Bool) -> User {
	User(id: id, name: name, isPremium: isPremium)
}
