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
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	func styleItself(dateLabel:String?, team1Name:String?, team2Name:String?){
		if let _team1 = team1Name{
			team1NameOutlet.text = _team1
		}
		if let _team2 = team2Name{
			team2NameOutlet.text = _team2
		}
		if let _date = dateLabel{
			dateLabelOutlet.text = _date
		}
	}

}
