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
    @IBOutlet weak var btnGroupBG: UIView!
    
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

        self.chartView.isHidden = newState != .default
//        self.stopWatchTimeLabel.isHidden = newState == .default
        self.saveButton.isHidden = newState != .paused
        self.discardButton.isHidden = newState != .paused
        
        startButton.setTitle(newState == .default ? "Start" : newState == .running ? "Pause" : "Resume" , for: .normal)
        changeStopwatchBtnColor()
    }
    func changeStopwatchBtnColor(){
        let newState = StopWatchController.shared.currentState
        if newState == .running
        {
            startButton.backgroundColor = UIColor.red
            self.btnGroupBG.isHidden = true


        }
        if newState == .paused
        {
            startButton.backgroundColor = UIColor.green
            self.btnGroupBG.isHidden = false

            
        }
        if newState == .default
        {
            startButton.backgroundColor = UIColor(red: 155.0/255.0, green: 45.0/255.0, blue: 255.0/255.0, alpha: 1.0)
            self.btnGroupBG.isHidden = true
        }
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


public class CubicLineSampleFillFormatter: IFillFormatter {
    public func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
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
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        tableView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        tableView.tableFooterView = UIView()
        

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
extension StopWatchViewController: AccDataReceiver {
    
    func newData(data: Double) {
        self.dataHistory.append(data)
        if (self.dataHistory.count) > Constants.maximumPlottablePoints {
            self.dataHistory.remove(at: 0)
        }
        self.updateData()
    }
    
    
    
    func measureAccInput(){
        AccelerometerManager.shared.addReceiver(receiver: self)
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

public protocol AccDataReceiver {
    
    func newData(data: Double)

}
class AccelerometerManager {
    public static let shared = AccelerometerManager()
    
    private var receivers: [AccDataReceiver] = []
    public func addReceiver(receiver: AccDataReceiver) {
        receivers.append(receiver)
    }
    public func removeReceiver(receiver: AccDataReceiver) {
        let index = receivers.index { (receiverX: AccDataReceiver) -> Bool in
            return (receiverX as AnyObject === receiver as AnyObject)
        }
        if let index = index {
            receivers.remove(at: index)
        }
    }
    
    init() {
        #if targetEnvironment(simulator)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            let val = Double(arc4random_uniform(20) + 20)
            _ = self.receivers.compactMap{$0.newData(data: val)}
        }
        #else
        CMMotionManager().startAccelerometerUpdates(to: OperationQueue.main) { (accData, error) in
            guard let acc = accData?.acceleration else { return }
            let absX = acc.x > 0 ? acc.x : acc.x * -1
            let absY = acc.y > 0 ? acc.y : acc.y * -1
            let absZ = acc.z > 0 ? acc.z : acc.z * -1
            let total = absX + absY + absZ
            receivers.flatMap{$0.newData(data: val)}
        }
        #endif
    
    }
    
}
