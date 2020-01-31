import Foundation
import CoreData

extension TeamsCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamsCore> {
        return NSFetchRequest<TeamsCore>(entityName: "TeamsCore")
    }

    @NSManaged public var teamDescription: String?
    @NSManaged public var teamIcon: String?
    @NSManaged public var teamID: String?
    @NSManaged public var teamImage: String?
    @NSManaged public var teamName: String?
    @NSManaged public var teamEvents: NSOrderedSet?
    @NSManaged public var teamPlayers: NSOrderedSet?

}

// MARK: Generated accessors for teamEvents
extension TeamsCore {

    @objc(insertObject:inTeamEventsAtIndex:)
    @NSManaged public func insertIntoTeamEvents(_ value: EventsCore, at idx: Int)

    @objc(removeObjectFromTeamEventsAtIndex:)
    @NSManaged public func removeFromTeamEvents(at idx: Int)

    @objc(insertTeamEvents:atIndexes:)
    @NSManaged public func insertIntoTeamEvents(_ values: [EventsCore], at indexes: NSIndexSet)

    @objc(removeTeamEventsAtIndexes:)
    @NSManaged public func removeFromTeamEvents(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamEventsAtIndex:withObject:)
    @NSManaged public func replaceTeamEvents(at idx: Int, with value: EventsCore)

    @objc(replaceTeamEventsAtIndexes:withTeamEvents:)
    @NSManaged public func replaceTeamEvents(at indexes: NSIndexSet, with values: [EventsCore])

    @objc(addTeamEventsObject:)
    @NSManaged public func addToTeamEvents(_ value: EventsCore)

    @objc(removeTeamEventsObject:)
    @NSManaged public func removeFromTeamEvents(_ value: EventsCore)

    @objc(addTeamEvents:)
    @NSManaged public func addToTeamEvents(_ values: NSOrderedSet)

    @objc(removeTeamEvents:)
    @NSManaged public func removeFromTeamEvents(_ values: NSOrderedSet)

}

// MARK: Generated accessors for teamPlayers
extension TeamsCore {

    @objc(insertObject:inTeamPlayersAtIndex:)
    @NSManaged public func insertIntoTeamPlayers(_ value: PlayersCore, at idx: Int)

    @objc(removeObjectFromTeamPlayersAtIndex:)
    @NSManaged public func removeFromTeamPlayers(at idx: Int)

    @objc(insertTeamPlayers:atIndexes:)
    @NSManaged public func insertIntoTeamPlayers(_ values: [PlayersCore], at indexes: NSIndexSet)

    @objc(removeTeamPlayersAtIndexes:)
    @NSManaged public func removeFromTeamPlayers(at indexes: NSIndexSet)

    @objc(replaceObjectInTeamPlayersAtIndex:withObject:)
    @NSManaged public func replaceTeamPlayers(at idx: Int, with value: PlayersCore)

    @objc(replaceTeamPlayersAtIndexes:withTeamPlayers:)
    @NSManaged public func replaceTeamPlayers(at indexes: NSIndexSet, with values: [PlayersCore])

    @objc(addTeamPlayersObject:)
    @NSManaged public func addToTeamPlayers(_ value: PlayersCore)

    @objc(removeTeamPlayersObject:)
    @NSManaged public func removeFromTeamPlayers(_ value: PlayersCore)

    @objc(addTeamPlayers:)
    @NSManaged public func addToTeamPlayers(_ values: NSOrderedSet)

    @objc(removeTeamPlayers:)
    @NSManaged public func removeFromTeamPlayers(_ values: NSOrderedSet)

}
