import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var teams: [TeamInfo]?
	
	
	@IBOutlet weak var CardCollection: UICollectionView!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadTeamsData()
}

	func loadTeamsData(){
		// get previously loaded date for Teams
		let defaults = UserDefaults.standard
		
		if var teamUpdate = defaults.object(forKey: String(UpdateTime.Team.rawValue)) as? Date{
			teamUpdate += 60 * 60
			
			if(teamUpdate <= Date()){
				NetworkAccess.getTeams_AF(completionHandler: {(teams, error) in
					self.teams = teams
					DispatchQueue.main.async{
						self.updateAfterTeamLoad()
		
						self.saveTeamsIntoCoreData()
						debugPrint("fetched and saved into core data")
					}
				})
			}
			else{
				if let result = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(TeamData.fetchRequest()) as? [TeamData] {
					self.teams = []
					for team in result{
						teams?.append(TeamInfo(teamID: team.teamID, teamName: team.teamName, description: team.teamDescription, imageIconName: team.teamIconImage, imageTeamMain: team.teamMainImage, matchHistory: nil, teamPlayers: nil))
						
					}
					debugPrint("Loaded from Core data")
				}
			}
		}
		else {
				NetworkAccess.getTeams_AF(completionHandler: {(teams, error) in
						self.teams = teams
						DispatchQueue.main.async{
							self.updateAfterTeamLoad()
			
							self.saveTeamsIntoCoreData()
							debugPrint("fetched and saved into core data")
						}
					})
		}
	}
	
	func saveTeamsIntoCoreData(){
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
			guard let teams = teams else { return }
			for team in teams{
				let teamData = TeamData(entity: TeamData.entity(), insertInto: context)
				teamData.teamName = team.teamName
				teamData.teamDescription = team.description
				teamData.teamID = team.teamID
				teamData.teamMainImage = team.imageTeamMain
				teamData.teamIconImage = team.imageIconName
					
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			//mark time changed
			let defaults = UserDefaults.standard
			defaults.set(Date(), forKey: String(UpdateTime.Team.rawValue))
		}
	}
	
	func updateAfterTeamLoad(){

		self.CardCollection.reloadData()

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





