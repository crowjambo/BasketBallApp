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
		loadData()
    }
	
	func loadData(){
		if let player = self.player{
			playerNameOutlet.text = player.name
			if let age = player.age{
				ageOutlet.text = String(age)
			}
			if let height = player.height{
				heightOutlet.text = String(height)
			}
			if let weight = player.weight{
				weightOutlet.text = String(weight)
			}
			if let playerMainImage = player.playerMainImage{
				let url = URL(string: playerMainImage)
				mainPlayerImage.load(url: url!)
			}
			else{
				mainPlayerImage.image = UIImage(systemName: "square")
			}
			descriptionOutlet.text = player.description
			descriptionOutlet.sizeToFit()
		}
	}
    
	


}
