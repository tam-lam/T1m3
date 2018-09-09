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
            
        }else{
            Settings.shared.switchToDarkMode()
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
