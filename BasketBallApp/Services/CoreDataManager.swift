import Foundation
import CoreData

protocol DataPersistable {
	func save()
	func fetch<T>(_ objectType: T.Type) -> [T]
	func delete(_ object: Any)
	func deleteAllOfType<T>(_ objectType: T.Type)
	func saveTeams(teamsToSave: [Team]?)
	func loadTeams(completionHandler: @escaping (Result<[Team]?, Error>) -> Void )
}

final class CoreDataManager: DataPersistable {
		
	let mapper: ModelCoreMapper
	
	init(mapper: ModelCoreMapper = ModelCoreMapper() ) {
		self.mapper = mapper
	}
		
	lazy var persistentContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "database")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	lazy var context = persistentContainer.viewContext

	func save() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func fetch<T>(_ objectType: T.Type) -> [T] {
		
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
	
	func delete(_ object: Any) {
		guard let objToDel = object as? NSManagedObject else { return }
		context.delete(objToDel)
		save()
	}
	
	func deleteAllOfType<T>(_ objectType: T.Type) {
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
		
		DispatchQueue.global().async {
			let result = self.fetch(Teams.self)
			var teamsRet: [Team] = []
			
				for team in result {
					var teamToAdd: Team = self.mapper.teamDataToTeamModel(team: team)
					
					guard let loadedPlayers = team.teamPlayers?.array as? [Players] else { return }
					teamToAdd.teamPlayers = self.mapper.playersDataToPlayersModelArray(players: loadedPlayers)
					
					guard let loadedEvents = team.teamEvents?.array as? [Events] else { return }
					teamToAdd.matchHistory = self.mapper.eventsDataToEventsModelArray(events: loadedEvents)
					
					teamsRet.append(teamToAdd)
					
				}
			completionHandler(.success(teamsRet))
			
			debugPrint("loaded from coreData")
		}

	}
	
}
