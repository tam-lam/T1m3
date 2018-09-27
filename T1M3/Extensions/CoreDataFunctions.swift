//
//  UIViewControllerExt.swift
//  T1M3
//
//  Created by Graphene on 27/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import CoreData
import UIKit
let appDelegate = UIApplication.shared.delegate as? AppDelegate

//Core data function related extension
extension UIViewController{
    func saveToCoreData(record: Recording){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let entity = CoreDataRecord(context: managedContext)
        entity.notes = record.notes
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not save record")
        }
    }
    func fetch() -> [CoreDataRecord]{
        var recordLogs: [CoreDataRecord] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return []}
        let fetchRequest: NSFetchRequest<CoreDataRecord> = CoreDataRecord.fetchRequest()
        do{
            recordLogs = try managedContext.fetch(fetchRequest)
        } catch{
            debugPrint("Cannot fetch CoreDateRecord")
        }
        return recordLogs
    }
    
}
