import Foundation

// TODO: - implement calling Core data and API depending on Defaults manager

class DataLoadingManager{
	
	class func loadData(completionHandler: @escaping ( [Team]? ) -> Void ){
		
		
		// Variables
		var teams : [Team]?
		
		let group = DispatchGroup()
		
		// Decide what needs to be pulled from CoreData, what needs to be API fetched
		if(DefaultsManager.shouldUpdate(id: UpdateTime.Team))
		
		
		
		// API loading  + Add saving to CoreData (using relationship, for easy fetch from Core too)
		
		group.enter()
		NetworkClient.getTeams { (teamsRet, error) in
			teams = teamsRet
			
			group.leave()
			
		}
		
		group.notify(queue: .main) {
			
			for n in 0..<teams!.count{
				
				group.enter()
				NetworkClient.getPlayers(teamName: teams![n].teamName!) { (playersRet, error) in
					teams![n].teamPlayers = playersRet
					group.leave()
				}
				group.enter()
				NetworkClient.getEvents(teamID: teams![n].teamID!) { (eventsRet, error) in
					teams![n].matchHistory = eventsRet
					group.leave()
				}
			}
			
			group.notify(queue: .main) {
				completionHandler(teams)
			}
			
		}
	}
	
	
}
