import Foundation
import CoreData

final class DataManager{
	
	private init(){}
	static let shared = DataManager()
		
	lazy var persistentContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "database")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
				print("saved successfuly")
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
	
	func fetch<T: NSManagedObject>(_ objectType: T.Type) -> [T]{
		
		let entityName = String(describing: objectType)
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
		do{
			let fetchedObjects = try context.fetch(fetchRequest) as? [T]
			return fetchedObjects ?? [T]()
		} catch {
			print(error)
			return [T]()
		}
	}
	
	func delete(_ object: NSManagedObject){
		context.delete(object)
		save()
	}
	
	func deleteAllOfType<T: NSManagedObject>(_ objectType: T.Type){
		let allObjects = fetch(objectType)
		for obj in allObjects{
			delete(obj)
		}
		save()
	}
	
}


