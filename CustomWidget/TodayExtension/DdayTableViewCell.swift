//
//  DdayTableViewCell.swift
//  TodayExtension
//
//  Created by 황수빈 on 06/03/2020.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class DdayTableViewCell: UITableViewCell {

    /// The reuse identifier for this table view cell.
    static let reuseIdentifier = "DdayTableViewCell"

    // Heights for the two styles of cell display.
    static let todayCellHeight: CGFloat = 110
    static let standardCellHeight: CGFloat = 55

    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
