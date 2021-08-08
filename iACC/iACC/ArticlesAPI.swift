//
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

struct Article: Equatable {
	let id: UUID
	let title: String
	let author: String
}

class ArticlesAPI {
	static var shared = ArticlesAPI()
	
	/// For demo purposes, this method simulates an API request with a pre-defined response and delay.
	func loadCards(completion: @escaping (Result<[Article], Error>) -> Void) {
		DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
			completion(.success([
				Article(id: UUID(), title: "iOS Architecture 101", author: "Mike A."),
				Article(id: UUID(), title: "Refactoring 101", author: "Caio Z.")
			]))
		}
	}
}
