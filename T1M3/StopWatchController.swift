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
    func stopWatchStopped(finalTime: Double)
    func stopWatchPaused(currentTime: Double)
    func stateChanged(newState: StopWatchState)
}

public struct Recording {
    
    public var timeStarted: Double = Date().timeIntervalSince1970
    public var pauseTimes: [(pauseTime: Double, resumeTime: Double)] = []
    
    public var getTotalRecordingElapsed: Double {
        var total = Date().timeIntervalSince1970 - timeStarted
        return total
    }
    
}


/// Singleton StopWatchController
public class StopWatchController {

    static let shared = StopWatchController()
    
    private var recording: Recording = Recording()
    
    private var listeners: [StopWatchListener] = []
    
    public var currentState: StopWatchState = .default {
        didSet {
            switch currentState {
            case .default:
                recording = Recording()
            case .paused:
                recording.pauseTimes.append((pauseTime: Date().timeIntervalSince1970,
                                             resumeTime: Date().timeIntervalSince1970))
            case .running:
                recording.timeStarted = Date().timeIntervalSince1970
                if var pauseRecord = recording.pauseTimes.last {
                    pauseRecord.resumeTime = Date().timeIntervalSince1970
                    _ = recording.pauseTimes.popLast()
                    recording.pauseTimes.append(pauseRecord)
                }
                resumeTimer()
            }
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
            self?.listeners.forEach { $0.stopWatchUpdate(elapsedTime: strongSelf.recording.getTotalRecordingElapsed) }
        }
    }
    private init(){ }

}
