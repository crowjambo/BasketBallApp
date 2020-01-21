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
	
	// TODO: Make age/height/weight into one outlet for easy aligns in storyboard, calculate age from string date input using Date formatter
	// https://www.hackingwithswift.com/example-code/system/how-to-convert-dates-and-times-to-a-string-using-dateformatter
	
	func loadData(){
		
		guard
			let player = player,
			let age = player.age,
			let height = player.height,
			let weight = player.weight,
			let playerMainImage = player.playerMainImage,
			let playerDescription = player.description
			else { return }
		
		playerNameOutlet.text = player.name
		ageOutlet.text = age
		heightOutlet.text = height
		weightOutlet.text = weight
		descriptionOutlet.text = playerDescription
		descriptionOutlet.sizeToFit()
		let url = URL(string: playerMainImage)
		mainPlayerImage.load(url: url!)

		
	}
	
	func getAgeFromDate(date : String) -> Int{
		return 0
		
	}
    
}
