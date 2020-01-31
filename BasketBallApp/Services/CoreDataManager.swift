import Foundation
import CoreData

protocol DataPersistable {
	func saveTeams(teamsToSave: [Team]?)
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void )
}

enum TeamsLoadError: Error {
	case failedToLoadTeams
}

final class CoreDataManager: DataPersistable {
		
	private let mapper: ModelCoreMapper
	
	init(mapper: ModelCoreMapper = ModelCoreMapper() ) {
		self.mapper = mapper
	}
		
	var persistentContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "database")
		container.loadPersistentStores(completionHandler: { (_, _) in
			
		})
		return container
	}()
	
	lazy var context = persistentContainer.viewContext

	private func save() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				
			}
		}
	}
	
	private func fetch<T>(_ objectType: T.Type) -> [T] {
		
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		do {
			let fetchedObjects = try context.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? [T]()
		} catch {
			print(error)
			return [T]()
		}
	}
	
	private func delete(_ object: NSManagedObject) {
		context.delete(object)
		save()
	}
	
	private func deleteAllOfType<T: NSManagedObject>(_ objectType: T.Type) {
		let allObjects = fetch(objectType)
		for obj in allObjects {
			delete(obj)
		}
		save()
	}
	
	func saveTeams(teamsToSave: [Team]?) {
		
		guard let teamsToSave = teamsToSave else { return }
		deleteAllOfType(Players.self)
		deleteAllOfType(Events.self)
		deleteAllOfType(Teams.self)
		
		for team in teamsToSave {
			_ = mapper.teamModelToCoreData(team: team, dataManager: self)
			save()
		}
		
	}

	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void ) {
		
		let allTeams = self.fetch(Teams.self)
		var teamsRet: [Team] = []
		
			for team in allTeams {
				var teamToAdd: Team = self.mapper.teamDataToTeamModel(team: team)
				
				guard let loadedPlayers = team.teamPlayers?.array as? [Players] else { return }
				teamToAdd.teamPlayers = self.mapper.playersDataToPlayersModelArray(players: loadedPlayers)
				
				guard let loadedEvents = team.teamEvents?.array as? [Events] else { return }
				teamToAdd.matchHistory = self.mapper.eventsDataToEventsModelArray(events: loadedEvents)
				
				teamsRet.append(teamToAdd)
				
			}
		if teamsRet.isEmpty {
			completionHandler(.failure(TeamsLoadError.failedToLoadTeams))
		} else {
			completionHandler(.success(teamsRet))
		}
	}
	
}
