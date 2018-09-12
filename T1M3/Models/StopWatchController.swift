//
//  StopWatchController.swift
//  T1M3
//
//  Created by Bob on 8/27/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

public enum StopWatchState {
    case `default`
    case running
    case paused
    public init() {
        self = .default
    }
}

public protocol StopWatchListener {
    func stopWatchUpdate(elapsedTime: Double)
    func stateChanged(newState: StopWatchState)
}

public class Recording {
    
    public static var dummyRecording: Recording = {
        let record = Recording()
        record.timeStarted = Date().timeIntervalSince1970
        record.timeFinished = record.timeStarted + 50
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
    }
    
    public func stopRecording() {
        timeFinished = Date().timeIntervalSince1970
        AccelerometerManager.shared.removeReceiver(receiver: self)
        accRecorder = nil
    }
}

extension Recording: AccDataReceiver {
    public func newData(data: Double) {
        accData.append((x: Double(Int(Date().timeIntervalSince1970 - timeStarted)), y: data))
    }
    
    
}


/// Singleton StopWatchController
public class StopWatchController {

    static let shared = StopWatchController()
    
    private var recording: Recording = Recording()
    
    private var listeners: [StopWatchListener] = []
    
    public var currentState: StopWatchState = .default {
        didSet {
            listeners.forEach{ $0.stateChanged(newState: currentState )}
        }
    }
    public func add(listener: StopWatchListener) {
        listeners.append(listener)
    }

    private func resumeTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] (timer) in
            guard let strongSelf = self else { return }
            guard self?.currentState == .running  else  { return }
            self?.listeners.forEach { $0.stopWatchUpdate(elapsedTime: strongSelf.recording.totalRecordingElapsed) }
        }
    }
    
    func resetStopWatch() {
        recording.stopRecording()
        recording = Recording()
        currentState = .default
    }
    
    func pauseStopWatch() {
        recording.pauseTimes.append((pauseTime: Date().timeIntervalSince1970,
                                     resumeTime: Date().timeIntervalSince1970))
        currentState = .paused
    }
    
    func runStopWatch() {
        recording.start()
        recording.timeStarted = Date().timeIntervalSince1970

        resumeTimer()
        currentState = .running
    }
    
    func resumeStopWatch() {
        if var pauseRecord = recording.pauseTimes.last {
            pauseRecord.resumeTime = Date().timeIntervalSince1970
            _ = recording.pauseTimes.popLast()
            recording.pauseTimes.append(pauseRecord)
        }
        currentState = .running
    }
    
    private init(){ }

}

// MARK: - Control states of stopwatch
extension StopWatchController {
    
    func startStopWatchPressed() {
        switch StopWatchController.shared.currentState {
        case .default:
            runStopWatch()
        case .running:
            pauseStopWatch()
        case .paused:
            resumeStopWatch()
        }
    }
    
    func savePressed() {
        // Save to presistant
        RecordLog.shared.addRecord(record: recording)
        resetStopWatch()
    }
    
    func discardPressed() {
        resetStopWatch()
    }
    
}

