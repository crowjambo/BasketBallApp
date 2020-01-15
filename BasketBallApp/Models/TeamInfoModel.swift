import Foundation


struct TeamInfo : Decodable{
	var teamID: String?
	var teamName:String?
	var description:String?
	var imageIconName:String?
	var imageTeamMain:String?
	
	//other collections
	var matchHistory: [MatchHistory]?
	var teamPlayers: [Player]?
	
	enum CodingKeys: String, CodingKey{
		case teamID = "idTeam"
		case teamName = "strTeam"
		case description = "strDescriptionEN"
		case imageIconName = "strTeamBadge"
		case imageTeamMain = "strStadiumThumb"
		
	}
}

