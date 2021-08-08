//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `FriendsCache` test helper extension provides fast and reliable ways of stubbing
/// database requests with canned responses to prevent making real database requests during tests.
/// It also allows observing save commands via the `saveCallback` method.
///
extension FriendsCache {
	static var never: FriendsCache {
		results([])
	}
	
	static func once(_ friends: [Friend]) -> FriendsCache {
		results([.success(friends)])
	}
	
	static func once(_ error: Error) -> FriendsCache {
		results([.failure(error)])
	}
	
	static func saveCallback(
		_ saveCallback: @escaping ([Friend]) -> Void
	) -> FriendsCache {
		results([], saveCallback)
	}

	static func results(
		_ results: [Result<[Friend], Error>],
		_ saveCallback: @escaping ([Friend]) -> Void = { _ in }
	) -> FriendsCache {
		var results = results
		return resultBuilder({ results.removeFirst() }, saveCallback)
	}
		
	static func resultBuilder(
		_ resultBuilder: @escaping () -> Result<[Friend], Error>,
		_ saveCallback: @escaping ([Friend]) -> Void = { _ in }
	) -> FriendsCache {
		FriendsCacheSpy(resultBuilder: resultBuilder, saveCallback: saveCallback)
	}
		
	private class FriendsCacheSpy: FriendsCache {
		private let nextResult: () -> Result<[Friend], Error>
		private let saveCallback: ([Friend]) -> Void
		
		init(
			resultBuilder: @escaping () -> Result<[Friend], Error>,
			saveCallback save: @escaping ([Friend]) -> Void
		) {
			nextResult = resultBuilder
			saveCallback = save
		}
		
		override func loadFriends(completion: @escaping (Result<[Friend], Error>) -> Void) {
			completion(nextResult())
		}
		
		override func save(_ newFriends: [Friend]) {
			saveCallback(newFriends)
		}
	}
}
