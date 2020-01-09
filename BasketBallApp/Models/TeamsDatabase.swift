//
//  TeamsDatabase.swift
//  BasketBallApp
//
//  Created by Evaldas on 1/9/20.
//  Copyright © 2020 Evaldas. All rights reserved.
//

import Foundation

class TeamsDatabase{
	
	class func LoadFakeData() -> [TeamInfo]{
		var teams: [TeamInfo] = []
		
		var someTeam:TeamInfo = TeamInfo(teamName: "Toronto Raptors2", description: "Pretty good team", imageIconName: "pencil.circle.fill", imageTeamMain: "toronto")
		
		someTeam.teamPlayers.append(Player(name: "Evaldas", age: 10, height: 200, weight: 100, description: "Cool guy", position: "center", playerIconImage: "square", playerMainImage: "player1"))
		
		
		someTeam.teamPlayers.append(Player(name: "Jonas", age: 30, height: 50, weight: 200, description: "BALBLALBALBLALBALBLALABLLBALABLABLLABLALBALBLA", position: "dumpster", playerIconImage: "pencil.circle", playerMainImage: "player2"))
		
		
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "Salininku Maxima", date: "Jan 1"))
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "Sasdasd", date: "Jan 2"))
		someTeam.matchHistory.append(MatchHistory(team1Name: someTeam.teamName, team2Name: "cccc", date: "Jan 3"))
		
		teams.append(someTeam)
		teams.append(someTeam)
		teams.append(someTeam)
		
		return teams
		
	}
}
