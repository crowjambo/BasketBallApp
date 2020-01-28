import Foundation
import RealmSwift

// TODO: refactor DataPersistable to lessen useless methods, or create adapters in them to repurpose stuff
// TODO: only load teams and save teams really needs to be public API's in current usecase, easy abstraction

class RealmDataManager: DataPersistable {
	
	let mapper: ModelRealmMapper = ModelRealmMapper()
	
	func save() {
		//useless, dont really need this in realm
	}
	
	func fetch<T>(_ objectType: T.Type) -> [T] {

//		guard let realm = try? Realm() else { return [T]() }
//
//		let entityName = String(describing: objectType)
//
//		if entityName == "RealmTeam" {
//			let objToFetch = RealmTeam()
//
//			let objects = realm.objects(type(of: objToFetch))
//			for obj in objects {
//				return objects
//			}
//		}
		// dont really need this with Realm, and it uses very different return type
		
		return [T]()
	}
	
	func delete(_ object: Any) {
		guard let realm = try? Realm() else { return }
		guard let objToDel = object as? Object else { return }
		do {
			try realm.write {
				realm.delete(objToDel)
			}
		} catch {
			debugPrint("failed to delete one object")
		}
		
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) {
		//Useless due to realm.deleteAll() for current usecase
		//could be used later to delete specific things only
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		
		guard let teams = teamsToSave else { return }
		guard let realm = try? Realm() else { return }
		realm.deleteAll()
		for team in teams {
			let teamToSave = mapper.modelTeamToRealm(modelTeam: team)
			do {
				try realm.write {
					realm.add(teamToSave)
				}
			} catch {
				debugPrint("failed to write to realm")
			}
		}
		
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {

		var outputTeams: [Team] = []
		
		DispatchQueue.global().async {
			guard let realm = try? Realm() else { return }
			let realmTeams = realm.objects(RealmTeam.self)
			for team in realmTeams {
				let mappedTeam = self.mapper.realmToTeamModel(realmModel: team)
				outputTeams.append(mappedTeam)
			}
			
			completionHandler(.success(outputTeams))
		}
	}
	
}
