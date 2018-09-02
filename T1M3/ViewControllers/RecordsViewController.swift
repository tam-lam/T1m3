//
//  RecordsViewController.swift
//  T1M3
//
//  Created by Bob on 9/2/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import Foundation
import UIKit

class RecordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "Records"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}

extension RecordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordLog.shared.records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let record = RecordLog.shared.records[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell") as? RecordTableViewCell {
            cell.setup(record: record)
            return cell
        }
        return UITableViewCell()
    }
}
