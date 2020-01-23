//
//  Events+CoreDataProperties.swift
//  
//
//  Created by Evaldas on 1/22/20.
//
//

import Foundation
import CoreData

extension Events {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Events> {
        return NSFetchRequest<Events>(entityName: "Events")
    }

    @NSManaged public var awayTeamName: String?
    @NSManaged public var homeTeamName: String?
    @NSManaged public var matchDate: String?
    @NSManaged public var team: Teams?

}
