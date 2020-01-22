import Foundation

// TODO: - implement calling Core data and API depending on Defaults manager

class DataLoadingManager{
	
	// Variables
	var teams : [Team]?
	let group = DispatchGroup()
	
	func loadData(completionHandler: @escaping ( [Team]? ) -> Void ){
		
//		if DefaultsManager.shouldUpdate(id: UpdateTime.Team){
//			loadTeamsApi()
//		}
//		else{
//			loadTeamsCore()
//		}
		loadTeamsApi()
		
		group.notify(queue: .main) {
			
			for index in 0..<self.teams!.count{
				
				self.loadPlayersApi(teamIndex: index)
				self.loadEventsApi(teamIndex: index)

			}
			
			self.group.notify(queue: .main) {
				completionHandler(self.teams)
			}
			
		}
	}
	
	
	// MARK: - TEAMS LOADING / SAVING
	
	private func loadTeamsApi(){
		
		self.group.enter()
		NetworkClient.getTeams { (teamsRet, error) in
			self.teams = teamsRet
			
			self.group.leave()
		}
	}
	
	private func loadTeamsCore(){
		// load using relationships @ coreData
		
	}
	
	private func saveTeamsCore(){
		// call after everything is fetched ( players / events )
		
	}
	
	// MARK: - PLAYERS LOADING / SAVING
	
	private func loadPlayersApi(teamIndex : Int){
		
		self.group.enter()
		
		NetworkClient.getPlayers(teamName: self.teams![teamIndex].teamName!) { (playersRet, error) in
			self.teams![teamIndex].teamPlayers = playersRet
			self.group.leave()
		}
	}
	
	private func loadPlayersCore(){
		
	}
	
	private func savePlayersCore(){
		
	}
	
	// MARK: - EVENTS LOADING / SAVING
	
	private func loadEventsApi(teamIndex : Int){
		
		self.group.enter()
		
		NetworkClient.getEvents(teamID: self.teams![teamIndex].teamID!) { (eventsRet, error) in
			self.teams![teamIndex].matchHistory = eventsRet
			self.group.leave()
		}
	}
	
	private func loadEventsCore(){
		
	}
	
	private func saveEventsCore(){
		
	}
	
	
	
}
