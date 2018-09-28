
import Foundation
import UIKit
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

protocol CoreDataFuncs {
    
}
//Core data function related extension
extension UIApplicationDelegate{
    
    func addToCoreData(record: Recording){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let cdRecord = CoreDataRecord(context: managedContext)
        cdRecord.notes = record.notes
        if(record.editedDuration != nil){
            cdRecord.editedDuration =  record.editedDuration!
        }
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
    func saveAll(recordLog: [Recording]){
        debugPrint("Saving all records to Core Data..........")
        self.deleteAll()
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        for record in recordLog{
            addToCoreData(record: record)
        }
    }
    func deleteAll(){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataRecord")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch{
            debugPrint("Cannot delete all CoreDataRecords")
        }
    }
    
    //load all records from Core Data to singleton Record Log
    func loadRecordLogToSingleton(){
        RecordLog.shared.removeAllRecords()
        let cdRecordLogs:[CoreDataRecord] = fetchRecordsFromCoreData()
        for cdRecord in cdRecordLogs {
            let record = Recording()
            record.notes = cdRecord.notes!
            
            //placeholder data
            //TODO : create Core data attribute for Record and get real data to save
            record.timeStarted = Date().timeIntervalSince1970
            
            record.editedDuration = 5.0
            
            record.accData = [(0,1),(1,2),(2,0),(3,5),(4,5),(5,3)]
            record.weather = .rainy
            RecordLog.shared.addRecord(record: record)
        }
    }
    
}
