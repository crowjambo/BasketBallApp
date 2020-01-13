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
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as? TeamCollectionCell {
			cell.styleItself(teamName: teams[indexPath.row].teamName, teamDescription: teams[indexPath.row].description, teamIcon: teams[indexPath.row].imageIconName)

			return cell
		}else{
			return UICollectionViewCell()
		}
		

	}
	
	// traverse to next view/controller
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if let vc = segue.destination as? TeamInfoViewController{
			//use sender to decide which team to send (which cell was pressed)
			guard let selectedCell = sender as? TeamCollectionCell else{
				return
			}
			let indexPath = CardCollection.indexPath(for: selectedCell)
			
			let selectedTeam = teams[indexPath!.row]
			
			vc.team = selectedTeam
		}
		
	}

}





