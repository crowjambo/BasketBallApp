import UIKit
import Kingfisher

class PlayerDetailViewController: UIViewController {

	// MARK: - Variables
	
	var player: Player?
	
	// MARK: - Outlets
	
	@IBOutlet weak var mainPlayerImage: UIImageView!
	@IBOutlet weak var playerNameOutlet: UILabel!
	@IBOutlet weak var playerDetailsOutlet: UILabel!
	@IBOutlet weak var descriptionOutlet: UILabel!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadData()
		setupNavigationTitleImage()
    }
	
	// MARK: - Functions
	
	func loadData() {
		
		guard
			let player = player,
			let age = player.age,
			let height = player.height,
			let weight = player.weight,
			let playerMainImage = player.playerMainImage,
			let playerDescription = player.description
			else { return }
		
		playerNameOutlet.text = player.name
		playerDetailsOutlet.text = "\(Date.getAgeFromDateOfBirth(date: age))  \(String.splitWeight(weight: weight)) lbs  \(String.splitHeight(height: height))"
		descriptionOutlet.text = playerDescription
		descriptionOutlet.sizeToFit()
		let url = URL(string: playerMainImage)
		mainPlayerImage.kf.setImage(with: url)
		
	}
    
}
