import UIKit

class TeamInfoViewController: UIViewController {

	//grab TeamInfo from main controller
	var team:TeamInfo?
	
	
	@IBOutlet weak var teamNameLabelOutlet: UILabel!
	@IBOutlet weak var mainTeamImageOutlet: UIImageView!
	@IBOutlet weak var tableOutlet: UITableView!
	@IBOutlet weak var segmentOutlet: UISegmentedControl!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setViewData()
		
    }
	
	func setViewData(){
		if let name = team?.teamName {
			teamNameLabelOutlet.text = name
		}
		
		if let mainImageName = team?.imageTeamMain {
			let url = URL(string: mainImageName)
			mainTeamImageOutlet.load(url: url!)
			
		}
		
		loadPlayersData()
		loadEventsData()
		

	

	}
	
	func savePlayersData(){
		// TODO: refresh/update items, instead of appending on top in data
		
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
			guard let players = team?.teamPlayers else { return }
			for player in players{
				let playerData = PlayerData(entity: PlayerData.entity(), insertInto: context)
				playerData.name = player.name
				playerData.age = player.age
				playerData.height = player.height
				playerData.playerDescription = player.description
				playerData.playerIconImage = player.playerIconImage
				playerData.playerMainImage = player.playerMainImage
				playerData.position = player.position
					
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			//mark time changed
			let defaults = UserDefaults.standard
			defaults.set(Date(), forKey: String(UpdateTime.Player.rawValue))
		}
	}
	
	func saveEventsData(){
		// TODO: refresh/update items, instead of appending on top in data
		
		if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
			guard let events = team?.matchHistory else { return }
			for event in events{
				let eventData = EventData(entity: EventData.entity(), insertInto: context)
				eventData.team1Name = event.team1Name
				eventData.team2Name = event.team2Name
				eventData.matchDate = event.date
					
				(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
			}
			//mark time changed
			let defaults = UserDefaults.standard
			defaults.set(Date(), forKey: String(UpdateTime.Event.rawValue))
		}
	}
	
	func loadEventsData(){
		let defaults = UserDefaults.standard
		if var eventUpdate = defaults.object(forKey: String(UpdateTime.Event.rawValue)) as? Date{
			eventUpdate += 60 * 15
			
			// fetch
			if (eventUpdate <= Date()){
				NetworkAccess.getMatches_AF(teamID: team!.teamID!, completionHandler: {(matches, error) in
					self.team?.matchHistory = matches
					DispatchQueue.main.async{
						self.tableOutlet.reloadData()
						self.saveEventsData()
						debugPrint("Events loaded from Fetch")
					}
				})
				
			}
			// load from core data
			else{
				if let result = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(EventData.fetchRequest()) as? [EventData]{
					team?.matchHistory = []
					for match in result{
						team?.matchHistory?.append(MatchHistory(team1Name: match.team1Name, team2Name: match.team2Name, date: match.matchDate))
					}
				}
				debugPrint("Events loaded from Core Data")
			}
		}
		// loading for first time
		else{
			NetworkAccess.getMatches_AF(teamID: team!.teamID!, completionHandler: {(matches, error) in
				self.team?.matchHistory = matches
				DispatchQueue.main.async{
					self.tableOutlet.reloadData()
					self.saveEventsData()
					debugPrint("Events loaded from Fetch (first time) +saved into data")
				}
			})
		}
		

	}
	
	func loadPlayersData(){
		
		let defaults = UserDefaults.standard
		
		if var playerUpdate = defaults.object(forKey: String(UpdateTime.Player.rawValue)) as? Date{
			playerUpdate += 60 * 60
			
			if(playerUpdate <= Date()){
				NetworkAccess.getPlayers_AF(teamName: team!.teamName!, completionHandler: { (players, error) in
					self.team?.teamPlayers = players
					DispatchQueue.main.async {
						self.tableOutlet.reloadData()
						
						self.savePlayersData()
						debugPrint("fetched players and saved into core data")
					}
				})
			}
			// not old yet, use core data
			else{
				if let result = try? (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext.fetch(PlayerData.fetchRequest()) as? [PlayerData] {
					self.team?.teamPlayers = []
					for player in result{
						self.team?.teamPlayers?.append(Player(name: player.name, age: player.age, height: player.height, weight: player.weight, description: player.playerDescription, position: player.position, playerIconImage: player.playerIconImage, playerMainImage: player.playerMainImage))
					}
					debugPrint("Loaded from core data")
				}
			}
		}
		// TODO: Remove this redundancy
		// first time loading, no date
		else{
			NetworkAccess.getPlayers_AF(teamName: team!.teamName!, completionHandler: { (players, error) in
				self.team?.teamPlayers = players
				DispatchQueue.main.async {
					self.tableOutlet.reloadData()
					
					self.savePlayersData()
					debugPrint("first time fetch player and save into DB")
				}
			})
		}
		

		
		
	}
    
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? PlayerDetailViewController{

			guard let selectedCell = sender as? PlayerInfoCell else{
				return
			}
			let indexPath = tableOutlet.indexPath(for: selectedCell)
			
			if let team = team{
				if let teamPlayers = team.teamPlayers{
					if let indexPath = indexPath{
						let selectedPlayer = teamPlayers[indexPath.row]
						vc.player = selectedPlayer
					}
				}
			}
		}
	}
	

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

extension TeamInfoViewController: UITableViewDelegate, UITableViewDataSource{

	//return count
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

	//creation
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch segmentOutlet.selectedSegmentIndex{
			case 0:
				let cell = tableView.dequeueReusableCell(withIdentifier: "MatchInfoCell", for: indexPath) as! MatchInfoCell
				cell.styleItself(dateLabel: team?.matchHistory![indexPath.row].date, team1Name: team?.matchHistory![indexPath.row].team1Name, team2Name: team?.matchHistory![indexPath.row].team2Name)
				return cell
			
			case 1:
				let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerInfoCell", for: indexPath) as! PlayerInfoCell
				cell.styleItself(playerImage: team?.teamPlayers![indexPath.row].playerIconImage, name: team?.teamPlayers![indexPath.row].name, position: team?.teamPlayers![indexPath.row].position)
				return cell
			default:
				return UITableViewCell()
		}


	}
}
