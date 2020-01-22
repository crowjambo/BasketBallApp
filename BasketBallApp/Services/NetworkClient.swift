import Foundation
import Alamofire

class NetworkClient {
	
	// TODO: Use result instead of typealias
	typealias TeamsResponse = ( [Team]?, Error? ) -> Void
	typealias PlayersResponse = ( [Player]?, Error? ) -> Void
	typealias EventsResponse = ( [Event]?, Error? ) -> Void
	
	static let baseApiURL : String = "https://www.thesportsdb.com/api/v1/json/1/"
	
	class func getTeams(completionHandler: @escaping TeamsResponse){
		
		guard let url = URL(string: baseApiURL + "search_all_teams.php?l=NBA") else { return }
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result{
				case .success:
				do{
					guard let data = response.data else { return }
					let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
					completionHandler(teams.teams, response.error)
					} catch {
						debugPrint(error)
					}
				case .failure:
					// TODO: show toasts instead of simple debug
					// TODO: better error handling, in case of error show an error toast or redirect to a different view controller
					debugPrint(response.result)
			}
		}
	}

	class func getPlayers(teamName:String, completionHandler: @escaping PlayersResponse){
		
		let escapedString = teamName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let input:String = baseApiURL + "searchplayers.php?t=\(escapedString ?? "" )"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result{
				case .success:
				do{
					guard let data = response.data else { return }
					let players = try JSONDecoder().decode(PlayerJsonResponse.self, from: data)
					completionHandler(players.player, response.error)
					} catch {
						debugPrint(error)
					}
				case .failure:
					debugPrint(response.result)
				}
			}
		}
	
	class func getEvents(teamID:String, completionHandler: @escaping EventsResponse){
		
		let input:String = baseApiURL + "eventslast.php?id=\(teamID)"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result{
				case .success:
				do{
					guard let data = response.data else { return }
					let matches = try JSONDecoder().decode(MatchHistoryJsonResponse.self, from: data)
					completionHandler(matches.results, response.error)
					} catch {
						debugPrint(error)
					}
				case .failure:
					debugPrint(response.result)
			}
		}
	}
	
	
}
