import Foundation

// TODO : would Dispatch group still work, if I pass it as a value into functions? Test it out, if it does, then
// 		  can make it an optional and decouple that dependency at least from my functions, its hard to maintain already

// TODO : make dataloading manager use a protocol Database or so, one for core one for realm, so you can exchange what you prefer

class DataLoadingManager {
	
	// Variables
	var teams: [Team]?
	let group = DispatchGroup()
	
	let shouldEventUpdate: Bool = DefaultsManager.shouldUpdate(id: UpdateTime.event)
	let shouldPlayerUpdate: Bool = DefaultsManager.shouldUpdate(id: UpdateTime.player)
	let shouldTeamUpdate: Bool = DefaultsManager.shouldUpdate(id: UpdateTime.team)

	func loadData(completionHandler: @escaping ( [Team]? ) -> Void ) {
		
		if shouldTeamUpdate {
			loadTeamsApi()
			loadPlayersApi()
			loadEventsApi()
			debugPrint("load all from api")
		} else {
			loadTeamsCore()
			debugPrint("load teams from core")
		}
	
		group.notify(queue: .main) {
			
			self.group.notify(queue: .global(qos: .background)) {
				self.saveTeamsCore()
			}
			
			self.group.notify(queue: .main) {
				
				completionHandler(self.teams)
			}
		}
		
	}
	
	// MARK: - TEAMS LOADING / SAVING
	
	private func loadTeamsApi() {
		
		self.group.enter()
		NetworkClient.getTeams { (teamsRet, _) in
			self.teams = teamsRet
			
			DefaultsManager.updateTime(key: UpdateTime.team)
			self.group.leave()
		}

	}
	
	private func loadTeamsCore() {

		self.group.enter()
		
		let result = DataManager.shared.fetch(Teams.self)

			self.teams = []
			for team in result {
				var teamToAdd: Team = Mapper.teamDataToTeamModel(team: team)
				
				guard let loadedPlayers = team.teamPlayers?.array as? [Players] else { return }
				teamToAdd.teamPlayers = Mapper.playersDataToPlayersModelArray(players: loadedPlayers)
				
				guard let loadedEvents = team.teamEvents?.array as? [Events] else { return }
				teamToAdd.matchHistory = Mapper.eventsDataToEventsModelArray(events: loadedEvents)
				
				self.teams?.append(teamToAdd)
				
				if shouldEventUpdate {
					loadEventsApi()
				}

				if shouldPlayerUpdate {
					loadPlayersApi()
				}
				
			}
			debugPrint("loaded from coreData")
		
		self.group.leave()
		
	}
	
	private func saveTeamsCore() {
		
		group.enter()
	
		guard let teams = teams else { return }
		DataManager.shared.deleteAllOfType(Teams.self)
		
		for team in teams {
			let teamData = Mapper.teamModelToCoreData(team: team)
			debugPrint(teamData.teamName!)
			DataManager.shared.save()
		}
		
		group.leave()
	}
	
	// MARK: - PLAYERS LOADING
		
	private func loadPlayersApi() {
		
		for index in 0..<self.teams!.count {
			self.group.enter()
			NetworkClient.getPlayers(teamName: self.teams![index].teamName!) { (playersRet, _) in
				self.teams![index].teamPlayers = playersRet
				
				DefaultsManager.updateTime(key: UpdateTime.player)
				self.group.leave()
			}
		}

	}
	
	// MARK: - EVENTS LOADING
	
	private func loadEventsApi() {
		
		for index in 0..<self.teams!.count {
			self.group.enter()
			NetworkClient.getEvents(teamID: self.teams![index].teamID!) { (eventsRet, _) in
				self.teams![index].matchHistory = eventsRet
				
				DefaultsManager.updateTime(key: UpdateTime.event)
				self.group.leave()
			}
		}
	}
	
}
