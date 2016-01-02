//
//  ServerTableViewCell.swift
//  Source
//
//  Created by Kristoffer Dalby on 27/12/15.
//  Copyright © 2015 Kristoffer Dalby. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {

    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var playersLabel: UILabel!

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
