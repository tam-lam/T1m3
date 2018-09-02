//
//  StopWatchController.swift
//  T1M3
//
//  Created by Bob on 8/27/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation

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
    
    public var timeStarted: Double = 0
    public var timeFinished: Double?
    public var pauseTimes: [(pauseTime: Double, resumeTime: Double)] = []
    public var accData: [(x: Double, y: Double)] = []
    public var weather: WeatherSituation = .cloudy
    
    public var totalRecordingElapsed: Double {
        let intermissions = pauseTimes.reduce(0) { $0 + $1.resumeTime - $1.pauseTime }
        let total = ( Date().timeIntervalSince1970 - timeStarted) - intermissions
        return total
    }
    
    public var finalRecordingElapsed: Double {
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
        AccelerometerManager.shared.getData { [weak self] (data) -> (Void) in
            guard let strongself = self else { return }
            strongself.accData.append((x: Date().timeIntervalSince1970 - strongself.timeStarted, y: data))
        }
        
        WeatherInformationManager().getWeatherInformation { [weak self] (weather) in
            self?.weather = weather
        }
    }
    
    public func stopRecording() {
        timeFinished = Date().timeIntervalSince1970
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
        recording = Recording()
        currentState = .default
    }
    
    func pauseStopWatch() {
        recording.pauseTimes.append((pauseTime: Date().timeIntervalSince1970,
                                     resumeTime: Date().timeIntervalSince1970))
        currentState = .paused
    }
    
    func runStopWatch() {
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

