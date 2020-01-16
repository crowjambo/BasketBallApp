import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var teams: [TeamInfo]?
	
	
	@IBOutlet weak var CardCollection: UICollectionView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NetworkAccess.getTeams_AF(completionHandler: {(teams, error) in
			self.teams = teams
			DispatchQueue.main.async{
				self.CardCollection.reloadData()
			}
		})

	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard let teams = teams else { return 0 }
		return teams.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCollectionCell", for: indexPath) as? TeamCollectionCell {
			if let teams = teams{
				let team = teams[indexPath.row]
				cell.styleItself(teamName: team.teamName, teamDescription: team.description, teamIcon: team.imageIconName)
			}
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
			
			if let teams = teams{
				if let indexPath = indexPath{
					let selectedTeam = teams[indexPath.row]
					vc.team = selectedTeam
				}
			}
		}
	}

}





