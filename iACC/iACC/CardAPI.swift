//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

struct Card: Equatable {
	let id: Int
	let number: String
	let holder: String
}

class CardAPI {
	static var shared = CardAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadCards(completion: @escaping (Result<[Card], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Card(id: 1, number: "****-0899", holder: "J. DOE"),
				Card(id: 2, number: "****-6544", holder: "DOE J.")
			]))
		}
	}
}
