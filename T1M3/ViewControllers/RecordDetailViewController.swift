//
//  RecordDetailViewController.swift
//  T1M3
//
//  Created by Graphene on 7/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    
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

        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
