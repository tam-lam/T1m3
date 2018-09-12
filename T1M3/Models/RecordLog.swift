//
//  RecordLog.swift
//  T1M3
//
//  Created by Bob on 8/29/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation

class RecordLog {
    var selectedIndex : Int
    public  static let shared = RecordLog()
    
    private init(){
        self.selectedIndex = 0
    }
    public private(set) var records: [Recording] = []
    
    public func addRecord(record: Recording) {
        records.append(record)
    }
    public func addRecordAtIndex(record: Recording, destinationIndex: Int){
        records.insert(record, at: destinationIndex)
    }
    public func removeRecord(index: Int){
        if records.indices.contains(index){
            records.remove(at: index)
        }
    }
    public func getSelectedIndex() ->Int {
        return selectedIndex
    }
    public func setSelectedIndex(index:Int){
        self.selectedIndex = index
    }
    public func getSelectedRecord() ->Recording {
        let record = RecordLog.shared.records[selectedIndex]
        return record
    }
    public func deleteSelectedRecord(){
        records.remove(at: selectedIndex)
    }
    
    public func replaceRecord(record: Recording, index: Int) {
        records[index] = record
    }
}
