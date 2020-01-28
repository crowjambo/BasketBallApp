import Foundation
import RealmSwift

class ModelRealmMapper {
	
}

// MARK: - Model to Realm Mapping

extension ModelRealmMapper {
	
	func modelTeamToRealm(from: Team) -> RealmTeam {
		guard
			let teamPlayers = from.teamPlayers,
			let teamEvents = from.matchHistory
			else { return RealmTeam() }
		
		let realmTeam = RealmTeam()
		realmTeam.teamName = from.teamName
		realmTeam.teamDescription = from.description
		realmTeam.teamID = from.teamID
		realmTeam.imageTeamMain = from.imageTeamMain
		realmTeam.imageIconName = from.imageIconName
		
		for player in teamPlayers {
			let playerToSave = modelPlayerToRealm(from: player)
			realmTeam.teamPlayers.append(playerToSave)
		}
		
		for event in teamEvents {
			let eventToSave = modelEventToRealm(from: event)
			realmTeam.matchHistory.append(eventToSave)
		}
		
		return realmTeam
	}
	
	private func modelPlayerToRealm(from: Player) -> RealmPlayer {
		
		let playerToSave = RealmPlayer()
		playerToSave.name = from.name
		playerToSave.age = from.age
		playerToSave.height = from.height
		playerToSave.playerDescription = from.description
		playerToSave.playerIconImage = from.playerIconImage
		playerToSave.playerMainImage = from.playerMainImage
		playerToSave.position = from.position
		playerToSave.weight = from.weight
		
		return playerToSave
	}
	
	private func modelEventToRealm(from: Event) -> RealmEvent {
		let eventToSave = RealmEvent()
		eventToSave.homeTeamName = from.homeTeamName
		eventToSave.awayTeamName = from.awayTeamName
		eventToSave.date = from.date
		
		return eventToSave
	}
}

// MARK: - Realm to Model Mapping

extension ModelRealmMapper {
	
	func realmToTeamModel(from: RealmTeam) -> Team {
		return Team(teamID: from.teamID, teamName: from.teamName, description: from.teamDescription, imageIconName: from.imageIconName, imageTeamMain: from.imageTeamMain, teamPlayers: realmToPlayersModel(realmPlayers: from.teamPlayers), matchHistory: realmToEventsModel(realmEvents: from.matchHistory))
	}
	
	private func realmToPlayersModel(realmPlayers: List<RealmPlayer>) -> [Player] {
		var outputPlayers: [Player] = []
		for player in realmPlayers {
			outputPlayers.append(realmToPlayerModel(from: player))
		}
		return outputPlayers
	}
	
	private func realmToEventsModel(realmEvents: List<RealmEvent>) -> [Event] {
		var outputEvents: [Event] = []
		for event in realmEvents {
			outputEvents.append(realmToEventModel(from: event))
		}
		return outputEvents
	}
		
	private func realmToPlayerModel(from: RealmPlayer) -> Player {
		return Player(name: from.name, age: from.age, height: from.height, weight: from.weight, description: from.playerDescription, position: from.position, playerIconImage: from.playerIconImage, playerMainImage: from.playerMainImage)
	}
	
	private func realmToEventModel(from: RealmEvent) -> Event {
		return Event(homeTeamName: from.homeTeamName, awayTeamName: from.awayTeamName, date: from.date)
	}
	
}
