import Foundation
import RealmSwift

// TODO: refactor DataPersistable to lessen useless methods, or create adapters in them to repurpose stuff
// TODO: only load teams and save teams really needs to be public API's in current usecase, easy abstraction
//TODO: realm persistable is automatic mapper

class RealmDataManager: DataPersistable {
	
	let mapper: ModelRealmMapper = ModelRealmMapper()
	
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
		guard let realm = try? Realm() else { return }
		do {
			try realm.write {
				realm.deleteAll()
			}
		} catch {
			
		}
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		
		guard let teams = teamsToSave else { return }
		guard let realm = try? Realm() else { return }
		
		//might not need this, due to update in add
		deleteAllOfType(RealmTeam.self)
	
		for team in teams {
			let teamToSave = mapper.modelTeamToRealm(from: team)
			do {
				try realm.write {
					realm.add(teamToSave, update: .all)
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
				let mappedTeam = self.mapper.realmToTeamModel(from: team)
				outputTeams.append(mappedTeam)
			}
			print(Realm.Configuration.defaultConfiguration.fileURL!)
			debugPrint("Loaded from Realm DB")
			completionHandler(.success(outputTeams))
		}
	}
	
}
