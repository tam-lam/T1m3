//
//  SettingsTableViewController.swift
//  T1M3
//
//  Created by Graphene on 9/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

   
    @IBAction func bgSwitchAction(_ sender: UISwitch) {
        if(sender.isOn == true){
            Settings.shared.switchToLightMode()
            let name = Notification.Name(rawValue: changeBGNotification)
            NotificationCenter.default.post(name: name, object: nil)
        }else{
            Settings.shared.switchToDarkMode()
            let name = Notification.Name(rawValue: changeBGNotification)
            NotificationCenter.default.post(name: name, object: nil)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
