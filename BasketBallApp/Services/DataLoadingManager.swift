import Foundation

// TODO : would Dispatch group still work, if I pass it as a value into functions? Test it out, if it does, then
// 		  can make it an optional and decouple that dependency at least from my functions, its hard to maintain already

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
			let teamData = Teams(entity: Teams.entity(), insertInto: DataManager.shared.context)
			teamData.teamName = team.teamName
			teamData.teamDescription = team.description
			teamData.teamID = team.teamID
			teamData.teamImage = team.imageTeamMain
			teamData.teamIcon = team.imageIconName
			
			for player in team.teamPlayers! {
		
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
			
			for event in team.matchHistory! {
							
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
