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
    case resumed
    
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


/// Singleton StopWatchController
public class StopWatchController {
    static let shared = StopWatchController()
    
    private var timeStarted: Double = Date().timeIntervalSince1970
    
    private var listeners: [StopWatchListener] = []
    
    public var currentState: StopWatchState = .default {
        didSet {
            switch currentState {
            case .default:
                ()
                // Close existing recording
            case .paused:
                ()
                // Probably do nothing
            case .running:
                timeStarted = Date().timeIntervalSince1970
                resumeTimer()
            case .resumed:
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
            guard self?.currentState == .running || self?.currentState == .resumed else  { return }
            self?.listeners.forEach { $0.stopWatchUpdate(elapsedTime: Date().timeIntervalSince1970 - self!.timeStarted) }
        }
    }
    private init(){ }

}
