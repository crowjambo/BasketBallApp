import Foundation
import RealmSwift

class RealmDataManager: DataPersistable {
	
	let mapper: ModelRealmMapper = ModelRealmMapper()
	
	func save() {
		//save to context
		
	}
	
	func fetch<T>(_ objectType: T.Type) -> [T] {
		//helper method used in loadTeams only
		
		return [T]()
	}
	
	func delete(_ object: Any) {
		//delete passed object
		
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) {
		//delete all obviously
		
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		
		guard let teams = teamsToSave else { return }
		guard let realm = try? Realm() else { return }
		realm.deleteAll()
		for team in teams {
			let teamToSave = mapper.modelTeamToRealm(modelTeam: team)
			do{
				try realm.write {
					realm.add(teamToSave)
				}
			} catch {
				debugPrint("failed to write to realm")
			}
		}
		
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {
		//async call with DispatchQueue
		//create empty [Team]? obj
		//use fetch and mapper to pull DB models and convert them to [Team]
		//same for players and events
		//append everything together
		//return using completionHandler [Team]? obj you created
		
		
	}
	
}
