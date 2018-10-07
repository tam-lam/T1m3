//
//  RecordingTests.swift
//  RecordingTests
//
//  Created by Bob on 10/7/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest
import T1M3

class RecordingTests: XCTestCase {
    let record = Recording()
    
    override func setUp() {
        super.setUp()
        record.start()
        record.stopRecording()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecording() {
        assert(record.timeStarted != 0)
        assert(record.totalRecordingElapsed > 0)
    }
    
    func testLocationRecording() {
        assert(record.startLocation != nil)
        assert(record.endLocation != nil)
    }
    
    func testNotes() {
        let text = "Leaving a note"
        record.setNotes(notes: text)
        assert(record.getNotes() == text)
    }
    
    func testEditingDuration() {
        record.editedDuration = 50.0
        assert(record.finalRecordingElapsed == 50.0)
    }
    
    func testste(){
        record.newData(data: 5.0)
        assert(record.accData.count == 1)
        assert(record.accData.first?.y == 5.0)
    }
    
    
    
    
    
}
