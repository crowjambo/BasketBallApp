import Foundation

// TODO: - implement calling Core data and API depending on Defaults manager
// TODO: - make more modular, its too tightly coupled

class DataLoadingManager{
	
	// Variables
	var teams : [Team]?
	let group = DispatchGroup()

	func loadData(completionHandler: @escaping ( [Team]? ) -> Void ){
		
//		if DefaultsManager.shouldUpdate(id: UpdateTime.Team){
//			loadTeamsApi()
//			debugPrint("load from api")
//		}
//		else{
//			loadTeamsCore()
//			debugPrint("load from core")
//		}
		loadTeamsApi()
//		loadTeamsCore()
		group.notify(queue: .main) {
			
//
			self.loadPlayersApi()
			self.loadEventsApi()
		
		
//			self.loadTeamsCore()
			
			//background thread for saving, so UI isnt freezed up
			self.group.notify(queue: .global(qos: .background)) {
				self.saveTeamsCore()
			}
			
			self.group.notify(queue: .main) {
				
				completionHandler(self.teams)
			}
			
			
			
		}
	}
	
	func apiHelper(){
		
	}
	
	
	// MARK: - TEAMS LOADING / SAVING
	
	private func loadTeamsApi(){
		
		self.group.enter()
		NetworkClient.getTeams { (teamsRet, error) in
			self.teams = teamsRet
			
			DefaultsManager.updateTime(key: UpdateTime.Team)
			self.group.leave()
		}
	}
	
	private func loadTeamsCore(){

		self.group.enter()
		
		let result = DataManager.shared.fetch(Teams.self)
			self.teams = []
			for t in result{
				//print("\(t.teamName) \(t.teamID)")
				//debugPrint(t)
				var teamToAdd = Team(teamID: t.teamID, teamName: t.teamName, description: t.teamDescription, imageIconName: t.teamIcon, imageTeamMain: t.teamImage)
				
				///////////
				

				let loadedPlayers = t.teamPlayers?.array as! [Players]
					
				teamToAdd.teamPlayers = []
				
			
				for corePlayer in loadedPlayers.enumerated(){
					
					teamToAdd.teamPlayers?.append(Player(name: corePlayer.element.name, age: corePlayer.element.age, height: corePlayer.element.height, weight: corePlayer.element.weight, description: corePlayer.element.playerDescription, position: corePlayer.element.position, playerIconImage: corePlayer.element.iconImage, playerMainImage: corePlayer.element.mainImage))
				}
				
				
				/////////
				
				let loadedEvents = t.teamEvents?.array as! [Events]
				
				teamToAdd.matchHistory = []
				
				for coreEvent in loadedEvents{
					teamToAdd.matchHistory?.append(Event(homeTeamName: coreEvent.homeTeamName, awayTeamName: coreEvent.awayTeamName, date: coreEvent.matchDate))
				}
				
				
				self.teams?.append(teamToAdd)
				
			}
			debugPrint("loaded from coreData")
		
		self.group.leave()

		
	}
	
	private func saveTeamsCore(){
		
		group.enter()
		
		guard let teams = teams else { return }
		DataManager.shared.deleteAllOfType(Teams.self)
		for team in teams{
			let teamData = Teams(entity: Teams.entity(), insertInto: DataManager.shared.context)
			teamData.teamName = team.teamName
			teamData.teamDescription = team.description
			teamData.teamID = team.teamID
			teamData.teamImage = team.imageTeamMain
			teamData.teamIcon = team.imageIconName
			
			//debugPrint(team)
			
			for player in team.teamPlayers!{
		
				var playerToSave = Players(entity: Players.entity(), insertInto: DataManager.shared.context)
				playerToSave.name = player.name
				playerToSave.age = player.age
				playerToSave.height = player.height
				playerToSave.playerDescription = player.description
				playerToSave.iconImage = player.playerIconImage
				playerToSave.mainImage = player.playerMainImage
				playerToSave.position = player.position
				playerToSave.weight = player.weight
				playerToSave.team = teamData
				
				teamData.addToTeamPlayers(playerToSave)
				
				DataManager.shared.save()
			}
			
			let result = DataManager.shared.fetch(Players.self)
			
			
			for event in team.matchHistory!{
							
				var eventData = Events(entity: Events.entity(), insertInto: DataManager.shared.context)
				eventData.homeTeamName = event.homeTeamName
				eventData.awayTeamName = event.awayTeamName
				eventData.matchDate = event.date
				eventData.team = teamData
				
				teamData.addToTeamEvents(eventData)
				
				DataManager.shared.save()
			}
			
		
			DataManager.shared.save()
		}
		group.leave()
	}
	
	// MARK: - PLAYERS LOADING / SAVING
		
	private func loadPlayersApi(){
		
		for index in 0..<self.teams!.count{
			self.group.enter()
			NetworkClient.getPlayers(teamName: self.teams![index].teamName!) { (playersRet, error) in
				self.teams![index].teamPlayers = playersRet
				
				DefaultsManager.updateTime(key: UpdateTime.Player)
				self.group.leave()
			}
		}

	}
	
	private func loadPlayersCore(){
		
	}
	
	private func savePlayersCore(){
		
	}
	
	// MARK: - EVENTS LOADING / SAVING
	
	private func loadEventsApi(){
		
		for index in 0..<self.teams!.count{
			self.group.enter()
			NetworkClient.getEvents(teamID: self.teams![index].teamID!) { (eventsRet, error) in
				self.teams![index].matchHistory = eventsRet
				
				DefaultsManager.updateTime(key: UpdateTime.Event)
				self.group.leave()
			}
		}
	}
	
	private func loadEventsCore(){
		
	}
	
	private func saveEventsCore(){
		
	}
	
	
	
}
