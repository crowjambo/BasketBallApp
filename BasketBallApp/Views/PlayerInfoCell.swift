//
//  PlayerInfoCell.swift
//  BasketBallApp
//
//  Created by Evaldas on 1/9/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import UIKit

class PlayerInfoCell: UITableViewCell {

	
	@IBOutlet weak var playerImageOutlet: UIImageView!
	@IBOutlet weak var namePositionLabelOutlet: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	
	
}
