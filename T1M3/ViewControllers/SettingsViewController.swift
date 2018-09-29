//
//  SettingsViewController.swift
//  T1M3
//
//  Created by Graphene on 7/9/18.
//  Copyright © 2018 Bob. All rights reserved.
//

import UIKit
let changeBGNotification = "darkModeNotification"

class SettingsViewController: UIViewController {

    let changeBGNotificationName = Notification.Name(rawValue: changeBGNotification)
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBOutlet weak var bgImageView: UIImageView!
//    override func viewWillAppear(_ animated: Bool) {
//        createObserver()
//    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        bgImageView.image = Settings.shared.getBgImage()
        createObserver()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        bgImageView.image = Settings.shared.getBgImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func createObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(SettingsViewController.updateBg(notification:)), name: changeBGNotificationName, object: nil)
    }
    @objc func updateBg(notification: NSNotification){
        bgImageView.image = Settings.shared.getBgImage()
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
