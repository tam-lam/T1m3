//
//  RecordDetailViewController.swift
//  T1M3
//
//  Created by Graphene on 7/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var notes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let record = RecordLog.shared.getSelectedRecord()
        self.updateDetail(record: record)
        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        self.sideTableView.reloadData()
    }
    
    func updateDetail(record: Recording){
        let dateString = record.timeStarted.formatTimestamp(withFormat: "MM-dd-yyyy")
        let timeString =  record.timeStarted.formatTimestamp(withFormat: "HH:mm")
        let durationString = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
        self.dateLbl.text = "\(dateString)"
        self.timeLbl.text = "Time: \(timeString)"
        self.durationLbl.text = "Duration: \(durationString)"
    }
}
extension RecordDetailViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordLog.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = RecordLog.shared.records[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideTableCell") as! SideTableCell
        cell.setup(record: record)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        selectedIndex = indexPath.row
        RecordLog.shared.setSelectedIndex(index: indexPath.row)
        let record = RecordLog.shared.getSelectedRecord()
        self.updateDetail(record: record)

    }
}
