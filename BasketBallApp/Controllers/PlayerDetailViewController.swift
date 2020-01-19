import UIKit

class PlayerDetailViewController: UIViewController {

	// MARK: - Variables
	
	var player:Player?
	
	// MARK: - Outlets
	
	@IBOutlet weak var mainPlayerImage: UIImageView!
	@IBOutlet weak var playerNameOutlet: UILabel!
	@IBOutlet weak var ageOutlet: UILabel!
	@IBOutlet weak var heightOutlet: UILabel!
	@IBOutlet weak var weightOutlet: UILabel!
	@IBOutlet weak var descriptionOutlet: UILabel!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		loadData()
    }
	
	// MARK: - Functions
	
	func loadData(){
		
		guard let player = player else { return }
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
