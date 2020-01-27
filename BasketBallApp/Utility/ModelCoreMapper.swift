import Foundation

protocol ModelCoreMappable: ModelToCoreChangable, CoreToModelChangable {}

protocol ModelToCoreChangable {
	func teamModelToCoreData(team: Team, dataManager: CoreDataManager) -> Teams
}

protocol CoreToModelChangable {
	func teamDataToTeamModel(team: Teams) -> Team
	func eventsDataToEventsModelArray(events: [Events]) -> [Event]
	func playersDataToPlayersModelArray(players: [Players]) -> [Player]
}

class ModelCoreMapper: ModelCoreMappable {

}

// MARK: - Core Data into Models Mapping

extension ModelCoreMapper {
	
	func teamDataToTeamModel(team: Teams) -> Team {
		return Team(teamID: team.teamID, teamName: team.teamName, description: team.teamDescription, imageIconName: team.teamIcon, imageTeamMain: team.teamImage)
	}
	
	func eventsDataToEventsModelArray(events: [Events]) -> [Event] {
		var outputEvents: [Event] = []
		
		for event in events {
			outputEvents.append(eventDataToEventModel(event: event))
		}
		
		return outputEvents
	}
	
	private func eventDataToEventModel(event: Events) -> Event {
		return Event(homeTeamName: event.homeTeamName, awayTeamName: event.awayTeamName, date: event.matchDate)
	}
	
	func playersDataToPlayersModelArray(players: [Players]) -> [Player] {
		var outputPlayers: [Player] = []
		
		for player in players {
			outputPlayers.append(playerDataToPlayerModel(player: player))
		}
		
		return outputPlayers
	}
	
	private func playerDataToPlayerModel(player: Players) -> Player {
		return Player(name: player.name, age: player.age, height: player.height, weight: player.weight, description: player.playerDescription, position: player.position, playerIconImage: player.iconImage, playerMainImage: player.mainImage)
	}
}

// MARK: - Models into Core Data

extension ModelCoreMapper {
	
	func teamModelToCoreData(team: Team, dataManager: CoreDataManager) -> Teams {
		guard
			let teamPlayers = team.teamPlayers,
			let teamEvents = team.matchHistory
			else { return Teams() }
		
		let teamData = Teams(entity: Teams.entity(), insertInto: dataManager.context)
		teamData.teamName = team.teamName
		teamData.teamDescription = team.description
		teamData.teamID = team.teamID
		teamData.teamImage = team.imageTeamMain
		teamData.teamIcon = team.imageIconName
		
		for player in teamPlayers {
			let playerToSave = playerModelToCoreData(player: player, dataManager: dataManager)
			playerToSave.team = teamData
			teamData.addToTeamPlayers(playerToSave)
		}

		for event in teamEvents {
			let eventToSave = eventModelToCoreData(event: event, dataManager: dataManager)
			eventToSave.team = teamData
			teamData.addToTeamEvents(eventToSave)
		}
		
		return teamData
	}
	
	private func playerModelToCoreData(player: Player, dataManager: CoreDataManager) -> Players {
		let playerToSave = Players(entity: Players.entity(), insertInto: dataManager.context)
		playerToSave.name = player.name
		playerToSave.age = player.age
		playerToSave.height = player.height
		playerToSave.playerDescription = player.description
		playerToSave.iconImage = player.playerIconImage
		playerToSave.mainImage = player.playerMainImage
		playerToSave.position = player.position
		playerToSave.weight = player.weight
		
		return playerToSave
	}
	
	private func eventModelToCoreData(event: Event, dataManager: CoreDataManager) -> Events {
		let eventToSave = Events(entity: Events.entity(), insertInto: dataManager.context)
		eventToSave.homeTeamName = event.homeTeamName
		eventToSave.awayTeamName = event.awayTeamName
		eventToSave.matchDate = event.date
		
		return eventToSave
	}
}
