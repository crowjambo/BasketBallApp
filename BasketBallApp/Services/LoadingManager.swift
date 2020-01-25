import Foundation

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

class LoadingManager {
	
	//var teams: [Team]?
	
	// TODO: - remake everything into protocols for loose coupling and easy testing
	// TODO: - change shouldTeamUpdate and others into dependency injected values I control
	// TODO: - use Defaults manager to set shouldTeamUpdate etc, I removed that feature b4
	// TODO: - dependency inject everything, no mercy. Later changing into protocols will be easy
	func loadData(completionHandler: @escaping ( Result<[Team]?, Error>) -> () ) {
		
		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		var outputTeams: [Team]?
		
		// TODO: dependency inject these
		let requestsManager = HttpRequestsManager()
		let dataManager = CoreDataManager()
		let defaultsManager = DefaultsManager()
		
		// TODO: - better than Ifs could use protocols and classes. Each Team/even/player has Load() method through protocol
		// or something else. But depending on what you send through function, is waht they do, and you get injected through
		// these bool checks somehow??
		let shouldTeamUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.team)
		let shouldEventUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.event)
		let shouldPlayerUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.player)
		
		// TODO: - just use Load() method for Players/Events, and that Load() method decides itself whether its API or Core load
		// if its core load, do nothing, because team will automatically core load you due to relationships
		if shouldTeamUpdate {
			requestsManager.getTeams { (res) in
				
				switch res {
				case .success(let teams):
					outputTeams = teams
				case .failure(let err):
					outputTeams = []
					debugPrint(err)
				}
					
				returnGroup.enter()
				
				requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (res) in
					switch res {
					case .success(let teams):
						outputTeams = teams
					case .failure(let err):
						debugPrint(err)
					}
					defaultsManager.updateTime(key: UpdateTime.player)
					debugPrint("loaded events from API")
					
					requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (res) in
						switch res {
						case .success(let teams):
							outputTeams = teams
						case .failure(let err):
							debugPrint(err)
						}
						defaultsManager.updateTime(key: UpdateTime.event)
						debugPrint("loaded players from API")
						returnGroup.leave()
						
					}
				}
							
				defaultsManager.updateTime(key: UpdateTime.team)
				debugPrint("load teams from api")
				returnGroup.leave()
			}
		} else {
			dataManager.loadTeamsCore { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
				case .failure(let err):
					debugPrint(err)
				}
				
				if shouldPlayerUpdate {
					returnGroup.enter()
					requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (res) in
						switch res {
						case .success(let teams):
							outputTeams = teams
						case .failure(let err):
							debugPrint(err)
						}
						defaultsManager.updateTime(key: UpdateTime.player)
						debugPrint("loaded events from API")
						returnGroup.leave()
						
					}
				}
				
				if shouldEventUpdate {
					returnGroup.enter()
					requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (res) in
						switch res {
						case .success(let teams):
							outputTeams = teams
						case .failure(let err):
							debugPrint(err)
						}
						defaultsManager.updateTime(key: UpdateTime.event)
						debugPrint("loaded players from API")
						returnGroup.leave()
					}
				}
				
				returnGroup.leave()
			}
		}
			
		returnGroup.notify(queue: .main) {
			DispatchQueue.global(qos: .background).async {
				dataManager.saveTeamsCore(teamsToSave: outputTeams)
			}
			completionHandler(.success(outputTeams))
		}
		
	}

}
