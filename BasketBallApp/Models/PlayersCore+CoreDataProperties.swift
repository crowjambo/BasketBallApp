import Foundation
import CoreData

extension PlayersCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayersCore> {
        return NSFetchRequest<PlayersCore>(entityName: "PlayersCore")
    }

    @NSManaged public var age: String?
    @NSManaged public var height: String?
    @NSManaged public var iconImage: String?
    @NSManaged public var mainImage: String?
    @NSManaged public var name: String?
    @NSManaged public var playerDescription: String?
    @NSManaged public var position: String?
    @NSManaged public var weight: String?
    @NSManaged public var team: TeamsCore?

}
