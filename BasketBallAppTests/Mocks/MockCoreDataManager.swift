import Foundation
import CoreData
@testable import BasketBallApp

class MockCoreDataManager: DataPersistable {
	
	func saveTeams(teamsToSave: [Team]?) {
		return
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		return
	}
	
}
