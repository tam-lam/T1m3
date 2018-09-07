//
//  RecordLog.swift
//  T1M3
//
//  Created by Bob on 8/29/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation

class RecordLog {
    public  static let shared = RecordLog()
    
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
        
}
