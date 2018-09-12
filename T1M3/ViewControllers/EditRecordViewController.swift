//
//  EditRecordViewController.swift
//  T1M3
//
//  Created by Graphene on 9/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class EditRecordViewController: UIViewController {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let record = RecordLog.shared.getSelectedRecord()
        loadRecord(record: record)
        setupKeyboardInputForFields()
        setupEndEditingOnTap()
        setupBg()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupBg()
    }
    func saveRecord(alert: UIAlertAction){
        let dateString = dateTextField.text
        let timeString = timeTextField.text
        
        let notesString = noteTextField.text
        
        
        let durationString = durationTextField.text
        let durationParts = durationString?.components(separatedBy: ":")
        let secondsDuration = ((durationParts?.first ?? "0") as NSString).doubleValue
        let miliSecondDuration = (((durationParts?.last ?? "0") as NSString).doubleValue ) / 100
        
        
        let record = RecordLog.shared.getSelectedRecord()
        record.editedDuration = secondsDuration + miliSecondDuration
        
        RecordLog.shared.replaceRecord(record: record, index: RecordLog.shared.getSelectedIndex())
        self.navigationController?.popViewController(animated: true)
        
        //TODO//
        //save//
        //segue//
    }
    func deleteRecord(alert:UIAlertAction){
        RecordLog.shared.deleteSelectedRecord()
        //go back to Records table view
        self.navigationController?.popToRootViewController(animated: true)
    }
    func setupBg(){
        self.bgImageView.image = Settings.shared.getBgImage()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "T1m3.", message: "Are you sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Save", style:.default, handler: self.saveRecord))
        alertController.addAction(UIAlertAction(title:"Cancel",style: .default, handler:nil))
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func deleteBtnAction(_ sender: Any) {
        let alertController = UIAlertController(title: "T1m3.", message: "Are you sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style:.destructive, handler: self.deleteRecord))
        alertController.addAction(UIAlertAction(title:"Cancel",style: .default, handler:nil))
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    //Setup date and time picker keyboard inputs for date and time field
    //Setup duration input to be number pad
    func setupKeyboardInputForFields(){
        var datePicker = UIDatePicker()
        var timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        timeTextField.inputView = timePicker
        durationTextField.keyboardType = UIKeyboardType.numberPad
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

}
