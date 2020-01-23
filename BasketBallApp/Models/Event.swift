import Foundation

struct Event: Decodable {
	var homeTeamName: String?
	var awayTeamName: String?
	var date: String?
	
	enum CodingKeys: String, CodingKey {
		case homeTeamName = "strHomeTeam"
		case awayTeamName = "strAwayTeam"
		case date = "dateEvent"
		
	}
}
