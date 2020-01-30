import Foundation
@testable import BasketBallApp
import RealmSwift

class MockRealmDataManager: DataPersistable {
	
	func saveTeams(teamsToSave: [Team]?) {
		return
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		return
	}
	
}
