//
//  SettingsGeneralTableViewController.swift
//  Advocates
//
//  Created by Michael James on 26/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class SettingsGeneralTableViewController : UITableViewController {
    
    let settingsService = SettingsService()
    
    override func viewDidLoad() {
        largeContentModeSwitch.isOn = self.settingsService.useLargeContentMode()
        blogPostReaderModeSwitch.isOn = self.settingsService.readerModeEnabled()
        spotlightIndexSwitch.isOn = self.settingsService.spotlightIntegrationEnabled()

    }
    
    
    @IBAction func spotlightIndexSwitchedChanged(_ sender: Any) {
        self.settingsService.setSpotlightIntegrationEnabled(value: spotlightIndexSwitch.isOn)
    }
    
    @IBAction func largeContentModeSwitchedChanged(_ sender: Any) {
        self.settingsService.setUpdateContentMode(value: largeContentModeSwitch.isOn)
    }
    
    @IBAction func blogPostReaderModeSwitchChanged(_ sender: Any) {
        self.settingsService.setReaderModeEnabled(value: blogPostReaderModeSwitch.isOn)
    }
    
    @IBOutlet var spotlightIndexSwitch: UISwitch!
    
    @IBOutlet var largeContentModeSwitch: UISwitch!
    
    @IBOutlet var blogPostReaderModeSwitch: UISwitch!
}
