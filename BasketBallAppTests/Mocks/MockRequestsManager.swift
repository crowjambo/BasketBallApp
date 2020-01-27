import Foundation
import Alamofire
@testable import BasketBallApp

class MockRequestsManager: ExternalDataRetrievable {
	
	private func getTeamsCatchingForOHHTTPStubs(_ baseApiURL: String, _ url: String, completionHandler: @escaping ([Team]?) -> Void) {
		
		guard let url = URL(string: "\(baseApiURL)\(url)") else { return }
		AF.request(url, method: .get).responseJSON { (response) in
			do {
				guard let data = response.data else { return }
				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
				completionHandler(teams.teams)
			} catch {
				
			}

		}
	}
	
	// Return data, OHTTPStubs testing is for the API itself
	func getTeams(baseApiURL: String, url: String, completionHandler: @escaping TeamsResponse) {

		var outputTeams: [Team]?
		
		getTeamsCatchingForOHHTTPStubs(baseApiURL, url) { (teams) in
			outputTeams = teams
			
			completionHandler(.success(outputTeams))
		}
	
		//completionHandler(.success([Team]()))
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
