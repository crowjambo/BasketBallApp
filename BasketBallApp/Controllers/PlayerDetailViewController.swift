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
		playerDetailsOutlet.text = "\(getAgeFromDate(date: age))  \(splitWeight(weight: weight)) lbs  \(splitHeight(height: height))"
		descriptionOutlet.text = playerDescription
		descriptionOutlet.sizeToFit()
		let url = URL(string: playerMainImage)
		mainPlayerImage.kf.setImage(with: url)
		
	}
	
	private func splitHeight(height: String) -> String {
		let array = height.components(separatedBy: "(")
		return array[0]
	}
	
	private func splitWeight(weight: String) -> String {
		let array = weight.components(separatedBy: " ")
		return array[0]
	}
	
	private func getAgeFromDate(date: String) -> String {
		
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-mm-dd"
		let formattedDate = formatter.date(from: date)

		let calendar = Calendar.current
		let components = calendar.dateComponents([.year], from: formattedDate ?? Date(), to: Date())
		
		let finalDate = calendar.date(from: components)
		
		formatter.dateFormat = "y"
		
		return formatter.string(from: finalDate!)
		
	}
    
	// MARK: - Navigation bar image
	
	func setupNavigationTitleImage() {
		
		let titleImageView = UIImageView(image: #imageLiteral(resourceName: "nbalogo") )
		titleImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
		titleImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		titleImageView.contentMode = .scaleAspectFit
		navigationItem.titleView = titleImageView
		 
	  }
}
