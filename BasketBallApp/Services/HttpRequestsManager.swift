import Foundation
import Alamofire

class HttpRequestsManager {
	
	typealias TeamsResponse =  (Result<[Team]?, Error>) -> Void
	typealias PlayersReseponse = (Result<[Player]?, Error>) -> Void
	typealias EventsResponse = (Result<[Event]?, Error>) -> Void
		
	let baseApiURL: String = "https://www.thesportsdb.com/api/v1/json/1/"
	
	func getTeams(completionHandler: @escaping TeamsResponse) {
		
		guard let url = URL(string: baseApiURL + "search_all_teams.php?l=NBA") else { return }
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result {
			case .success:
				do {
					guard let data = response.data else { return }
					let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
					completionHandler(.success(teams.teams))
					} catch {
						debugPrint(error)
					}
			case .failure:
					// TODO: show toasts instead of simple debug
					// TODO: better error handling, in case of error show an error toast or redirect to a different view controller
				if let error = response.error {
					completionHandler(.failure(error))
				}
			}
		}
	}

	func getPlayers(teamName: String, completionHandler: @escaping (Result<[Player]?, Error>) -> Void ) {
		
		let escapedString = teamName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let input: String = baseApiURL + "searchplayers.php?t=\(escapedString ?? "" )"
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
	
	func getEvents(teamID: String, completionHandler: @escaping EventsResponse) {
		
		let input: String = baseApiURL + "eventslast.php?id=\(teamID)"
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
