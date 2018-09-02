//
//  RecordTableViewCell.swift
//  T1M3
//
//  Created by Bob on 9/2/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var time: UILabel!
    
    
    @IBOutlet weak var graph: UIView!
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        // None
    }
    
}
