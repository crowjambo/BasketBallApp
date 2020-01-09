import Foundation


// first page team description model
class TeamInfo{
	var teamName:String = ""
	var description:String = ""
	var imageIconName:String = ""
	var imageTeamMain:String = ""
	
	//add through append later
	var matchHistory: [MatchHistory] = []
	var teamPlayers: [Player] = []
	
	convenience init(teamName:String, description:String, imageIconName: String, imageTeamMain:String){
		self.init()
		self.teamName = teamName
		self.description = description
		self.imageIconName = imageIconName
		self.imageTeamMain = imageTeamMain
		
	}
}

