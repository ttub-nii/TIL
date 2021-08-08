//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

struct Friend: Equatable {
	let id: UUID
	let name: String
	let phone: String
}

class FriendsAPI {
	static var shared = FriendsAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.75) {
			completion(.success([
				Friend(id: UUID(), name: "Bob", phone: "9999-9999"),
				Friend(id: UUID(), name: "Mary", phone: "1111-1111")
			]))
		}
	}
}
