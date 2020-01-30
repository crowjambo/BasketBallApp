import UIKit
import Kingfisher

class TeamCollectionSmallSquareCell: UICollectionViewCell {
    
	
	@IBOutlet weak var teamLogoOutlet: UIImageView!
	
	func styleItself(teamIcon: String?) {
		
		guard
			let teamIcon = teamIcon
			else { return }

		let url = URL(string: teamIcon)
		teamLogoOutlet.kf.setImage(with: url)
		
	}
}

	



