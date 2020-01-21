import UIKit

// TODO: Dont use Data(contentsOf: ) use alamoFire instead, and probably in another place, instead of View
extension UIImageView{
	func load(url: URL){
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url){
				if let image = UIImage(data: data){
					DispatchQueue.main.async{
						self?.image = image
					}
				}
			}
		}
	}
}
