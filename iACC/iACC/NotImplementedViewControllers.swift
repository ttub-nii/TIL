//	
// Copyright © 2021 Essential Developer. All rights reserved.
//

import UIKit

class FriendDetailsViewController: NotImplementedViewController {
	var friend: Friend?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Friend Details"
	}
}

class AddFriendViewController: NotImplementedViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Add Friend"
	}
}

class CardDetailsViewController: NotImplementedViewController {
	var card: Card?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Card Details"
	}
}

class AddCardViewController: NotImplementedViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Add Card"
	}
}

class TransferDetailsViewController: NotImplementedViewController {
	var transfer: Transfer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Transfer Details"
	}
}

class SendMoneyViewController: NotImplementedViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Send Money"
	}
}

class RequestMoneyViewController: NotImplementedViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Request Money"
	}
}

class ArticleViewController: NotImplementedViewController {
	var article: Article?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Article"
	}
}

class NotImplementedViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white

		let label = UILabel()
		label.text = "Not implemented in this demo."
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		
		NSLayoutConstraint.activate([
			label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])
	}
}
