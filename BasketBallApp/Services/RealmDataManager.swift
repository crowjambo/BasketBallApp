import Foundation
import RealmSwift

class RealmDataManager: DataPersistable {
	
	let mapper: ModelRealmMapper = ModelRealmMapper()
	
	func saveTeams(teamsToSave: [Team]?) {
		debugPrint("entered saving mode")
		guard let teams = teamsToSave else { return }
		guard let realm = try? Realm() else { return }
	
		for team in teams {
			let teamToSave = mapper.modelTeamToRealm(from: team)
			do {
				try realm.write {
					realm.add(teamToSave, update: .modified)
				}
			} catch {
				debugPrint("failed to write to realm")
			}
		}
		debugPrint("saved teams into Realm")
		
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {

		var outputTeams: [Team] = []
		
		DispatchQueue.global().async {
			guard let realm = try? Realm() else { return }
			let realmTeams = realm.objects(RealmTeam.self)
			for team in realmTeams {
				let mappedTeam = self.mapper.realmTeamToModel(from: team)
				outputTeams.append(mappedTeam)
			}
			print(Realm.Configuration.defaultConfiguration.fileURL!)
			debugPrint("Loaded from Realm DB")
			completionHandler(.success(outputTeams))
		}
	}
	
}
