//
//  Players+CoreDataProperties.swift
//  
//
//  Created by Evaldas on 1/22/20.
//
//

import Foundation
import CoreData


extension Players {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Players> {
        return NSFetchRequest<Players>(entityName: "Players")
    }

    @NSManaged public var age: String?
    @NSManaged public var height: String?
    @NSManaged public var iconImage: String?
    @NSManaged public var mainImage: String?
    @NSManaged public var name: String?
    @NSManaged public var playerDescription: String?
    @NSManaged public var position: String?
    @NSManaged public var weight: String?
    @NSManaged public var team: Teams?

}
