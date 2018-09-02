//
//  RecordTableViewCell.swift
//  T1M3
//
//  Created by Bob on 9/2/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
import Charts
class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var graph: LineChartView!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(record: Recording) {
        self.name.text = record.timeStarted.formatTimestamp(withFormat: "HH-mm")
        self.location.text = "later"
        self.time.text = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
        self.weatherImage.image = record.weather.image
        setupGraph()
        updateData(data: fixData(data: record.accData))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // None
    }
    
    func setupGraph() {
        graph.xAxis.enabled = false
        graph.leftAxis.enabled = false
        graph.rightAxis.enabled = false
        graph.legend.enabled = false
        graph.chartDescription?.enabled = false
    }
    
    func fixData(data: [(x: Double, y: Double)]) -> [(x: Double, y: Double)] {
        var dataDictionary: [Double: [Double]] = [:]
        data.forEach { (dataPoint) in
            if var currentArray = dataDictionary[dataPoint.x] {
                currentArray.append(dataPoint.y)
                dataDictionary[dataPoint.x] = currentArray
            }
            else {
                dataDictionary[dataPoint.x] = [dataPoint.y]
            }
        }
        return dataDictionary.flatMap{ (x: $0.key, y: $0.value.first) as! ChartPoint  }.sorted(by: { (one, two) -> Bool in
            return one.x < two.x
        })    // Change to average if time
    }
    typealias ChartPoint = (x: Double, y: Double)
    
    func updateData(data: [(x: Double, y: Double)]) {
        let values = data.compactMap{ChartDataEntry.init(x: $0.x, y: $0.y)}
        let set = LineChartDataSet(values: values, label: "")
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
        graph.data = data
    }
}
