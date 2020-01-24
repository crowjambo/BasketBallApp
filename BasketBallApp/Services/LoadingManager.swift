import Foundation

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

//protocol

class LoadingManager {
	
	//var teams: [Team]?
	
	// TODO: - remake everything into protocols for loose coupling and easy testing
	
	func loadData(
		shouldTeamUpdate: Bool = true,
		shouldEventUpdate: Bool = true,
		shouldPlayerUpdate: Bool = true,
		completionHandler: @escaping ( [Team]? ) -> Void ) {
		
		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		var outputTeams: [Team]?
		
		let requestsManager = HttpRequestsManager()
		let dataManager = DataManager()
		let defaultsManager = DefaultsManager()
		
		if shouldTeamUpdate {
			requestsManager.getTeams { (teamsRet, _) in
				outputTeams = teamsRet
				
				returnGroup.enter()
				requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (teamsRet, _) in
					outputTeams = teamsRet
					defaultsManager.updateTime(key: UpdateTime.player)
					
					requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (teamsRet, _) in
						outputTeams = teamsRet
						defaultsManager.updateTime(key: UpdateTime.event)
						returnGroup.leave()
					}
				}
			
				defaultsManager.updateTime(key: UpdateTime.team)
				debugPrint("load all from api")
				returnGroup.leave()
			}
		} else {
			dataManager.loadTeamsCore { (teamsRet) in
				outputTeams = teamsRet
				
				if shouldPlayerUpdate {
					returnGroup.enter()
					requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (teamsRet, _) in
						outputTeams = teamsRet
						defaultsManager.updateTime(key: UpdateTime.player)
						debugPrint("lodade events from API")
						returnGroup.leave()
					}
				}
				
				if shouldEventUpdate {
					returnGroup.enter()
					requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (teamsRet, _) in
						outputTeams = teamsRet
						defaultsManager.updateTime(key: UpdateTime.event)
						debugPrint("loaded players from API")
						returnGroup.leave()
					}
				}
			}
		}
	
		returnGroup.notify(queue: .main) {
			DispatchQueue.global(qos: .background).async {
				dataManager.saveTeamsCore(teamsToSave: outputTeams)
			}
			completionHandler(outputTeams)
		}
		
	}

}
