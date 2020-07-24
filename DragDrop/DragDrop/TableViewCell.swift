//
//  TableViewCell.swift
//  DragDrop
//
//  Created by 황수빈 on 2020/07/05.
//  Copyright © 2020 황수빈. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var checkSwitch: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
