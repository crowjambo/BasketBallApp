import Foundation
import CoreData

extension EventsCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventsCore> {
        return NSFetchRequest<EventsCore>(entityName: "EventsCore")
    }

    @NSManaged public var awayTeamName: String?
    @NSManaged public var homeTeamName: String?
    @NSManaged public var matchDate: String?
    @NSManaged public var team: TeamsCore?

}
