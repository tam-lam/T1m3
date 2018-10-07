//
//  StopWatchTest.swift
//  T1M3UITests
//
//  Created by Bob on 9/15/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest

class StopWatchTest: XCTestCase {
        
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
    
//    func testExample() {
    func testStopWatchButtons() {
        
        let app = XCUIApplication()
        let startButton = app.buttons["Start"]
        startButton.tap()
        
        let pauseButton = app.buttons["Pause"]
        XCTAssert(!startButton.exists)
        pauseButton.tap()
        
        let resumeButton = app.buttons["Resume"]
        XCTAssert(!pauseButton.exists)
        resumeButton.tap()
        pauseButton.tap()
        resumeButton.tap()
        pauseButton.tap()
        resumeButton.tap()
        pauseButton.tap()
        resumeButton.tap()
        pauseButton.tap()
        resumeButton.tap()
        pauseButton.tap()
        app.buttons["Save"].tap()
        XCTAssert(!resumeButton.exists)
        startButton.tap()
        pauseButton.tap()
        app.buttons["Discard"].tap()
        
    }
    
    func testRecordSaving() {
        let app = XCUIApplication()
        
        let startButton = app.buttons["Start"]
        startButton.tap()
        
        let pauseButton = app.buttons["Pause"]
        pauseButton.tap()
        app.buttons["Save"].tap()

        startButton.tap()
        pauseButton.tap()
        app.buttons["Discard"].tap()
        
        XCTAssert(app.tables.firstMatch.cells.count >= 1)
        
    }
    
}
