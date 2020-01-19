import UIKit

class TeamCollectionCell: UICollectionViewCell {
    
	@IBOutlet weak var teamIconOutlet: UIImageView!
	@IBOutlet weak var teamNameOutlet: UILabel!
	@IBOutlet weak var teamDescriptionOutlet: UILabel!
	
	override func awakeFromNib() {
		//vertical top align for description
		teamDescriptionOutlet.sizeToFit()
		
		//shadow styling for card
		contentView.layer.cornerRadius = 2.0
		contentView.layer.borderWidth = 1.0
		contentView.layer.borderColor = UIColor.clear.cgColor
		contentView.layer.masksToBounds = true
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2.0)
		layer.shadowRadius = 2.0
		layer.shadowOpacity = 0.5
		layer.masksToBounds = false
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
	}
	
	func styleItself(teamName:String?, teamDescription:String?, teamIcon:String?){
		
		if let teamName = teamName{
			teamNameOutlet.text = teamName
		}
		if let teamDescription = teamDescription{
			teamDescriptionOutlet.text = teamDescription
		}
		if let teamIcon = teamIcon{
			let url = URL(string: teamIcon)
			teamIconOutlet.load(url: url!)
		}
		else{
			teamIconOutlet.image = UIImage(systemName: "square")
		}
	}
	

}
