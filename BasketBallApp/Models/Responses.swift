import Foundation

struct MatchHistoryJsonResponse: Decodable {
	var results: [Event]?
}

struct PlayerJsonResponse: Decodable {
	var player: [Player]?
}

struct TeamsJsonResponse: Decodable {
	var teams: [Team]?
}
