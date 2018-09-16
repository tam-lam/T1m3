//
//  RecordedTest.swift
//  T1M3UITests
//
//  Created by Bob on 9/16/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest

class RecordedTest: XCTestCase {
        
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
    
    func testUserAccessingVariousFeatures() {
        
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Records"].tap()
        tabBarsQuery.buttons["Settings"].tap()
        
        let app = XCUIApplication()
        let recordsButton = tabBarsQuery.buttons["Records"]
        recordsButton.tap()
        
        let stopwatchButton = tabBarsQuery.buttons["Stopwatch"]
        stopwatchButton.tap()
        
        let startButton = app.buttons["Start"]
        startButton.tap()
        
        let pauseButton = app.buttons["Pause"]
        pauseButton.tap()
        
        app.buttons["Discard"].tap()
        startButton.tap()
        pauseButton.tap()
        
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        recordsButton.tap()
        stopwatchButton.tap()
        startButton.tap()
        pauseButton.tap()
        saveButton.tap()
        startButton.tap()
        pauseButton.tap()
        saveButton.tap()
        startButton.tap()
        pauseButton.tap()
        saveButton.tap()
        recordsButton.tap()
        stopwatchButton.tap()
        startButton.tap()
        pauseButton.tap()
        app.buttons["Resume"].tap()
        pauseButton.tap()
        saveButton.tap()
        recordsButton.tap()
        app.buttons["Edit"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
