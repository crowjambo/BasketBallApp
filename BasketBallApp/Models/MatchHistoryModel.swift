import Foundation

class MatchHistory{
	var team1Name:String?
	var team2Name:String?
	var date:String?
	
	convenience init(team1Name:String?, team2Name:String?, date:String?) {
		self.init()
		self.team1Name = team1Name
		self.team2Name = team2Name
		self.date = date
	}
}
