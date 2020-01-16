import Foundation

struct MatchHistoryJsonResponse : Decodable{
	var results : [MatchHistory]?
}

struct PlayerJsonResponse : Decodable{
	var player: [Player]?
}

struct TeamsJsonResponse:Decodable{
	var teams: [TeamInfo]?
}
