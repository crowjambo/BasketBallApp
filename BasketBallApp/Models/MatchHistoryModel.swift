import Foundation

struct MatchHistory :Decodable{
	var team1Name:String?
	var team2Name:String?
	var date:String?
	
	enum CodingKeys: String, CodingKey{
		case team1Name = "strHomeTeam"
		case team2Name = "strAwayTeam"
		case date = "dateEvent"
		
	}
}
