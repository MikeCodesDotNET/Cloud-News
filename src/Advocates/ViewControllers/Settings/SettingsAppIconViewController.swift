//
//  SettingsAppIconViewController.swift
//  Advocates
//
//  Created by Michael James on 25/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class SettingsAppIconViewController : UITableViewController {

    
    var iconItems: [(imageName: String, displayName: String)] = []
    var selectedIconName: String?
    var previousSelectionIndex: IndexPath?
    
    override func viewDidLoad() {
        
        iconItems.append((imageName: "AppIcon-8Bit", displayName: "8Bit"))
        iconItems.append((imageName: "Bit-ScottGu", displayName: "Scott Gu"))
        iconItems.append((imageName: "Bit-Kubernetes", displayName: "Bit & Kubenetes"))
        iconItems.append((imageName: "Bit-Linux", displayName: "Bit & Tux"))
        iconItems.append((imageName: "Bit-Octocat", displayName: "Bit & Octocat"))
        iconItems.append((imageName: "Gophers-Azure", displayName: "Gophers"))
        iconItems.append((imageName: "Bit_Unicorn", displayName: "Bit Riding a Unicorn"))
        iconItems.append((imageName: "Bit-Azure", displayName: "Bit on Azure"))
        iconItems.append((imageName: "Bit-DotNET", displayName: "Bit & DotNET"))
        iconItems.append((imageName: "Bit-ML", displayName: "Bit Machine Learning"))
        iconItems.append((imageName: "Bit-Python", displayName: "Bit & Python"))
        iconItems.append((imageName: "Bit_Sandbox", displayName: "Sandbox"))
        iconItems.append((imageName: "Bit-VSCode", displayName: "Bit using VSCode"))
        iconItems.append((imageName: "Bit-Xamarin", displayName: "Bit & Xamarin Monkey"))
        iconItems.append((imageName: "Bit_Pride", displayName: "Pride"))
        iconItems.append((imageName: "javascript", displayName: "JavaScript"))
        
     
        selectedIconName = UserDefaults.standard.value(forKey: "AppIcon") as? String

    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = iconItems[indexPath.row]
        
        let appIconCell = tableView.dequeueReusableCell(withIdentifier: "AppIconTableViewCell", for: indexPath) as! AppIconTableViewCell
    
        appIconCell.titleLabel?.text = item.displayName
        appIconCell.appIcon.image = UIImage.init(named: item.imageName)
        
        if(selectedIconName != item.imageName) {
            appIconCell.accessoryType = UITableViewCell.AccessoryType.none
        } else {
            appIconCell.accessoryType = UITableViewCell.AccessoryType.checkmark
            previousSelectionIndex = indexPath
        }
        
        
        return appIconCell
    }
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
            guard UIApplication.shared.supportsAlternateIcons else {
                return
            }
        
            let selectedIcon = iconItems[indexPath.row]
            let selectedCell = tableView.cellForRow(at: indexPath)
        
            //Deselect existing cell and then select next
            if(previousSelectionIndex != nil) {
                if let oldCell = tableView.cellForRow(at: previousSelectionIndex!) {
                    oldCell.accessoryType = UITableViewCell.AccessoryType.none
                }
                
        }
        
            selectedCell?.accessoryType = UITableViewCell.AccessoryType.checkmark
            UserDefaults.standard.setValue(selectedIcon.imageName, forKey: "AppIcon")
        
        
        
            UIApplication.shared.setAlternateIconName(selectedIcon.imageName, completionHandler: {   (error) in
                
                if error != nil {
                    print(error!)
                }
                
            })
        
            previousSelectionIndex = indexPath
        
        }
        
}
    

