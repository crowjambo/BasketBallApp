//
//  PlayerDetailViewController.swift
//  BasketBallApp
//
//  Created by Evaldas on 1/9/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

	var player:Player?
	
	
	@IBOutlet weak var mainPlayerImage: UIImageView!
	@IBOutlet weak var playerNameOutlet: UILabel!
	@IBOutlet weak var ageOutlet: UILabel!
	@IBOutlet weak var heightOutlet: UILabel!
	@IBOutlet weak var weightOutlet: UILabel!
	@IBOutlet weak var descriptionOutlet: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let player = self.player{
			playerNameOutlet.text = player.name
			ageOutlet.text = String(player.age!)
			heightOutlet.text = String(player.height!)
			weightOutlet.text = String(player.weight!)
			descriptionOutlet.text = player.description
			mainPlayerImage.image = UIImage(named: player.playerMainImage!)
			
			descriptionOutlet.sizeToFit()
		}
    }
    
	


}
