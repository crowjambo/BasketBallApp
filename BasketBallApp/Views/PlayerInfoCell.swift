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
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	func styleItself(playerImage:String? , name:String?, position:String?){
		if let image = playerImage{
			playerImageOutlet.image = UIImage(systemName: image)
		}
		else{
			playerImageOutlet.image = UIImage(systemName: "square")
		}
		if let _name = name{
			if let _position = position{
				namePositionLabelOutlet.text = _name + " , " + _position
			}
		}
		else{
			namePositionLabelOutlet.text = "undefined"
		}
		
	}
	
}
