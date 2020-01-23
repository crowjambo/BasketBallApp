import UIKit

class PlayerCell: UITableViewCell {
	
	@IBOutlet weak var playerImageOutlet: UIImageView!
	@IBOutlet weak var namePositionLabelOutlet: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	func styleItself(playerImage: String?, name: String?, position: String?) {
		
		if let image = playerImage {
			let url = URL(string: image)
			playerImageOutlet.load(url: url!)
		} else {
			playerImageOutlet.image = UIImage(systemName: "square")
		}
		
		if let name = name {
			if let position = position {
				namePositionLabelOutlet.text = name + " , " + position
			}
		} else {
			namePositionLabelOutlet.text = "undefined"
		}
	}
	
}
