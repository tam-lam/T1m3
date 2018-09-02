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
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var discardButton: UIButton!
    
    var dataHistory = Array(repeating: 0.0, count: Constants.maximumPlottablePoints)
    override func viewDidLoad() {
        super.viewDidLoad()
        measureAccInput()
        setupGraph()
        setupStopWatch()
        setupTableView()
        
    }
    @IBOutlet weak var simpleRecordsTable: UITableView!
    
    private enum Constants {
        static let maximumPlottablePoints = 20
        static let animationDuration = 1.0
    }

    @IBAction func startStopWatchButtonPress(_ sender: Any) {
        StopWatchController.shared.startStopWatchPressed()
    }
    
    @IBAction func saveButtonPress(_ sender: Any) {
        StopWatchController.shared.savePressed()
    }
    
    @IBAction func discardButtonPress(_ sender: Any) {
        StopWatchController.shared.discardPressed()
    }
    
    
    func changeElementVisiblity(newState: StopWatchState) {
        let newState = StopWatchController.shared.currentState
//        UIView.transition(with: chartView,
//                          duration: Constants.animationDuration,
//                          options: .transitionCrossDissolve,
//                          animations: {
//                            self.chartView.isHidden = newState != .default
//        },
//                          completion: nil)
//        UIView.transition(with: stopWatchTimeLabel,
//                          duration: Constants.animationDuration,
//                          options: .transitionCrossDissolve,
//                          animations: {
//                            self.stopWatchTimeLabel.isHidden = newState == .default
//        },
//                          completion: nil)
        self.chartView.isHidden = newState != .default
        self.stopWatchTimeLabel.isHidden = newState == .default
        self.saveButton.isHidden = newState != .paused
        self.discardButton.isHidden = newState != .paused
        
        startButton.setTitle(newState == .default ? "Start" : newState == .running ? "Pause" : "Resume" , for: .normal)
    }

}

extension StopWatchViewController: StopWatchListener {
    
    func setupStopWatch() {
        StopWatchController.shared.add(listener: self)
        StopWatchController.shared.currentState = .default
    }
    
    func stopWatchUpdate(elapsedTime: Double){
        self.stopWatchTimeLabel.text = Recording.toHumanReadable(elapsedTime: elapsedTime)
    }
    
    func stateChanged(newState: StopWatchState) {
        changeElementVisiblity(newState: newState)
        if newState == .default {
            refreshTable()
        }
    }
}


private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -5
    }
}

extension Double {
    func formatTimestamp(withFormat format: String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}

extension StopWatchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordLog.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recording = RecordLog.shared.records[indexPath.item]
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        
        let dateString = recording.timeStarted.formatTimestamp(withFormat: "MM-dd-yyyy")
        let hourString = recording.timeStarted.formatTimestamp(withFormat: "HH:mm")
        
        cell.textLabel?.text = dateString + " " + hourString
        cell.detailTextLabel?.text = Recording.toHumanReadable(elapsedTime: recording.finalRecordingElapsed)
        return cell
    }
    
    public func setupTableView() {
        simpleRecordsTable.delegate = self
        simpleRecordsTable.dataSource = self
        simpleRecordsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    public func refreshTable() {
        simpleRecordsTable.reloadData()
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
            AccelerometerManager.shared.getData { [weak self] data in
                self?.dataHistory.append(data)
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

class AccelerometerManager {
    public static let shared = AccelerometerManager()
    
    public func getData(data: @escaping (Double) -> (Void)) {
        CMMotionManager().startAccelerometerUpdates(to: OperationQueue.main) { (accData, error) in
            guard let acc = accData?.acceleration else { return }
            let absX = acc.x > 0 ? acc.x : acc.x * -1
            let absY = acc.y > 0 ? acc.y : acc.y * -1
            let absZ = acc.z > 0 ? acc.z : acc.z * -1
            let total = absX + absY + absZ
            
            data(total)
        }
    }
    
}
