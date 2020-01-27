import Foundation
import CoreData
@testable import BasketBallApp

class MockCoreDataManager: DataPersistable {
	func save() {
		return
	}
	
	func fetch<T>(_ objectType: T.Type) -> [T] where T : NSManagedObject {
		return [T]()
	}
	
	func delete(_ object: NSManagedObject) {
		return
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) where T : NSManagedObject {
		return
	}
	
	func saveTeamsCore(teamsToSave: [Team]?) {
		return
	}
	
	func loadTeamsCore(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		return
	}
	
	
}
