//
//  CoreDataVCExtension.swift
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
    func fetchRecordsFromCoreData() -> [CoreDataRecord]{
        var recordLogs: [CoreDataRecord] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return[]}
        let fetchRequest: NSFetchRequest<CoreDataRecord> = CoreDataRecord.fetchRequest()
        do{
            recordLogs = try managedContext.fetch(fetchRequest)
        } catch{
            debugPrint("Cannot fetch CoreDateRecord")
        }
        return recordLogs
    }
    
    //load all records from Core Data to singleton Record Log
    func loadRecordToSingleton(){
        RecordLog.shared.removeAllRecords()
        let cdRecordLogs:[CoreDataRecord] = fetchRecordsFromCoreData()
        for cdRecord in cdRecordLogs {
            let record = Recording()
            record.notes = cdRecord.notes!
            record.timeStarted = Date().timeIntervalSince1970
            record.editedDuration = 5.0
            record.accData = [(0,1),(1,2),(2,0),(3,5),(4,5),(5,3)]
            record.weather = .rainy
            RecordLog.shared.addRecord(record: record)
        }
    }
    
}
