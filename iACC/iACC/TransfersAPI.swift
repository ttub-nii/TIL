//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

struct Transfer: Equatable {
	let id: Int
	let description: String
	let amount: Decimal
	let currencyCode: String
	let sender: String
	let recipient: String
	let isSender: Bool
	let date: Date
}

class TransfersAPI {
	static var shared = TransfersAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadTransfers(completion: @escaping (Result<[Transfer], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Transfer(
					id: 1,
					description: "Restaurant bill",
					amount: Decimal(42.78),
					currencyCode: "USD",
					sender: "J. Doe",
					recipient: "Bob",
					isSender: true,
					date: Date(timeIntervalSince1970: 1624614583.565465)
				),
				Transfer(
					id: 2,
					description: "Rent",
					amount: Decimal(728),
					currencyCode: "USD",
					sender: "J. Doe",
					recipient: "Mary",
					isSender: true,
					date: Date(timeIntervalSince1970: 1624604583.565465)
				),
				Transfer(
					id: 3,
					description: "Gas",
					amount: Decimal(37.75),
					currencyCode: "USD",
					sender: "Bob",
					recipient: "J. Doe",
					isSender: false,
					date: Date(timeIntervalSince1970: 1624604583.565465)
				)
			]))
		}
	}
}
