import Foundation

class Mapper {
	
	class func teamDataToTeamModel(team: Teams) -> Team {
		return Team(teamID: team.teamID, teamName: team.teamName, description: team.teamDescription, imageIconName: team.teamIcon, imageTeamMain: team.teamImage)
	}
	
	class func eventsDataToEventsModelArray(events : [Events]) -> [Event] {
		var outputEvents: [Event] = []
		
		for event in events {
			outputEvents.append(eventDataToEventModel(event: event))
		}
		
		return outputEvents
	}
	
	private class func eventDataToEventModel(event: Events) -> Event {
		return Event(homeTeamName: event.homeTeamName, awayTeamName: event.awayTeamName, date: event.matchDate)
	}
	
	class func playersDataToPlayersModelArray(players: [Players]) -> [Player] {
		var outputPlayers: [Player] = []
		
		for player in players {
			outputPlayers.append(playerDataToPlayerModel(player: player))
		}
		
		return outputPlayers
	}
	
	private class func playerDataToPlayerModel(player: Players) -> Player {
		return Player(name: player.name, age: player.age, height: player.height, weight: player.weight, description: player.playerDescription, position: player.position, playerIconImage: player.iconImage, playerMainImage: player.mainImage)
	}
}
