import Foundation
@testable import BasketBallApp

class MockRequestsManager: ExternalDataRetrievable {
	func getTeams(baseApiURL: String, url: String, completionHandler: @escaping ExternalDataRetrievable.TeamsResponse) {
		
		completionHandler(.success([Team]()))
	}
	
	func getPlayers(baseApiURL: String, url: String, teamName: String, completionHandler: @escaping ExternalDataRetrievable.PlayersReseponse) {
		
		completionHandler(.success([Player]()))
	}
	
	func getEvents(baseApiURL: String, url: String, teamID: String, completionHandler: @escaping ExternalDataRetrievable.EventsResponse) {
		
		completionHandler(.success([Event]()))
	}
	
	func getAllTeamsPlayersApi(teams: [Team]?, completionHandler: @escaping ExternalDataRetrievable.TeamsResponse) {
		
		completionHandler(.success([Team]()))
	}
	
	func getAllTeamsEventsApi(teams: [Team]?, completionHandler: @escaping ExternalDataRetrievable.TeamsResponse) {
		
		completionHandler(.success([Team]()))
	}
	
}
