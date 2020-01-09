import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var teams: [TeamInfo]!
	
	
	@IBOutlet weak var CardCollection: UICollectionView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		teams = TeamsDatabase.LoadFakeData()
		
	}
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as! TeamCollectionCell
		
		//set cell values
		cell.teamNameOutlet.text = teams[indexPath.row].teamName
		cell.teamDescriptionOutlet.text = teams[indexPath.row].description
		cell.teamIconOutlet.image = UIImage(systemName: teams[indexPath.row].imageIconName)
		
		//vertical top align for description
		cell.teamDescriptionOutlet.sizeToFit()
		
		//shadow styling for card
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

	
	// traverse to next view/controller
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! TeamInfoViewController
		
		//use sender to decide which team to send (which cell was pressed)
		guard let selectedCell = sender as? TeamCollectionCell else{
			return
		}
		let indexPath = CardCollection.indexPath(for: selectedCell)
		
		let selectedTeam = teams[indexPath!.row]
		
		vc.team = selectedTeam
	}

}





