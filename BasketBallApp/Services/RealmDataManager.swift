import Foundation
import RealmSwift

class RealmDataManager: DataPersistable {
	
	let mapper: ModelRealmMapper = ModelRealmMapper()
	
	func saveTeams(teamsToSave: [Team]?) {
		
		guard let teams = teamsToSave else { return }
		guard let realm = try? Realm() else { return }
	
		for team in teams {
			let teamToSave = mapper.modelTeamToRealm(from: team)
			do {
				try realm.write {
					realm.add(teamToSave, update: .modified)
				}
			} catch {
			}
		}
		
	}
	
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void) {

		var outputTeams: [Team] = []
	
		guard let realm = try? Realm() else { return }
		let realmTeams = realm.objects(RealmTeam.self)
		for team in realmTeams {
			let mappedTeam = self.mapper.realmTeamToModel(from: team)
			outputTeams.append(mappedTeam)
		}
		log.debug(Realm.Configuration.defaultConfiguration.fileURL!)
		completionHandler(.success(outputTeams))
		
	}
	
}
