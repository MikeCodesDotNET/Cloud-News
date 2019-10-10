//
//  SettingsDefaultBrowserTableViewController.swift
//  Advocates
//
//  Created by Michael James on 29/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class SettingsDefaultBrowserTableViewController: UITableViewController {
    
    let settingsService = SettingsService()
    var installedBrowsers = [Browser]()
    
    override func viewDidLoad() {
        self.installedBrowsers = browserService.installedBrowsers()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    let browserService = BrowsersService()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return installedBrowsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "browserCell",
            for: indexPath) as? BrowserTableCell
        else {
            fatalError("DequeueReusableCell failed while casting")
        }
        
        let browser = self.installedBrowsers[indexPath.row]
        
        let defaultBrowser = self.settingsService.defaultBrowser()
        if(defaultBrowser == browser) {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        cell.browser = browser
        
        switch(browser) {
        case .brave:
            cell.nameLabel.text = "Brave"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Brave")
        case .chrome:
            cell.nameLabel.text = "Google Chrome"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Chrome")
        case .dolphin:
            cell.nameLabel.text = "Dolphin"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Dolphin")
        case .edge:
            cell.nameLabel.text = "Microsoft Edge"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Edge")
        case .firefox:
            cell.nameLabel.text = "Firefox"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Firefox")
        case .firefoxFocus:
            cell.nameLabel.text = "Firefox Focus"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Firefox")
        case .safari:
            cell.nameLabel.text = "Safari"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Safari")
        case .safariViewController:
            cell.nameLabel.text = "Embedded Safari"
            cell.iconImageView.image = UIImage.init(named: "Settings-Browsers-Safari")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let browser = installedBrowsers[indexPath.row]
        
        settingsService.setDefaultBrowser(value: browser)
        tableView.reloadData()
    }
    
}
