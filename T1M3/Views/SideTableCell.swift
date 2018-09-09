//
//  SideTableCell.swift
//  T1M3
//
//  Created by Graphene on 9/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class SideTableCell: UITableViewCell {

    
    @IBOutlet weak var durationLbl: UILabel!
    func setup(record: Recording) {
        self.durationLbl.text = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
    }
}
