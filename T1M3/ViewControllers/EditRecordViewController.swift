//
//  EditRecordViewController.swift
//  T1M3
//
//  Created by Graphene on 9/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class EditRecordViewController: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let record = RecordLog.shared.getSelectedRecord()
        loadRecord(record: record)
        setupInputPickers()
        setupEndEditingOnTap()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Setup date and time keyboard inputs for date and time field
    func setupInputPickers(){
        var datePicker = UIDatePicker()
        var timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        datePicker.addTarget(self, action: #selector(EditRecordViewController.dateChanged(datePicker:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(EditRecordViewController.timeChanged(timePicker:)), for: .valueChanged)
        
    }
    
    //close keyboard on tap
    func setupEndEditingOnTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditRecordViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //get date and time value from pickers
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM-dd-yyyy"
        self.dateTextField.text = dateFormater.string(from: datePicker.date)
        view.endEditing(true)
    }
    @objc func timeChanged(timePicker: UIDatePicker){
        let timeFormater = DateFormatter()
        timeFormater.dateFormat = "HH:mm"
        self.timeTextField.text = timeFormater.string(from: timePicker.date)
        view.endEditing(true)
    }
    
    //quit editing mode on tap
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
    }
    func loadRecord(record: Recording){
        self.dateTextField.text = record.timeStarted.formatTimestamp(withFormat: "MM-dd-yyyy")
        self.timeTextField.text = record.timeStarted.formatTimestamp(withFormat: "HH:mm")
        self.durationTextField.text = Recording.toHumanReadable(elapsedTime: record.finalRecordingElapsed)
        self.noteTextField.text = record.getNotes()
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
