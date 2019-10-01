//
//  SettingsNotificationsTableViewController.swift
//  Advocates
//
//  Created by Mike James on 09/08/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

import AppCenterPush

class SettingsNotificationsTableViewController : UITableViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        
        let notificationsEnabled = MSPush.isEnabled()
        if(notificationsEnabled == true){
            notificationsSwitch.isOn = true

        } else {
            notificationsSwitch.isOn = false
        }
    }
    
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    @IBAction func notificationsSwitchedChanged() {
        MSPush.setEnabled(notificationsSwitch.isOn)
    }
    
}
