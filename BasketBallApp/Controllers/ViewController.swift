import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	//main collection (could be database or in another file)
	var teams: [TeamInfo] = []
	
	
	// default controller function
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// move all of this to separate model file later
		teams.append(TeamInfo(teamName: "test", description: "adsasdasdasd"))
		teams.append(TeamInfo(teamName: "test2", description: "a234dasd"))
		teams.append(TeamInfo(teamName: "test3", description: "adsas234sd"))
		teams.append(TeamInfo(teamName: "test", description: "adsasd234dasd"))
		
		
		
		
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as! TeamCollectionCell
		
		cell.teamNameOutlet.text = teams[indexPath.row].teamName
		cell.teamDescriptionOutlet.text = teams[indexPath.row].description
		
		cell.contentView.layer.cornerRadius = 2.0
		cell.contentView.layer.borderWidth = 1.0
		cell.contentView.layer.borderColor = UIColor.clear.cgColor
		cell.contentView.layer.masksToBounds = true

		cell.layer.shadowColor = UIColor.black.cgColor
		cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
		cell.layer.shadowRadius = 2.0
		cell.layer.shadowOpacity = 0.5
		cell.layer.masksToBounds = false
		cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
		
		return cell
	}

	

}



