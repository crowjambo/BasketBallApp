import UIKit

class TeamInfoViewController: UIViewController {

	// MARK: - Variables
	
	var team:Team?
	
	// MARK: - Outlets
	
	// TODO: Clean up and align the Outlets in Storyboard for Teams names displaying
	
	@IBOutlet weak var teamNameLabelOutlet: UILabel!
	@IBOutlet weak var mainTeamImageOutlet: UIImageView!
	@IBOutlet weak var tableOutlet: UITableView!
	@IBOutlet weak var segmentOutlet: UISegmentedControl!
	
	// MARK: - View Lifecycle
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setViewData()
		
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		guard
			let vc = segue.destination as? PlayerDetailViewController,
			let selectedCell = sender as? PlayerCell,
			let indexPath = tableOutlet.indexPath(for: selectedCell),
			let team = team,
			let teamPlayers = team.teamPlayers
		else { return }
			
		let selectedPlayer = teamPlayers[indexPath.row]
		vc.player = selectedPlayer
	}
	
	// MARK: - Functions
	
	func setViewData(){
		if let name = team?.teamName {
			teamNameLabelOutlet.text = name
		}
		
		if let mainImageName = team?.imageTeamMain {
			let url = URL(string: mainImageName)
			mainTeamImageOutlet.load(url: url!)
		}
		//loadPlayersData()
		//loadEventsData()
	}
	
	
	// MARK: - Events loading/saving
//	
//	func loadEventsData(){
//		
//		if (DefaultsManager.shouldUpdate(id: UpdateTime.Event)){
//			loadEventsFromApi()
//		}
//		else{
//			loadEventsFromCore()
//		}
//	}
//	func loadEventsFromCore(){
//		let result = DataManager.shared.fetch(Events.self)
//		team?.matchHistory = []
//		for ev in result{
//			team?.matchHistory?.append(Event(homeTeamName: ev.homeTeamName, awayTeamName: ev.awayTeamName, date: ev.matchDate))
//		}
//		debugPrint("Events loaded from Core Data")
//	}
//	func loadEventsFromApi(){
//		NetworkClient.getEvents(teamID: team!.teamID!, completionHandler: { [weak self] (matches, error) in
//			self?.team?.matchHistory = matches
//			DispatchQueue.main.async{
//				self?.tableOutlet.reloadData()
//				self?.saveEventsData()
//				debugPrint("Events loaded from Fetch")
//			}
//		})
//	}
//	
//	func saveEventsData(){
//		
//		guard let events = team?.matchHistory else { return }
//		DataManager.shared.deleteAllOfType(Events.self)
//
//		for event in events{
//			let eventData = Events(entity: Events.entity(), insertInto: DataManager.shared.context)
//			eventData.homeTeamName = event.homeTeamName
//			eventData.awayTeamName = event.awayTeamName
//			eventData.matchDate = event.date
//				
//			DataManager.shared.save()
//		}
//		DefaultsManager.updateTime(key: UpdateTime.Event.rawValue)
//	}
//	
	// MARK: - Players loading/saving
//	
//	func loadPlayersData(){
//		
//		if(DefaultsManager.shouldUpdate(id: UpdateTime.Player)){
//			loadPlayersFromApi()
//		}
//		else{
//			loadPlayersFromCore()
//		}
//	}
//	
//	func loadPlayersFromCore(){
//		let result = DataManager.shared.fetch(Players.self)
//		self.team?.teamPlayers = []
//		for p in result{
//			self.team?.teamPlayers?.append(Player(name: p.name, age: p.age, height: p.height, weight: p.weight, description: p.playerDescription, position: p.position, playerIconImage: p.iconImage, playerMainImage: p.mainImage))
//		}
//		debugPrint("Loaded from core data")
//	}
//	
//	func loadPlayersFromApi(){
//
//		guard let teamName = team?.teamName else { return }
//		NetworkClient.getPlayers(teamName: teamName, completionHandler: { [weak self] (players, error) in
//			self?.team?.teamPlayers = players
//			DispatchQueue.main.async {
//				self?.tableOutlet.reloadData()
//				self?.savePlayersData()
//				debugPrint("fetched players and saved into core data")
//			}
//		})
//	}
//	
//	func savePlayersData(){
//
//		guard let players = team?.teamPlayers else { return }
//		DataManager.shared.deleteAllOfType(Players.self)
//	
//		for player in players{
//			let playerToSave = Players(entity: Players.entity(), insertInto: DataManager.shared.context)
//			playerToSave.name = player.name
//			playerToSave.age = player.age
//			playerToSave.height = player.height
//			playerToSave.playerDescription = player.description
//			playerToSave.iconImage = player.playerIconImage
//			playerToSave.mainImage = player.playerMainImage
//			playerToSave.position = player.position
//			playerToSave.weight = player.weight
//				
//			DataManager.shared.save()
//		}
//		DefaultsManager.updateTime(key: UpdateTime.Player.rawValue)
//	}

	// MARK: - User interaction

	@IBAction func segmentPress(_ sender: Any) {
		var cellHeight:Float = 0
		switch segmentOutlet.selectedSegmentIndex{
			case 0:
				cellHeight = 100
			case 1:
				cellHeight = 50
			default:
				cellHeight = 100
		}
		tableOutlet.rowHeight = CGFloat(cellHeight)
		tableOutlet.reloadData()
	}

}

// MARK: - TableView setup

extension TeamInfoViewController: UITableViewDelegate, UITableViewDataSource{

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		switch segmentOutlet.selectedSegmentIndex{
			case 0:
				guard let rowsCount = team?.matchHistory?.count else{
					return 0
				}
				return rowsCount
			case 1:
				guard let rowsCount = team?.teamPlayers?.count else{
					return 0
				}
				return rowsCount
			default:
				return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch segmentOutlet.selectedSegmentIndex{
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoCell", for: indexPath) as? EventCell
				cell?.styleItself(dateLabel: team?.matchHistory?[indexPath.row].date, homeTeamName: team?.matchHistory?[indexPath.row].homeTeamName, awayTeamName: team?.matchHistory?[indexPath.row].awayTeamName)
				return cell ?? UITableViewCell()
			
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerInfoCell", for: indexPath) as? PlayerCell
				cell?.styleItself(playerImage: team?.teamPlayers?[indexPath.row].playerIconImage, name: team?.teamPlayers?[indexPath.row].name, position: team?.teamPlayers?[indexPath.row].position)
				return cell ?? UITableViewCell()
			default:
				return UITableViewCell()
		}


	}
}
