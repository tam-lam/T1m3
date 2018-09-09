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
        let dateString = record.timeStarted.formatTimestamp(withFormat: "MM-dd-yyyy")
        let timeString =  record.timeStarted.formatTimestamp(withFormat: "HH:mm")
        let durationString = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
        self.dateLbl.text = "\(dateString)"
        self.timeLbl.text = "Time: \(timeString)"
        self.durationLbl.text = "Duration: \(durationString)"
        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
//        self.sideTableView.register(UINib(nibName: "SideTableCell", bundle: nil), forCellReuseIdentifier: "SideTableCell")
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.sideTableView.reloadData()
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
    
    
}
