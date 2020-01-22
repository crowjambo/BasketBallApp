import Foundation

// TODO: - implement calling Core data and API depending on Defaults manager
// TODO: - make more modular, its too tightly coupled

class DataLoadingManager{
	
	// Variables
	var teams : [Team]?
	let group = DispatchGroup()
	
	//fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userid == %@ AND objectids LIKE %@ AND active == %@", user.userid, objectid, @YES];
	
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
			
			
			
			self.group.notify(queue: .main) {
				self.saveTeamsCore()
				completionHandler(self.teams)
			}
			
		}
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
				
				let loadedPlayers = DataManager.shared.fetch(Players.self)
				
				
				
				//debugPrint(loadedPlayers)
				
				teamToAdd.teamPlayers = []
				
				for corePlayer in loadedPlayers{
					teamToAdd.teamPlayers?.append(Player(name: corePlayer.name, age: corePlayer.age, height: corePlayer.height, weight: corePlayer.weight, description: corePlayer.playerDescription, position: corePlayer.position, playerIconImage: corePlayer.iconImage, playerMainImage: corePlayer.mainImage))
				}
				
				/////////
				
				
				
				teamToAdd.matchHistory = []
				
//				for coreEvent in loadedEvents{
//					teamToAdd.matchHistory?.append(Event(homeTeamName: coreEvent.homeTeamName, awayTeamName: coreEvent.awayTeamName, date: coreEvent.matchDate))
//				}
				
				
			}
			debugPrint("loaded from coreData")
		
		self.group.leave()

		
	}
	
	private func saveTeamsCore(){
		
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
	
				//debugPrint(player)
				
				//DataManager.shared.deleteAllOfType(Players.self)
		
				var playerToSave = Players(entity: Players.entity(), insertInto: DataManager.shared.context)
				playerToSave.name = player.name
				playerToSave.age = player.age
				playerToSave.height = player.height
				playerToSave.playerDescription = player.description
				playerToSave.iconImage = player.playerIconImage
				playerToSave.mainImage = player.playerMainImage
				playerToSave.position = player.position
				playerToSave.weight = player.weight
				
				
				DataManager.shared.save()
			}
			
			let result = DataManager.shared.fetch(Players.self)
			
			
			for event in team.matchHistory!{
						
				//debugPrint(event)
				
				//DataManager.shared.deleteAllOfType(Events.self)
		
				var eventData = Events(entity: Events.entity(), insertInto: DataManager.shared.context)
				eventData.homeTeamName = event.homeTeamName
				eventData.awayTeamName = event.awayTeamName
				eventData.matchDate = event.date
				
				
				DataManager.shared.save()
			}
			
		
			DataManager.shared.save()
		}
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
