//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation
@testable import iACC

///
/// This `CardAPI` test helper extension provides fast and reliable ways of stubbing
/// network requests with canned results to prevent making real network requests during tests.
///
extension CardAPI {	
	static func once(_ cards: [Card]) -> CardAPI {
		results([.success(cards)])
	}
	
	static func once(_ error: Error) -> CardAPI {
		results([.failure(error)])
	}
	
	static func results(_ results: [Result<[Card], Error>]) -> CardAPI {
		var results = results
		return resultBuilder { results.removeFirst() }
	}
	
	static func resultBuilder(_ resultBuilder: @escaping () -> Result<[Card], Error>) -> CardAPI {
		CardAPIStub(resultBuilder: resultBuilder)
	}
	
	private class CardAPIStub: CardAPI {
		private let nextResult: () -> Result<[Card], Error>
		
		init(resultBuilder: @escaping () -> Result<[Card], Error>) {
			nextResult = resultBuilder
		}
		
		override func loadCards(completion: @escaping (Result<[Card], Error>) -> Void) {
			completion(nextResult())
		}
	}
}
