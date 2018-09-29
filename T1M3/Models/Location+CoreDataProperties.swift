//
//  Location+CoreDataProperties.swift
//  
//
//  Created by Bob on 9/29/18.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}
