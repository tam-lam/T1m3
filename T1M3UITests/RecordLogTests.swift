//
//  RecordLogTests.swift
//  T1M3UITests
//
//  Created by Bob on 9/16/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest

class RecordLogTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecordLogTable() {
        let app = XCUIApplication()
        app.buttons["Start"].tap()
        app.buttons["Pause"].tap()
        app.buttons["Save"].tap()
        
        app.tabBars.buttons["Records"].tap()
        app.buttons["Edit"].tap()
        
        let table = app.tables.firstMatch
        let firstRow = table.cells.firstMatch
        XCTAssert(firstRow.exists)
    }

}
