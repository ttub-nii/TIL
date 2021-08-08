//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import Foundation

extension TimeZone {
	static var GMT: TimeZone {
		TimeZone(secondsFromGMT: 0)!
	}
}
