import Foundation
import CoreData
@testable import BasketBallApp

class MockCoreDataManager: DataPersistable {
	func delete(_ object: Any) {
		return
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) {
		return
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		return
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		return
	}
	

	
}
