import Foundation

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
	
	func realmToTeamModel(realmModel: RealmTeam) -> Team {
		
		return Team()
	}
	
	private func realmToPlayersModel() {
		// if have to (isnt automatic like coredata), will have to make this public, and send in fetched data
		
	}
	
	private func realmToEventsModel() {
		
	}
		
	private func realmToPlayerModel() {
		
	}
	
	private func realmToEventModel() {
		
	}
	
}
