//
//  MatchInfoCell.swift
//  BasketBallApp
//
//  Created by Evaldas on 1/9/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import UIKit

class MatchInfoCell: UITableViewCell {
	
	@IBOutlet weak var dateLabelOutlet: UILabel!
	@IBOutlet weak var team1NameOutlet: UILabel!
	@IBOutlet weak var team2NameOutlet: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
