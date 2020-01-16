import UIKit

fileprivate var aView : UIView?

extension UITableViewCell{
	func showSpinner(){
		aView = UIView(frame: self.bounds)
		aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
		
		let ai = UIActivityIndicatorView(style: .large)
		guard let aView = aView else { return }
		ai.center = aView.center
		ai.startAnimating()
		
		
		aView.addSubview(ai)
		self.addSubview(aView)
		
	}
	
	func removeSpinner(){
		aView?.removeFromSuperview()
		aView = nil
	}
}
