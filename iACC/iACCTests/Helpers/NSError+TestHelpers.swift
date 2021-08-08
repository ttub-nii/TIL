//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

func anError() -> Error {
	NSError(localizedDescription: "any error message")
}

extension NSError {
	convenience init(localizedDescription: String) {
		self.init(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
	}
}
