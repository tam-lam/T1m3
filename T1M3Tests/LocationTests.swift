//
//  LocationTest.swift
//  T1M3Tests
//
//  Created by Bob on 10/7/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import XCTest
@testable import T1M3
import MapKit

class LocationTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGeocoding() {
        
        let expectation = XCTestExpectation(description: "Geocode coordinates")
        
        let location = CLLocation(latitude: CLLocationDegrees.init(-37.8136), longitude: CLLocationDegrees(144.9631))
        
        LocationManager.shared.geocode(location.coordinate) { (location) -> (Void) in
            XCTAssert(location == "Melbourne")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 8.0)
    }
    
}
