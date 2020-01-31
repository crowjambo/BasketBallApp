import Foundation
@testable import BasketBallApp
import RealmSwift

class MockDataManager: DataPersistable {
	
	var teamsReturn: [Team] = []
	
	func saveTeams(teamsToSave: [Team]?) {
		return
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		
		completionHandler(.success(teamsReturn))
	}
	
}
