import Foundation
import CoreData
import UIKit
let appDelegate = UIApplication.shared.delegate as? AppDelegate

protocol CoreDataFuncs {
    
}
//Core data function related extension
//To use these funcs in a class : conform to the protocol with the same name
extension CoreDataFuncs{
    
    //Modify 2 functions bellow to when adding extra attributes to Record model
    func convertRecordToCDRecord(record: Recording, managedContext: NSManagedObjectContext) -> CoreDataRecord{
        let cdRecord = CoreDataRecord(context: managedContext)
        cdRecord.notes = record.notes
        if(record.finalRecordingElapsed != 0){
            cdRecord.editedDuration = record.finalRecordingElapsed
        } else{
            cdRecord.editedDuration = record.editedDuration!
        }
        cdRecord.timeStarted = record.timeStarted
        cdRecord.rawWeatherValue = Int16(record.weather.rawValue)
        return cdRecord
    }
    func convertCDRecordToRecord(cdRecord: CoreDataRecord) -> Recording{
        let record = Recording()
        record.notes = cdRecord.notes!
        record.editedDuration = cdRecord.editedDuration
        record.timeStarted = cdRecord.timeStarted
        record.weather = cdRecord.weather!
//        debugPrint("cd Record Weather: \(cdRecord.weather)")
        //placeholer data
        record.accData = [(0,1),(1,2),(2,0),(3,5),(4,5),(5,3)]
        return record
    }
    
    
    //Add individual record to CoreData Record log
    func addToCoreData(record: Recording){
        guard let managedContext =  appDelegate?.persistentContainer.viewContext else { return }
        let cdRecord = convertRecordToCDRecord(record: record, managedContext: managedContext)
        do{
            try managedContext.save()
        }catch{
            debugPrint("Could not save record")
        }
    }
    
    //load all records from Core Data to Singleton Record Log
    func loadRecordLogToSingleton(){
        RecordLog.shared.removeAllRecords()
        let cdRecordLogs:[CoreDataRecord] = fetchRecordsFromCoreData()
        for cdRecord in cdRecordLogs {
            let record = convertCDRecordToRecord(cdRecord: cdRecord)
//            RecordLog.shared.addRecord(record: record)
            RecordLog.shared.addRecordOnlyToSingleton(record: record)
        }
    }
    
    // Retrive CoreData Record log
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
    //save all records which currently in Singleton to Coredata record log
    func saveAll(recordLog: [Recording]){
        debugPrint("Saving all records to Core Data..........")
        self.deleteAll()
        for record in recordLog{
            addToCoreData(record: record)
        }
    }
    //wipe coredata record log
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
    func deleteCDRecord(index: Int){
        var recordLogs: [CoreDataRecord] = []
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{return}
        let fetchRequest: NSFetchRequest<CoreDataRecord> = CoreDataRecord.fetchRequest()
        do{
            recordLogs = try managedContext.fetch(fetchRequest)
            managedContext.delete(recordLogs[index])
            try managedContext.save()
        } catch{
            debugPrint("Cannot delete CoreDateRecord")
        }
    }
}
extension UIViewController: DataModelDelegate, CoreDataFuncs{
    func didReceiveAddedRecord(record: Recording) {
        debugPrint("Recieve Record: \(record.timeStarted)")
        self.addToCoreData(record: record)
    }
    func didRecordsVCRecieveDeleteIndex(index: Int) {
        self.deleteCDRecord(index: index)
    }
    func didDetailVCRecieveDeleteIndex(index: Int) {
        self.deleteCDRecord(index: index)
    }
}
