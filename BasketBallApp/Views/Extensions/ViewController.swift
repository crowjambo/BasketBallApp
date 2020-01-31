import UIKit

extension UIViewController {
	
	func setupNavigationTitleImage() {
		
		let titleImageView = UIImageView(image: #imageLiteral(resourceName: "nbalogo") )
		titleImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
		titleImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
		titleImageView.contentMode = .scaleAspectFit
		navigationItem.titleView = titleImageView
		 
	  }
}
