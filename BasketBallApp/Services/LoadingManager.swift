import Foundation

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

class LoadingManager {
	
	//var teams: [Team]?
	let requestsManager: ExternalDataRetrievable
	let dataManager: DataPersistable
	let defaultsManager: LastUpdateTrackable
	
	init(
		requestsManager: ExternalDataRetrievable = HttpRequestsManager(),
		dataManager: DataPersistable = CoreDataManager(),
		defaultsManager: LastUpdateTrackable = DefaultsManager() ) {
		
		self.requestsManager = requestsManager
		self.dataManager = dataManager
		self.defaultsManager = defaultsManager
	}
	
	// TODO: - remake everything into protocols for loose coupling and easy testing
	func loadData( completionHandler: @escaping ( Result<[Team]?, Error>) -> Void ) {
		
		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		var outputTeams: [Team]?
		
		let shouldTeamUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.team)
		let shouldEventUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.event)
		let shouldPlayerUpdate = defaultsManager.shouldUpdate(idOfEntity: UpdateTime.player)
		
		if shouldTeamUpdate {
			
		requestsManager.getTeams(baseApiURL: "https://www.thesportsdb.com/api/v1/json/1/", url: "search_all_teams.php?l=NBA") { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
			case .failure(let err):
				outputTeams = []
				completionHandler(.failure(err))
				debugPrint(err)
			}
				returnGroup.enter()
				
			self.requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
				case .failure(let err):
					debugPrint(err)
				}
				self.defaultsManager.updateTime(key: UpdateTime.player)
				debugPrint("loaded events from API")
				
				self.requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (res) in
					switch res {
					case .success(let teams):
						outputTeams = teams
					case .failure(let err):
						debugPrint(err)
					}
					self.defaultsManager.updateTime(key: UpdateTime.event)
					debugPrint("loaded players from API")
					returnGroup.leave()
					
				}
			}
							
			self.defaultsManager.updateTime(key: UpdateTime.team)
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
					self.requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (res) in
						switch res {
						case .success(let teams):
							outputTeams = teams
						case .failure(let err):
							debugPrint(err)
						}
						self.defaultsManager.updateTime(key: UpdateTime.player)
						debugPrint("loaded events from API")
						returnGroup.leave()
						
					}
				}
				
				if shouldEventUpdate {
					returnGroup.enter()
					self.requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (res) in
						switch res {
						case .success(let teams):
							outputTeams = teams
						case .failure(let err):
							debugPrint(err)
						}
						self.defaultsManager.updateTime(key: UpdateTime.event)
						debugPrint("loaded players from API")
						returnGroup.leave()
					}
				}
				
				returnGroup.leave()
			}
		}
			
		returnGroup.notify(queue: .main) {
			DispatchQueue.global(qos: .background).async {
				self.dataManager.saveTeamsCore(teamsToSave: outputTeams)
			}
			completionHandler(.success(outputTeams))
		}
		
	}

}
