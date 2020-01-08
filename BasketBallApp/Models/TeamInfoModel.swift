import Foundation


// first page team description model
class TeamInfo{
	var teamName:String = ""
	var description:String = ""
	// should have var for string or so name for icon of the team
	
	convenience init(teamName:String, description:String){
		self.init()
		self.teamName = teamName
		self.description = description
		//team icon init
	}
}
