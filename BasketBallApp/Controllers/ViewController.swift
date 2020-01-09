import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	//main collection (could be database or in another file)
	var teams: [TeamInfo] = []
	
	
	@IBOutlet weak var CardCollection: UICollectionView!
	
	
	
	// default controller function
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// move all of this to separate model file later
		
		var someTeam:TeamInfo = TeamInfo(teamName: "Toronto Raptors2", description: "Pretty good team", imageIconName: "pencil.circle.fill", imageTeamMain: "toronto")
		
		someTeam.teamPlayers.append(Player(name: "Evaldas", age: 10, height: 200, weight: 100, description: "Cool guy", position: "center", playerIconImage: "square", playerMainImage: "player1"))
		
		
		someTeam.teamPlayers.append(Player(name: "Jonas", age: 30, height: 50, weight: 200, description: "BALBLALBALBLALBALBLALABLLBALABLABLLABLALBALBLA", position: "dumpster", playerIconImage: "pencil.circle", playerMainImage: "player2"))
		
		
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "Salininku Maxima", date: "Jan 1"))
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "Sasdasd", date: "Jan 2"))
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "cccc", date: "Jan 3"))
		
		teams.append(someTeam)
		teams.append(someTeam)
		teams.append(someTeam)
		
		
		
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



