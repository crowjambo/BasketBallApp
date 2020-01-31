import Foundation

enum TeamsLoadingError: Error {
	case noTeamsLoaded
}

protocol TeamsDataLoadable {
	func loadData( completionHandler: @escaping ( Result<[Team]?, Error>) -> Void )
	
	var requestsManager: ExternalDataRetrievable { get set }
	var dataManager: DataPersistable { get set }
	var defaultsManager: LastUpdateTrackable { get set }
	
}

class LoadingManager: TeamsDataLoadable {
	
	var requestsManager: ExternalDataRetrievable
	var dataManager: DataPersistable
	var defaultsManager: LastUpdateTrackable
	
	init(
		requestsManager: ExternalDataRetrievable,
		dataManager: DataPersistable,
		defaultsManager: LastUpdateTrackable) {
		
		self.requestsManager = requestsManager
		self.dataManager = dataManager
		self.defaultsManager = defaultsManager
	}
	
	func loadData( completionHandler: @escaping ( Result<[Team]?, Error>) -> Void ) {
		
		var outputTeams: [Team]?

		let returnGroup = DispatchGroup()
		returnGroup.enter()
		
		teamsUpdate(shouldTeamUpdate: defaultsManager.shouldUpdate(idOfEntity: UpdateTime.team), returnGroup: returnGroup) { (res) in
			switch res {
			case .success(let teams):
				outputTeams = teams
			case .failure(_):
				break
			}
			
			self.playerUpdate(sentInTeams: outputTeams, shouldPlayerUpdate: self.defaultsManager.shouldUpdate(idOfEntity: UpdateTime.player), returnGroup: returnGroup) { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
				case .failure(_):
					break
				}
				
				self.eventUpdate(sentInTeams: outputTeams, shouldEventUpdate: self.defaultsManager.shouldUpdate(idOfEntity: UpdateTime.event), returnGroup: returnGroup) { (res) in
					switch res {
					case .success(let teams):
						outputTeams = teams
					case .failure(let err):
						debugPrint(err)
					}
				}
			}
			returnGroup.leave()
		}
		
		returnGroup.notify(queue: .main) {
			if outputTeams!.isEmpty {
				completionHandler(.failure(TeamsLoadingError.noTeamsLoaded))
			} else {
				completionHandler(.success(outputTeams))
				self.dataManager.saveTeams(teamsToSave: outputTeams)
			}
		}
		
	}
	
	private func teamsUpdate(shouldTeamUpdate: Bool, returnGroup: DispatchGroup, completion: @escaping (Result<[Team]?, Error>) -> Void ) {
		var outputTeams: [Team]?
		
		if shouldTeamUpdate {
			requestsManager.getTeams { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
					completion(.success(outputTeams))
				case .failure(let err):
					completion(.failure(err))
				}
				self.defaultsManager.updateTime(key: UpdateTime.team)
			}
		} else {
			dataManager.loadTeams { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
					completion(.success(outputTeams))
				case .failure(let err):
					completion(.failure(err))
				}
			}
		}
	}
	
	private func playerUpdate(sentInTeams: [Team]?, shouldPlayerUpdate: Bool, returnGroup: DispatchGroup, completion: @escaping (Result<[Team]?, Error>) -> Void ) {
		
		if shouldPlayerUpdate {
			var outputTeams = sentInTeams
			
			returnGroup.enter()
			self.requestsManager.getAllTeamsPlayersApi(teams: outputTeams) { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
					completion(.success(outputTeams))
				case .failure(let err):
					completion(.failure(err))
				}
				self.defaultsManager.updateTime(key: UpdateTime.player)
				returnGroup.leave()
			}
		} else {
			return
		}
	}
	
	private func eventUpdate(sentInTeams: [Team]?, shouldEventUpdate: Bool, returnGroup: DispatchGroup, completion: @escaping (Result<[Team]?, Error>) -> Void) {
		if shouldEventUpdate {
			var outputTeams = sentInTeams
			
			returnGroup.enter()
			self.requestsManager.getAllTeamsEventsApi(teams: outputTeams) { (res) in
				switch res {
				case .success(let teams):
					outputTeams = teams
					completion(.success(outputTeams))
				case .failure(let err):
					completion(.failure(err))
				}
				self.defaultsManager.updateTime(key: UpdateTime.event)
				
				returnGroup.leave()
			}
		} else {
			return
		}
	}

}
