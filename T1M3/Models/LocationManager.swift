//
//  LocationManager.swift
//  T1M3
//
//  Created by Bob on 9/5/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    // Just setting a default location for testing, otherwise picks up location from device/simulator
    public var lastLocation: CLLocation! = CLLocation(latitude: CLLocationDegrees.init(-37.8136), longitude: CLLocationDegrees(144.9631))
    
    override init() {
        // For use in foreground
        super.init()
        self.locationManager.requestWhenInUseAuthorization()
        self.startReceivingLocationChanges()
    }
    
    // Following method taken from https://developer.apple.com/documentation/corelocation/getting_the_user_s_location/using_the_standard_location_service
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startReceivingLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else  { return }
        self.lastLocation = location
    }
}
