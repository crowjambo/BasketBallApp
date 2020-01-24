import Foundation

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

class LoadingManager {
	
	//var teams: [Team]?
	
	// TODO: - remake everything into protocols for loose coupling and easy testing
	
	func loadData(
		shouldTeamUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.team),
		shouldEventUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.event),
		shouldPlayerUpdate: Bool = DefaultsManager.shouldUpdate(idOfEntity: UpdateTime.player),
		completionHandler: @escaping ( [Team]? ) -> Void ) {
		
		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		var outputTeams: [Team]?
		
		if shouldTeamUpdate {
			loadTeamsApi { (teamsRet) in
				outputTeams = teamsRet
				
				for index in 0..<outputTeams!.count {
					returnGroup.enter()
					self.loadPlayersApi(teamName: outputTeams![index].teamName!) { (playersRet) in
						outputTeams![index].teamPlayers = playersRet
						
						returnGroup.leave()
					}
				}
				
				for index in 0..<outputTeams!.count {
					returnGroup.enter()
					self.loadEventsApi(teamId: outputTeams![index].teamID!) { (eventsRet) in
						outputTeams![index].matchHistory = eventsRet
						
						returnGroup.leave()
					}
				}
				
				returnGroup.leave()
				debugPrint("load all from api")
			}
		} else {
			loadTeamsCore { (teamsRet) in
				outputTeams = teamsRet
				
				if shouldEventUpdate {
					for index in 0..<outputTeams!.count {
						returnGroup.enter()
						self.loadPlayersApi(teamName: outputTeams![index].teamName!) { (playersRet) in
							outputTeams![index].teamPlayers = playersRet
							
							DefaultsManager.updateTime(key: UpdateTime.player)
							returnGroup.leave()
						}
					}
				}

				if shouldPlayerUpdate {
					for index in 0..<outputTeams!.count {
						returnGroup.enter()
						self.loadEventsApi(teamId: outputTeams![index].teamID!) { (eventsRet) in
							outputTeams![index].matchHistory = eventsRet
							
							DefaultsManager.updateTime(key: UpdateTime.event)
							returnGroup.leave()
						}
					}
				}
				
				debugPrint("load teams from core")
				returnGroup.leave()
			}
		}
	
		returnGroup.notify(queue: .main) {
			DispatchQueue.global(qos: .background).async {
				self.saveTeamsCore(teamsToSave: outputTeams)
			}
			completionHandler(outputTeams)
		}
		
	}
	
	// MARK: - TEAMS LOADING / SAVING
	
	private func loadTeamsApi(completionHandler: @escaping ( [Team]? ) -> Void) {
		
		NetworkClient.getTeams { (teamsRet, _) in
			
			DefaultsManager.updateTime(key: UpdateTime.team)
			
			completionHandler(teamsRet)
		}
	}
	
	private func loadTeamsCore(completionHandler: @escaping ( [Team]? ) -> Void) {
		
		let result = DataManager.shared.fetch(Teams.self)
		var teamsRet: [Team] = []
		
			for team in result {
				var teamToAdd: Team = Mapper.teamDataToTeamModel(team: team)
				
				guard let loadedPlayers = team.teamPlayers?.array as? [Players] else { return }
				teamToAdd.teamPlayers = Mapper.playersDataToPlayersModelArray(players: loadedPlayers)
				
				guard let loadedEvents = team.teamEvents?.array as? [Events] else { return }
				teamToAdd.matchHistory = Mapper.eventsDataToEventsModelArray(events: loadedEvents)
				
				teamsRet.append(teamToAdd)
				
			}
		completionHandler(teamsRet)
		
		debugPrint("loaded from coreData")
		
	}
	
	private func saveTeamsCore(teamsToSave: [Team]?) {
		
		guard let teamsToSave = teamsToSave else { return }
		DataManager.shared.deleteAllOfType(Teams.self)
		
		for team in teamsToSave {
			_ = Mapper.teamModelToCoreData(team: team)
			DataManager.shared.save()
		}
		
	}
	
	// MARK: - PLAYERS LOADING
		
	private func loadPlayersApi(teamName: String, completionHandler: @escaping ( [Player]? ) -> Void) {
		
		NetworkClient.getPlayers(teamName: teamName) { (playersRet, _) in
			
			DefaultsManager.updateTime(key: UpdateTime.player)
			completionHandler(playersRet)

		}
		
	}
	
	// MARK: - EVENTS LOADING
	
	private func loadEventsApi(teamId: String, completionHandler: @escaping ( [Event]? ) -> Void) {
		
		NetworkClient.getEvents(teamID: teamId) { (eventsRet, _) in
			
			DefaultsManager.updateTime(key: UpdateTime.event)
			completionHandler(eventsRet)
			
		}
		
	}
	
}
