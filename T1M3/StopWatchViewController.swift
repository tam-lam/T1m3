//
//  StopWatchViewController.swift
//  T1M3
//
//  Created by Bob on 8/26/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import CoreMotion
import Charts


class StopWatchViewController: UIViewController {
    
    @IBOutlet weak var stopWatchTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    
    var dataHistory = Array(repeating: 0.0, count: Constants.maximumPlottablePoints)
    override func viewDidLoad() {
        super.viewDidLoad()
        measureAccInput()
        setupGraph()
        setupStopWatch()
        
    }
    
    private enum Constants {
        static let maximumPlottablePoints = 20
    }

    @IBAction func startStopWatchButtonPress(_ sender: Any) {
        startStopWatch()
    }
    
    func changeElementVisiblity() {
        let newState = StopWatchController.shared.currentState
        UIView.animate(withDuration: 2) {
            switch newState {
            case .resumed,.running,.paused:
                self.chartView.isHidden = true
                self.chartView.alpha = 0
                self.stopWatchTimeLabel.isHidden = false
                self.stopWatchTimeLabel.alpha = 1
            case .default:
                self.chartView.isHidden = false
                self.chartView.alpha = 1
                self.stopWatchTimeLabel.isHidden = true
                self.stopWatchTimeLabel.alpha = 1
            }
        }
    }

}


// MARK: - Control states of stopwatch
extension StopWatchViewController {
    func startStopWatch() {
        StopWatchController.shared.currentState = .running
    }
    
    func pauseStopWatch() {
        changeElementVisiblity()
        StopWatchController.shared.currentState = .paused
    }
    
    func stopStopWatch() {
        changeElementVisiblity()
        StopWatchController.shared.currentState = .default
    }
}

extension StopWatchViewController: StopWatchListener {
    
    func setupStopWatch() {
        StopWatchController.shared.add(listener: self)
        StopWatchController.shared.currentState = .default
    }
    
    func stopWatchUpdate(elapsedTime: Double){
        let decimalValue = Int((elapsedTime - Double(Int(elapsedTime))) * 100)
        self.stopWatchTimeLabel.text = "\(Int(elapsedTime)):\(decimalValue >= 10 ? String(decimalValue) : "0\(decimalValue)")"
    }
    
    func stopWatchStopped(finalTime: Double) {
        // Stop the stopwatch and save the record
    }
    func stopWatchPaused(currentTime: Double) {
        // Pause the stopWatch and do something with the current time
    }
    
    func stateChanged(newState: StopWatchState) {
        changeElementVisiblity()
    }
}


private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}


// MARK: - Accelerometer input
extension StopWatchViewController {
    
    func measureAccInput(){
        // Unfortunately accelerometer doesn't work on simulator, so we simulate the effect using timers and random number generation
        #if targetEnvironment(simulator)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] (timer) in
            let val = Double(arc4random_uniform(20) + 20)
            self?.dataHistory.append(val)
            if (self?.dataHistory.count)! > Constants.maximumPlottablePoints {
                self?.dataHistory.remove(at: 0)
            }
            self?.updateData()
        }
        #else
        CMMotionManager().startAccelerometerUpdates(to: OperationQueue.main) { [weak self](accData, error) in
            guard let acc = accData?.acceleration else { return }
            let absX = acc.x > 0 ? acc.x : acc.x * -1
            let absY = acc.y > 0 ? acc.y : acc.y * -1
            let absZ = acc.z > 0 ? acc.z : acc.z * -1
            
            self?.dataHistory.append(absX + absY + absZ)
            if (self?.dataHistory.count)! > Constants.maximumPlottablePoints {
                self?.dataHistory.remove(at: 0)
            }
            
            self?.updateData()
        }
        #endif
    }
    
    func setupGraph() {
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
    }
    
    func updateData() {
        let count = dataHistory.count
        var range: UInt32 = 20
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: dataHistory[i])
        }
        let set = LineChartDataSet(values: yVals1, label: "")
        set.mode = .cubicBezier
        set.drawCirclesEnabled = false
        set.lineWidth = 1.8
        set.circleRadius = 4
        set.setCircleColor(.white)
        set.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set.fillColor = .blue
        set.fillAlpha = 0
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.fillFormatter = CubicLineSampleFillFormatter()
        
        let data = LineChartData(dataSet: set)
        
        data.setDrawValues(false)
        chartView.data = data
    }
}
