//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `TransfersAPI` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension TransfersAPI {
	static func once(_ Transfers: [Transfer]) -> TransfersAPI {
		results([.success(Transfers)])
	}
	
	static func once(_ error: Error) -> TransfersAPI {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[Transfer], Error>]) -> TransfersAPI {
		var mutableResults = results
		return resultBuilder { mutableResults.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Transfer], Error>) -> TransfersAPI {
		TransfersAPIStub(resultBuilder: resultBuilder)
	}
	
	private class TransfersAPIStub: TransfersAPI {
		private let nextResult: () -> Result<[Transfer], Error>
		
		init(resultBuilder: @escaping () -> Result<[Transfer], Error>) {
			nextResult = resultBuilder
		}
		
		override func loadTransfers(completion: @escaping (Result<[Transfer], Error>) -> Void) {
			completion(nextResult())
		}
	}
}
