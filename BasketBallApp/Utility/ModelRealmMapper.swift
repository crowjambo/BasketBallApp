import Foundation
import RealmSwift

class ModelRealmMapper {
	
}

// MARK: - Model to Realm Mapping

extension ModelRealmMapper {
	
	func modelTeamToRealm(modelTeam: Team) -> RealmTeam {
		guard
			let teamPlayers = modelTeam.teamPlayers,
			let teamEvents = modelTeam.matchHistory
			else { return RealmTeam() }
		
		let realmTeam = RealmTeam()
		realmTeam.teamName = modelTeam.teamName
		realmTeam.teamDescription = modelTeam.description
		realmTeam.teamID = modelTeam.teamID
		realmTeam.imageTeamMain = modelTeam.imageTeamMain
		realmTeam.imageIconName = modelTeam.imageIconName
		
		for player in teamPlayers {
			let playerToSave = modelPlayerToRealm(modelPlayer: player)
			realmTeam.teamPlayers.append(playerToSave)
		}
		
		for event in teamEvents {
			let eventToSave = modelEventToRealm(modelEvent: event)
			realmTeam.matchHistory.append(eventToSave)
		}
		
		return realmTeam
	}
	
	private func modelPlayerToRealm(modelPlayer: Player) -> RealmPlayer {
		
		let playerToSave = RealmPlayer()
		playerToSave.name = modelPlayer.name
		playerToSave.age = modelPlayer.age
		playerToSave.height = modelPlayer.height
		playerToSave.playerDescription = modelPlayer.description
		playerToSave.playerIconImage = modelPlayer.playerIconImage
		playerToSave.playerMainImage = modelPlayer.playerMainImage
		playerToSave.position = modelPlayer.position
		playerToSave.weight = modelPlayer.weight
		
		return playerToSave
	}
	
	private func modelEventToRealm(modelEvent: Event) -> RealmEvent {
		let eventToSave = RealmEvent()
		eventToSave.homeTeamName = modelEvent.homeTeamName
		eventToSave.awayTeamName = modelEvent.awayTeamName
		eventToSave.date = modelEvent.date
		
		return eventToSave
	}
}

// MARK: - Realm to Model Mapping

extension ModelRealmMapper {
	
	func realmToTeamModel(realmTeam: RealmTeam) -> Team {
		return Team(teamID: realmTeam.teamID, teamName: realmTeam.teamName, description: realmTeam.teamDescription, imageIconName: realmTeam.imageIconName, imageTeamMain: realmTeam.imageTeamMain, teamPlayers: realmToPlayersModel(realmPlayers: realmTeam.teamPlayers), matchHistory: realmToEventsModel(realmEvents: realmTeam.matchHistory))
	}
	
	private func realmToPlayersModel(realmPlayers: List<RealmPlayer>) -> [Player] {
		var outputPlayers: [Player] = []
		for player in realmPlayers {
			outputPlayers.append(realmToPlayerModel(realmPlayer: player))
		}
		return outputPlayers
	}
	
	private func realmToEventsModel(realmEvents: List<RealmEvent>) -> [Event] {
		var outputEvents: [Event] = []
		for event in realmEvents {
			outputEvents.append(realmToEventModel(realmEvent: event))
		}
		return outputEvents
	}
		
	private func realmToPlayerModel(realmPlayer: RealmPlayer) -> Player {
		return Player(name: realmPlayer.name, age: realmPlayer.age, height: realmPlayer.height, weight: realmPlayer.weight, description: realmPlayer.playerDescription, position: realmPlayer.position, playerIconImage: realmPlayer.playerIconImage, playerMainImage: realmPlayer.playerMainImage)
	}
	
	private func realmToEventModel(realmEvent: RealmEvent) -> Event {
		return Event(homeTeamName: realmEvent.homeTeamName, awayTeamName: realmEvent.awayTeamName, date: realmEvent.date)
	}
	
}
