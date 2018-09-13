//
//  RecordDetailViewController.swift
//  T1M3
//
//  Created by Graphene on 7/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var sideTableView: UITableView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var notes: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
        setupBg()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let record = RecordLog.shared.getSelectedRecord()
        self.updateDetail(record: record)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.sideTableView.reloadData()
        setupBg()
    }
    func setupBg(){
        self.bgImageView.image = Settings.shared.getBgImage()
    }
    func updateDetail(record: Recording){
        let dateString = record.timeStarted.formatTimestamp(withFormat: "MM-dd-yyyy")
        let timeString =  record.timeStarted.formatTimestamp(withFormat: "HH:mm")
        let durationString = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
        self.dateLbl.text = "Date: \(dateString)"
        self.timeLbl.text = "Time: \(timeString)"
        self.durationLbl.text = "Duration: \(durationString)"
        let notesString = (record.getNotes() == "") ? "This record doesn't have any notes ": record.getNotes()
        self.notes.text = notesString

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
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        selectedIndex = indexPath.row
        RecordLog.shared.setSelectedIndex(index: indexPath.row)
        let record = RecordLog.shared.getSelectedRecord()
        self.updateDetail(record: record)

    }
}
