//
//  TabCell.swift
//  TodayHouse
//
//  Created by toby.with on 2021/07/29.
//

import UIKit

class TabCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .black
    }

    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                titleLabel.textColor = .main
            } else {
                titleLabel.textColor = .black
            }
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
}
