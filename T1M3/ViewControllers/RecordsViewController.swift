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
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func editAction(_ sender: UIButton) {
        self.tableView.isEditing = !self.tableView.isEditing
        if (self.tableView.isEditing){
            sender.setTitle("Done", for: .normal)
        } else{
            sender.setTitle("Edit", for: .normal)
        }
    }
    
    override func viewDidLoad() {
//        self.title = "Records"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        setupBg()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        setupBg()
    }
    
    func setupBg(){
        self.bgImageView.image = Settings.shared.getBgImage()
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
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.2)
            cell.selectedBackgroundView = backgroundView
            return cell
        }
        return UITableViewCell()
    }
    
    //Ediding mode - swaping row
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let recordIndex = sourceIndexPath.row
        let destinationIndex = destinationIndexPath.row
        let record = RecordLog.shared.records[recordIndex]
        RecordLog.shared.removeRecord(index: recordIndex)
        RecordLog.shared.addRecordAtIndex(record: record, destinationIndex: destinationIndex)
    }
    //Editing mode - delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            RecordLog.shared.removeRecord(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RecordLog.shared.setSelectedIndex(index: indexPath.row)
        performSegue(withIdentifier: "recordDetailSegue", sender: self)
    }
}
