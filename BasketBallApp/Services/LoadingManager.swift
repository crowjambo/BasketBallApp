import Foundation

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

class LoadingManager {
	
	var teams: [Team]?
	
	// TODO: - remake everything into protocols for loose coupling and easy testing
	
	func loadData(
		shouldTeamUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.team),
		shouldEventUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.event),
		shouldPlayerUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.player),
		completionHandler: @escaping ( [Team]? ) -> Void ) {
		
		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		if shouldTeamUpdate {
			loadAllFromApi(returnGroup: returnGroup)
			debugPrint("load all from api")
		} else {
			loadTeamsCore(returnGroup: returnGroup)
			
			if shouldEventUpdate {
				loadEventsApi(returnGroup: returnGroup)
			}

			if shouldPlayerUpdate {
				loadPlayersApi(returnGroup: returnGroup)
			}
			
			debugPrint("load teams from core")
		}
	
		returnGroup.notify(queue: .main) {
			DispatchQueue.global(qos: .background).async {
				self.saveTeamsCore()
			}
			completionHandler(self.teams)
		}
		
	}
	
	// MARK: - TEAMS LOADING / SAVING
	
	private func loadAllFromApi(returnGroup: DispatchGroup, completionHandler: @escaping ( [Team]? ) -> Void) {
		
		let apiGroup = DispatchGroup()
		
		apiGroup.enter()
		NetworkClient.getTeams { (teamsRet, _) in
			self.teams = teamsRet
			DefaultsManager.updateTime(key: UpdateTime.team)
			
			apiGroup.leave()
		}
		
		apiGroup.notify(queue: .global(qos: .background)) {
			
			self.loadPlayersApi(returnGroup: returnGroup)
			
			self.loadEventsApi(returnGroup: returnGroup)
			
			returnGroup.leave()
		}

	}
	
	private func loadTeamsCore(returnGroup: DispatchGroup) {

		let result = DataManager.shared.fetch(Teams.self)

			self.teams = []
			for team in result {
				var teamToAdd: Team = Mapper.teamDataToTeamModel(team: team)
				
				guard let loadedPlayers = team.teamPlayers?.array as? [Players] else { return }
				teamToAdd.teamPlayers = Mapper.playersDataToPlayersModelArray(players: loadedPlayers)
				
				guard let loadedEvents = team.teamEvents?.array as? [Events] else { return }
				teamToAdd.matchHistory = Mapper.eventsDataToEventsModelArray(events: loadedEvents)
				
				self.teams?.append(teamToAdd)
				
			}
		returnGroup.leave()
		debugPrint("loaded from coreData")
		
	}
	
	private func saveTeamsCore() {
		
		guard let teams = teams else { return }
		DataManager.shared.deleteAllOfType(Teams.self)
		
		for team in teams {
			_ = Mapper.teamModelToCoreData(team: team)
			DataManager.shared.save()
		}
		
	}
	
	// MARK: - PLAYERS LOADING
		
	private func loadPlayersApi(returnGroup: DispatchGroup) {
		
		for index in 0..<self.teams!.count {
			
			returnGroup.enter()
			
			NetworkClient.getPlayers(teamName: self.teams![index].teamName!) { (playersRet, _) in
				self.teams![index].teamPlayers = playersRet
				
				DefaultsManager.updateTime(key: UpdateTime.player)
				//debugPrint("Loaded players from API")
				
				returnGroup.leave()
			}
		}
		
	}
	
	// MARK: - EVENTS LOADING
	
	private func loadEventsApi(returnGroup: DispatchGroup) {
		
		for index in 0..<self.teams!.count {
			
			returnGroup.enter()
	
			NetworkClient.getEvents(teamID: self.teams![index].teamID!) { (eventsRet, _) in
				self.teams![index].matchHistory = eventsRet
				
				DefaultsManager.updateTime(key: UpdateTime.event)
				//debugPrint("Loaded Events from API")
				
				returnGroup.leave()
			}
		}
	}
	
}
