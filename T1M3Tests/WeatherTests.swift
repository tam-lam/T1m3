//
//  WeatherTests.swift
//  T1M3Tests
//
//  Created by Bob on 10/7/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest
//import T1M3

@testable import T1M3

class WeatherTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWeatherEnumCreateFromShortcut() {
        let options =  ["sn", "sl", "h", "t", "hr", "lr", "s", "hc", "lc", "c"]
        assert(options.flatMap{WeatherSituation.weatherFromShortcut($0)}.count == options.count)
    }
    
    func testWeather() {
        let totalWeatherOptions = [0,1,2,3,4,5]
        assert(totalWeatherOptions.flatMap{WeatherSituation.init(rawValue: $0)}.count == totalWeatherOptions.count)
    }
    
}
