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
				
				returnGroup.enter()
				self.loadAllTeamsPlayersApi(teams: outputTeams) { (teamsRet) in
					outputTeams = teamsRet
					
					self.loadAllTeamsEventsApi(teams: outputTeams) { (teamsRet) in
						outputTeams = teamsRet
						
						returnGroup.leave()
					}
				}
					
				debugPrint("load all from api")
				returnGroup.leave()
			}
		} else {
			loadTeamsCore { (teamsRet) in
				outputTeams = teamsRet
				
				if shouldEventUpdate {
					returnGroup.enter()
					self.loadAllTeamsEventsApi(teams: outputTeams) { (teamsRet) in
						outputTeams = teamsRet
						
						returnGroup.leave()
					}
				}

				if shouldPlayerUpdate {
					returnGroup.enter()
					self.loadAllTeamsPlayersApi(teams: outputTeams) { (teamsRet) in
						outputTeams = teamsRet
						
						returnGroup.leave()
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
		
		DispatchQueue.global().async {
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
	
	private func loadAllTeamsPlayersApi(teams: [Team]?, completionHandler: @escaping ( [Team]? ) -> Void) {
		
		guard var outputTeams = teams else { return }
		let apiGroup = DispatchGroup()
		
		for index in 0..<outputTeams.count {
			apiGroup.enter()
			self.loadPlayersApi(teamName: outputTeams[index].teamName!) { (playersRet) in
				outputTeams[index].teamPlayers = playersRet
				apiGroup.leave()
			}
		}
			
		apiGroup.notify(queue: .main) {
			DefaultsManager.updateTime(key: UpdateTime.player)
			completionHandler(outputTeams)
		}
		
	}
		
	private func loadPlayersApi(teamName: String, completionHandler: @escaping ( [Player]? ) -> Void) {
		
		NetworkClient.getPlayers(teamName: teamName) { (playersRet, _) in
			
			//DefaultsManager.updateTime(key: UpdateTime.player)
			completionHandler(playersRet)

		}
		
	}
	
	// MARK: - EVENTS LOADING
	
	private func loadAllTeamsEventsApi(teams: [Team]?, completionHandler: @escaping ( [Team]? ) -> Void) {
		
		guard var outputTeams = teams else { return }
		
		let apiGroup = DispatchGroup()
		
		for index in 0..<outputTeams.count {
			apiGroup.enter()
			self.loadEventsApi(teamId: outputTeams[index].teamID!) { (eventsRet) in
				outputTeams[index].matchHistory = eventsRet
				apiGroup.leave()
			}
		}
		
		apiGroup.notify(queue: .main) {
			DefaultsManager.updateTime(key: UpdateTime.event)
			completionHandler(outputTeams)
		}
		
	}
	
	private func loadEventsApi(teamId: String, completionHandler: @escaping ( [Event]? ) -> Void) {
		
		NetworkClient.getEvents(teamID: teamId) { (eventsRet, _) in
			
			//DefaultsManager.updateTime(key: UpdateTime.event)
			completionHandler(eventsRet)
			
		}
		
	}
	
}
