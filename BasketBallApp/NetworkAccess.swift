import Foundation
import Alamofire

class NetworkAccess {
	
	typealias TeamsResponse = ( [TeamInfo]?, Error? ) -> Void
	typealias PlayersResponse = ( [Player]?, Error? ) -> Void
	typealias MatchesResponse = ( [MatchHistory]?, Error? ) -> Void
	
	// MARK: - URLSession methods
	
	class func getTeams(completionHandler: @escaping ([TeamInfo]) -> () ) {

		let input:String = "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA"
		guard let url = URL(string: input) else { return }
		let session = URLSession.shared
		let task = session.dataTask(with: url) { (data, response, error) in
			guard let data = data else { return }
			do {
				let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: data)
				guard let _teams = teams.teams else { return }
				completionHandler(_teams)
			} catch {
			}
		}
		task.resume()
	}
	
	class func getPlayers(teamName:String, completionHandler: @escaping ([Player]) -> () ) {
		
		let escapedString = teamName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let input:String = "https://www.thesportsdb.com/api/v1/json/1/searchplayers.php?t=\(escapedString ?? "" )"
		
		guard let url = URL(string: input) else { return }
		let session = URLSession.shared
		let task = session.dataTask(with: url) { (data, response, error) in
			guard let data = data else { return }

			do {
				let players = try JSONDecoder().decode(PlayerJsonResponse.self, from: data)
				completionHandler(players.player!)
			} catch {
				print("error")
			}
		}
		task.resume()
	}
	
	class func getMatches(teamID:String, completionHandler: @escaping ([MatchHistory]) -> () ){
		let input:String = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=\(teamID)"
		guard let url = URL(string: input) else { return }
		let session = URLSession.shared
		let task = session.dataTask(with: url) { (data, response, error) in
			guard let data = data else { return }
			do {
				let matches = try JSONDecoder().decode(MatchHistoryJsonResponse.self, from: data)
				completionHandler(matches.results!)
			} catch {
			}
		}
		task.resume()
	}
	
	// MARK: - Alamofire methods
	
	class func getTeams_AF(completionHandler: @escaping TeamsResponse){
		guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/1/search_all_teams.php?l=NBA") else { return }
	
			AF.request(url, method: .get).responseJSON { (response) in
				
				switch response.result{
					case .success:
						do{
							let teams = try JSONDecoder().decode(TeamsJsonResponse.self, from: response.data!)
							completionHandler(teams.teams!, response.error)
						}catch{
							
						}
			
					case .failure:
						debugPrint(response.result)

				}
			}
		}
	
	class func getPlayers_AF(teamName:String, completionHandler: @escaping PlayersResponse){
		let escapedString = teamName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		let input:String = "https://www.thesportsdb.com/api/v1/json/1/searchplayers.php?t=\(escapedString ?? "" )"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result{
				case .success:
					do{
						let players = try JSONDecoder().decode(PlayerJsonResponse.self, from: response.data!)
						completionHandler(players.player!, response.error)
					} catch{
						
					}
				case .failure:
					debugPrint(response.result)
				}
			}
		}
	
	class func getMatches_AF(teamID:String, completionHandler: @escaping MatchesResponse){
		let input:String = "https://www.thesportsdb.com/api/v1/json/1/eventslast.php?id=\(teamID)"
		guard let url = URL(string: input) else { return }
		
		AF.request(url, method: .get).responseJSON { (response) in
			switch response.result{
				case .success:
				do{
					let matches = try JSONDecoder().decode(MatchHistoryJsonResponse.self, from: response.data!)
					completionHandler(matches.results, response.error)
					}catch{
						
				}
				case .failure:
					debugPrint(response.result)
			}
		}
	}





}
