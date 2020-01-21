import UIKit

class MainViewController: UIViewController {
	
	// MARK: - Variables
	
	var teams: [Team]?
	
	// MARK: - Outlets
	
	@IBOutlet weak var CardCollection: UICollectionView!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//loadTeamsData()
		_test_LoadTeamsApi()
		
		dispatchGroup.notify(queue: .main) {
			//self._test_LoadEventsApi()
			self._test_LoadPlayersApi()
		}
		
		//_test_LoadPlayersApi()
		//_test_LoadEventsApi()
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard
			let vc = segue.destination as? TeamInfoViewController,
			let selectedCell = sender as? TeamCollectionCell,
			let indexPath = CardCollection.indexPath(for: selectedCell),
			let teams = teams
			else { return }
		
		let selectedTeam = teams[indexPath.row]
		vc.team = selectedTeam
	}
	
	
	// MARK: - LOAD EVERYTHING
	
	let dispatchGroup = DispatchGroup()
	
	func _test_LoadTeamsApi(){
		
		dispatchGroup.enter()
		//dispatchGroup.enter()

		NetworkClient.getTeams( completionHandler: { [weak self] (teams, error) in
			self?.teams = teams
				
			DispatchQueue.main.async{
				self?.CardCollection.reloadData()
				//self?.saveTeamsIntoCoreData()
				debugPrint("fetched and saved into core data")


			}
			self?.dispatchGroup.leave()
		})
		

	}
	
	func _test_LoadPlayersApi(){
		
		var counter = 0
		
		for team in self.teams!{
			
			
			
			_test_loadPlayerApi_single(team: team, counter: counter)
			
			
			
			counter += 1
			
		}
	
	}
	
	func _test_loadPlayerApi_single(team : Team, counter : Int){
		
		//dispatchGroup.enter()
		
		// Problem is these async calls, doing racing conditions etc
		NetworkClient.getPlayers(teamName: team.teamName!, completionHandler: { [weak self] (players, error) in
			self?.teams![counter].teamPlayers = players

			
			debugPrint("players loaded")
			
			//self?.dispatchGroup.leave()

		})
	}
	
	
	func _test_LoadEventsApi(){
		dispatchGroup.wait()

		var counter = 0
		for team in self.teams!{
			NetworkClient.getEvents(teamID: team.teamID!, completionHandler: { [weak self] (matches, error) in
				self?.teams![counter].matchHistory = matches

				counter += 1
				debugPrint("events loaded")

			})
		}
		
	}
	
	
	// MARK: - Teams loading/saving
	
	func loadTeamsData(){

		if(DefaultsManager.shouldUpdate(id: UpdateTime.Team)){
			loadFromApi()
		}
		else{
			let result = DataManager.shared.fetch(Teams.self)
			self.teams = []
			for t in result{
				self.teams?.append(Team(teamID: t.teamID, teamName: t.teamName, description: t.teamDescription, imageIconName: t.teamIcon, imageTeamMain: t.teamImage))
			}
			debugPrint("loaded from coreData")
		}
	}

	func loadFromApi(){
		NetworkClient.getTeams( completionHandler: { [weak self] (teams, error) in
			self?.teams = teams
			DispatchQueue.main.async{
				self?.CardCollection.reloadData()
				self?.saveTeamsIntoCoreData()
				debugPrint("fetched and saved into core data")
			}
		})
	}
		
	func saveTeamsIntoCoreData(){
		
		guard let teams = teams else { return }
		DataManager.shared.deleteAllOfType(Teams.self)
		for team in teams{
			let teamData = Teams(entity: Teams.entity(), insertInto: DataManager.shared.context)
			teamData.teamName = team.teamName
			teamData.teamDescription = team.description
			teamData.teamID = team.teamID
			teamData.teamImage = team.imageTeamMain
			teamData.teamIcon = team.imageIconName
			DataManager.shared.save()
		}
		DefaultsManager.updateTime(key: UpdateTime.Team.rawValue)
	}
	
}

// MARK: - CollectionView setup

extension MainViewController : UICollectionViewDataSource, UICollectionViewDelegate{
	
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
}





