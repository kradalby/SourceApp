//
//  PlayerTableViewCell.swift
//  Source
//
//  Created by Kristoffer Dalby on 01/01/16.
//  Copyright © 2016 Kristoffer Dalby. All rights reserved.
//

import Foundation
import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var killsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
