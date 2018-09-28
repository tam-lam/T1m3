//
//  CoreDataRecord+CoreDataProperties.swift
//  
//
//  Created by Graphene on 28/9/18.
//
//

import Foundation
import CoreData


extension CoreDataRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataRecord> {
        return NSFetchRequest<CoreDataRecord>(entityName: "CoreDataRecord")
    }

    @NSManaged public var editedDuration: Double
    @NSManaged public var notes: String?
    @NSManaged public var timeStarted: Double

}
