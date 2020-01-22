import Foundation
import CoreData


extension Teams {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Teams> {
        return NSFetchRequest<Teams>(entityName: "Teams")
    }

    @NSManaged public var teamDescription: String?
    @NSManaged public var teamIcon: String?
    @NSManaged public var teamID: String?
    @NSManaged public var teamImage: String?
    @NSManaged public var teamName: String?
    @NSManaged public var teamPlayers: NSOrderedSet?
    @NSManaged public var teamEvents: NSOrderedSet?

}

// MARK: Generated accessors for teamPlayers
extension Teams {

    @objc(insertObject:inTeamPlayersAtIndex:)
    @NSManaged public func insertIntoTeamPlayers(_ value: Players, at idx: Int)

    @objc(removeObjectFromTeamPlayersAtIndex:)
    @NSManaged public func removeFromTeamPlayers(at idx: Int)

    @objc(insertTeamPlayers:atIndexes:)
    @NSManaged public func insertIntoTeamPlayers(_ values: [Players], at indexes: NSIndexSet)

    @objc(removeTeamPlayersAtIndexes:)
    @NSManaged public func removeFromTeamPlayers(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamPlayersAtIndex:withObject:)
    @NSManaged public func replaceTeamPlayers(at idx: Int, with value: Players)

    @objc(replaceTeamPlayersAtIndexes:withTeamPlayers:)
    @NSManaged public func replaceTeamPlayers(at indexes: NSIndexSet, with values: [Players])

    @objc(addTeamPlayersObject:)
    @NSManaged public func addToTeamPlayers(_ value: Players)

    @objc(removeTeamPlayersObject:)
    @NSManaged public func removeFromTeamPlayers(_ value: Players)

    @objc(addTeamPlayers:)
    @NSManaged public func addToTeamPlayers(_ values: NSOrderedSet)

    @objc(removeTeamPlayers:)
    @NSManaged public func removeFromTeamPlayers(_ values: NSOrderedSet)

}

// MARK: Generated accessors for teamEvents
extension Teams {

    @objc(insertObject:inTeamEventsAtIndex:)
    @NSManaged public func insertIntoTeamEvents(_ value: Events, at idx: Int)

    @objc(removeObjectFromTeamEventsAtIndex:)
    @NSManaged public func removeFromTeamEvents(at idx: Int)

    @objc(insertTeamEvents:atIndexes:)
    @NSManaged public func insertIntoTeamEvents(_ values: [Events], at indexes: NSIndexSet)

    @objc(removeTeamEventsAtIndexes:)
    @NSManaged public func removeFromTeamEvents(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamEventsAtIndex:withObject:)
    @NSManaged public func replaceTeamEvents(at idx: Int, with value: Events)

    @objc(replaceTeamEventsAtIndexes:withTeamEvents:)
    @NSManaged public func replaceTeamEvents(at indexes: NSIndexSet, with values: [Events])

    @objc(addTeamEventsObject:)
    @NSManaged public func addToTeamEvents(_ value: Events)

    @objc(removeTeamEventsObject:)
    @NSManaged public func removeFromTeamEvents(_ value: Events)

    @objc(addTeamEvents:)
    @NSManaged public func addToTeamEvents(_ values: NSOrderedSet)

    @objc(removeTeamEvents:)
    @NSManaged public func removeFromTeamEvents(_ values: NSOrderedSet)

}
