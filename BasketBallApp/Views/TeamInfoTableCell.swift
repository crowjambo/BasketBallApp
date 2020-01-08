//
//  TeamInfoTableCell.swift
//  BasketBallApp
//
//  Created by Evaldas on 1/8/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import UIKit


class TeamInfoTableCell: UITableViewCell{
	// connected UI elements
	@IBOutlet weak var teamIconOutlet: UIImageView!
	@IBOutlet weak var titleTeamNameOutlet: UILabel!
	@IBOutlet weak var teamDescriptionOutlet: UILabel!
	
	
	// TableViewCell implementation methods
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
}
