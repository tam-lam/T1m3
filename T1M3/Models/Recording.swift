//
//  Recording.swift
//  T1M3
//
//  Created by Bob on 9/19/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import CoreLocation

public class Recording: NSObject {
    
    public static var dummyRecording: Recording = {
        let record = Recording()
        record.timeStarted = Date().timeIntervalSince1970
        record.editedDuration = 5.0
        record.accData = [(0,1),(1,2),(2,0),(3,5),(4,5),(5,3)]
        record.weather = .rainy
        return record
    }()
    
    public var timeStarted: Double = 0
    public var timeFinished: Double?
    public var pauseTimes: [(pauseTime: Double, resumeTime: Double)] = []
    public var accData: [(x: Double, y: Double)] = []
    public var weather: WeatherSituation = .cloudy
    private var accRecorder: AccelerometerManager? = AccelerometerManager()
    public var notes: String = ""
    public var editedDuration: Double?
    
    public func setNotes(notes: String){
        self.notes = notes
    }
    public func getNotes()->String{
        return self.notes
    }
    
    public var startLocation: CLLocation?
    public var endLocation: CLLocation?
    
    public var totalRecordingElapsed: Double {
        let intermissions = pauseTimes.reduce(0) { $0 + $1.resumeTime - $1.pauseTime }
        let total = ( Date().timeIntervalSince1970 - timeStarted) - intermissions
        return total
    }
    
    public var finalRecordingElapsed: Double {
        if let editedDuration = editedDuration {
            return editedDuration
        }
        let intermissions = pauseTimes.reduce(0) { $0 + $1.resumeTime - $1.pauseTime }
        let total = ( (pauseTimes.last?.pauseTime ?? 0.0) - timeStarted) - intermissions
        return total
    }
    
    public static func toHumanReadable(elapsedTime: Double) -> String {
        let decimalValue = Int((elapsedTime - Double(Int(elapsedTime))) * 100)
        return "\(Int(elapsedTime)):\(decimalValue >= 10 ? String(decimalValue) : "0\(decimalValue)")"
    }
    
    public func start() {
        timeStarted = Date().timeIntervalSince1970
        AccelerometerManager.shared.addReceiver(receiver: self)
        
        WeatherInformationManager().getWeatherInformation { [weak self] (weather) in
            self?.weather = weather
        }
        self.startLocation = LocationManager.shared.lastLocation
    }
    
    public func stopRecording() {
        timeFinished = Date().timeIntervalSince1970
        AccelerometerManager.shared.removeReceiver(receiver: self)
        accRecorder = nil
        self.endLocation = LocationManager.shared.lastLocation
    }
}

extension Recording: AccDataReceiver {
    public func newData(data: Double) {
        accData.append((x: Double(Int(Date().timeIntervalSince1970 - timeStarted)), y: data))
    }
}
