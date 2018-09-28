import Foundation
import CoreData
import UIKit
let appDelegate = UIApplication.shared.delegate as? AppDelegate

protocol CoreDataFuncs {
    
}
//Core data function related extension
extension CoreDataFuncs{
    
    //Add a record to CoreData
    func addToCoreData(record: Recording){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let cdRecord = convertRecordToCDRecord(record: record, managedContext: managedContext)
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not save record")
        }
    }
    
    func convertRecordToCDRecord(record: Recording, managedContext: NSManagedObjectContext) -> CoreDataRecord{
        let cdRecord = CoreDataRecord(context: managedContext)
        cdRecord.notes = record.notes
        if(record.finalRecordingElapsed != 0){
            cdRecord.editedDuration = record.finalRecordingElapsed
        } else{
            cdRecord.editedDuration = record.editedDuration!
        }
        cdRecord.timeStarted = record.timeStarted
        
        return cdRecord
    }
    func convertCDRecordToRecord(cdRecord: CoreDataRecord) -> Recording{
        let record = Recording()
        record.notes = cdRecord.notes!
        record.editedDuration = cdRecord.editedDuration
        record.timeStarted = cdRecord.timeStarted

        //placeholer data
//        record.timeStarted = Date().timeIntervalSince1970
        record.accData = [(0,1),(1,2),(2,0),(3,5),(4,5),(5,3)]
        record.weather = .rainy
        return record
    }
    //load all records from Core Data to singleton Record Log
    func loadRecordLogToSingleton(){
        RecordLog.shared.removeAllRecords()
        let cdRecordLogs:[CoreDataRecord] = fetchRecordsFromCoreData()
        for cdRecord in cdRecordLogs {
            let record = convertCDRecordToRecord(cdRecord: cdRecord)
            RecordLog.shared.addRecord(record: record)
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
    

}
