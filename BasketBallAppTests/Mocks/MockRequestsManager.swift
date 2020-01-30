import Foundation
import Alamofire
import OHHTTPStubs

@testable import BasketBallApp

class MockRequestsManager: ExternalDataRetrievable {
		
	func getTeams(baseApiURL: String = "https://thesportsdb.com/api/v1/json/1/", url: String = "search_all_teams.php?l=NBA", completionHandler: @escaping TeamsResponse) {
		
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
