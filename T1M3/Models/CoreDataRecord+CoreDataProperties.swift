//
//  CoreDataRecord+CoreDataProperties.swift
//  
//
//  Created by Bob on 9/29/18.
//
//

import Foundation
import CoreData


extension CoreDataRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataRecord> {
        return NSFetchRequest<CoreDataRecord>(entityName: "CoreDataRecord")
    }

    @NSManaged public var editedDuration: Double
    @NSManaged public var id: Int16
    @NSManaged public var notes: String?
    @NSManaged public var rawWeatherValue: Int16
    @NSManaged public var startLocationName: String?
    @NSManaged public var timeStarted: Double
    @NSManaged public var endLocation: Location?
    @NSManaged public var startLocation: Location?

}
