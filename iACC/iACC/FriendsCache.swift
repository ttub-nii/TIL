//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

class FriendsCache {	
	private var friends: [Friend]?
	
	private struct NoFriendsFound: Error {}
	
	/// For demo purposes, this method simulates an database lookup with a pre-defined in-memory response and delay.
	func loadFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.25) {
			if let friends = self.friends {
				completion(.success(friends))
			} else {
				completion(.failure(NoFriendsFound()))
			}
		}
	}
	
	/// For demo purposes, this method simulates a cache with an in-memory reference to the provided friends.
	func save(_ newFriends: [Friend]) {
		friends = newFriends
	}
}
