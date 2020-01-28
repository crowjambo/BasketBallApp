import Foundation
import RealmSwift

class RealmDataManager: DataPersistable {
	
	func save() {
		
	}
	
	func fetch<T>(_ objectType: T.Type) -> [T] {
		return [T]()
	}
	
	func delete(_ object: Any) {
		
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) {
		
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		
	}
	
	
}
