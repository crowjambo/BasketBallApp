import Foundation
import Alamofire

//public protocol HTTPClient {
//	func request(baseAPIURL: String, url: String, completionHandler: @escaping (Result<[Any]?, Error>) -> Void)
//}
//
//class FakeHTTPClient: HTTPClient {
//	func request(baseAPIURL: String, url: String, completionHandler: @escaping (Result<[Any]?, Error>) -> Void) {
//		DispatchQueue.global().async {
//			//read json
//			//do decoding
//			//completionHandler return result
//		}
//	}

protocol ExternalDataRetrievable {
	
	typealias TeamsResponse =  (Result<[Team]?, Error>) -> Void
	typealias PlayersReseponse = (Result<[Player]?, Error>) -> Void
	typealias EventsResponse = (Result<[Event]?, Error>) -> Void
	
	func getTeams(baseApiURL: String, url: String, completionHandler: @escaping TeamsResponse)
	func getPlayers(baseApiURL: String, url: String, teamName: String, completionHandler: @escaping PlayersReseponse)
	func getEvents(baseApiURL: String, url: String, teamID: String, completionHandler: @escaping EventsResponse)
	func getAllTeamsPlayersApi(teams: [Team]?, completionHandler: @escaping TeamsResponse)
	func getAllTeamsEventsApi(teams: [Team]?, completionHandler: @escaping TeamsResponse)
	
}

class HttpRequestsManager: ExternalDataRetrievable {
	
	typealias TeamsResponse =  (Result<[Team]?, Error>) -> Void
	typealias PlayersReseponse = (Result<[Player]?, Error>) -> Void
	typealias EventsResponse = (Result<[Event]?, Error>) -> Void
		
	func getTeams(
		baseApiURL: String = "https://www.thesportsdb.com/api/v1/json/1/",
		url: String = "search_all_teams.php?l=NBA",
		completionHandler: @escaping TeamsResponse) {
		
		guard let url = URL(string: baseApiURL + url) else { return }
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result {
			case .success:
				do {
					guard let data = response.data else { return }
					let teams = try
						// TODO: - literally split this and just test separately from file data
						JSONDecoder().decode(TeamsJsonResponse.self, from: data)
					completionHandler(.success(teams.teams))
					} catch {
						debugPrint(error)
					}
			case .failure:
				if let error = response.error {
					completionHandler(.failure(error))
				}
			}
		}
	}

	// TODO: - add alamofire into protocol and inject
	func getPlayers(
		baseApiURL: String = "https://www.thesportsdb.com/api/v1/json/1/",
		url: String = "searchplayers.php?t=",
		teamName: String, completionHandler: @escaping (Result<[Player]?, Error>) -> Void ) {
		
		let escapedString = teamName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let input: String = baseApiURL + "\(url)\(escapedString ?? "" )"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result {
			case .success:
				do {
					guard let data = response.data else { return }
					let players = try JSONDecoder().decode(PlayerJsonResponse.self, from: data)
					completionHandler(.success(players.player))
					} catch {
						debugPrint(error)
					}
			case .failure:
				if let error = response.error {
					completionHandler(.failure(error))
				}
			}
		}
	}
	
	func getEvents(
		baseApiURL: String = "https://www.thesportsdb.com/api/v1/json/1/",
		url: String = "eventslast.php?id=",
		teamID: String, completionHandler: @escaping EventsResponse) {
		
		let input: String = baseApiURL + "\(url)\(teamID)"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result {
			case .success:
				do {
					guard let data = response.data else { return }
					let matches = try JSONDecoder().decode(MatchHistoryJsonResponse.self, from: data)
					completionHandler(.success(matches.results))
					} catch {
						debugPrint(error)
					}
			case .failure:
				if let error = response.error {
					completionHandler(.failure(error))
				}
			}
		}
	}
	
	func getAllTeamsPlayersApi(teams: [Team]?, completionHandler: @escaping TeamsResponse) {
		
		guard var outputTeams = teams else { return }
		let apiGroup = DispatchGroup()
		
		for index in 0..<outputTeams.count {
			apiGroup.enter()
			getPlayers(teamName: outputTeams[index].teamName!) { (res) in
				switch res {
				case .success(let players):
					outputTeams[index].teamPlayers = players
				case .failure(let err):
					outputTeams[index].teamPlayers = []
					debugPrint(err)
				}
				apiGroup.leave()
			}
		}
			
		apiGroup.notify(queue: .main) {
			completionHandler(.success(outputTeams))
		}
		
	}
	
	func getAllTeamsEventsApi(teams: [Team]?, completionHandler: @escaping TeamsResponse) {
		
		guard var outputTeams = teams else { return }
		
		let apiGroup = DispatchGroup()
		
		for index in 0..<outputTeams.count {
			apiGroup.enter()
			getEvents(teamID: outputTeams[index].teamID!) { (res) in
				switch res {
				case .success(let events):
					outputTeams[index].matchHistory = events
				case .failure(let err):
					outputTeams[index].matchHistory = []
					debugPrint(err)
				}
				apiGroup.leave()
			}

		}
		
		apiGroup.notify(queue: .main) {
			completionHandler(.success(outputTeams))
		}
		
	}
}
