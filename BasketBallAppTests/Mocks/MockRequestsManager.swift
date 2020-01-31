import Foundation
import Alamofire
import OHHTTPStubs

@testable import BasketBallApp

class MockRequestsManager: ExternalDataRetrievable {
	
	var teamsReturn: [Team] = []
	var playersReturn: [Player] = []
	var eventsReturn: [Event] = []
		
	func getTeams(completionHandler: @escaping TeamsResponse) {
		
		completionHandler(.success(teamsReturn))
	}
	
	func getPlayers(teamName: String, completionHandler: @escaping ExternalDataRetrievable.PlayersReseponse) {
		
		completionHandler(.success(playersReturn))
	}
	
	func getEvents(teamID: String, completionHandler: @escaping ExternalDataRetrievable.EventsResponse) {
		
		completionHandler(.success(eventsReturn))
	}
	
	func getAllTeamsPlayersApi(teams: [Team]?, completionHandler: @escaping ExternalDataRetrievable.TeamsResponse) {
		
		completionHandler(.success(teamsReturn))
	}
	
	func getAllTeamsEventsApi(teams: [Team]?, completionHandler: @escaping ExternalDataRetrievable.TeamsResponse) {
		
		completionHandler(.success(teamsReturn))
	}
	
}
