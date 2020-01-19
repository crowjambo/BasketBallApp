import Foundation


struct Team : Decodable{
	var teamID: String?
	var teamName : String?
	var description : String?
	var imageIconName :String?
	var imageTeamMain : String?
	
	var teamPlayers : [Player]?
	var matchHistory : [Event]?

	enum CodingKeys: String, CodingKey{
		case teamID = "idTeam"
		case teamName = "strTeam"
		case description = "strDescriptionEN"
		case imageIconName = "strTeamBadge"
		case imageTeamMain = "strStadiumThumb"
		
	}
}

