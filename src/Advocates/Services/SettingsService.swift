//
//  SettingsService.swift
//  Advocates
//
//  Created by Michael James on 26/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class SettingsService {
        
    // MARK: - Spotlight Index Search
    func spotlightIntegrationEnabled() -> Bool {
        let key = "spotlightIndex"
        
        //Lets first check if the setting exists
        let settingExists = UserDefaults.standard.object(forKey: key) != nil
        
        if(settingExists == true) {
            return UserDefaults.standard.bool(forKey: key)
        } else {
            //Create default setting
            UserDefaults.standard.set(true, forKey: key)
            print("Writing UserDefault: spotlightIndex = true")
            return false
        }
    }
    
    func setSpotlightIntegrationEnabled(value: Bool) {
        let key = "spotlightIndex"
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Blog Posts
    func useLargeContentMode() -> Bool {
        let key = "largeContentMode"
        
        //Lets first check if the setting exists
        let settingExists = UserDefaults.standard.object(forKey: key) != nil
        
        if(settingExists == true) {
            return UserDefaults.standard.bool(forKey: key)
        } else {
            //Create default setting
            UserDefaults.standard.set(false, forKey: key)
            print("Writing UserDefault: largeContentMode = false")
            return true
        }
    }
    
    func setUpdateContentMode(value: Bool) {
        let key = "largeContentMode"
        UserDefaults.standard.set(value, forKey: key)
    }

    // MARK: - Safari Reader Mode
    func readerModeEnabled() -> Bool {
        let key = "blogPostReaderMode"
        
        //Lets first check if the setting exists
        let settingExists = UserDefaults.standard.object(forKey: key) != nil
        
        if(settingExists == true) {
            return UserDefaults.standard.bool(forKey: key)
        } else {
            //Create default setting
            UserDefaults.standard.set(true, forKey: key)
            print("Writing UserDefault: blogPostReaderMode = true")
            return true
        }
    }
    
    func setReaderModeEnabled(value: Bool) {
        let key = "blogPostReaderMode"
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Safari Reader Mode
    func defaultBrowser() -> Browser {
        let key = "defaultBrowser"
      
        //Lets first check if the setting exists
        let settingExists = UserDefaults.standard.object(forKey: key) != nil
        
        if(settingExists == true) {
            let value = UserDefaults.standard.string(forKey: key)
            switch(value) {
                case "brave":
                    return .brave
                case "chrome":
                    return .chrome
                case "dolphin":
                    return .dolphin
                case "edge":
                    return .edge
                case "firefox":
                    return .firefox
                case "firefoxFocus":
                    return .firefoxFocus
                case "safari":
                    return .safari
                case "safariViewController":
                    return .safariViewController
                default:
                    return .safariViewController
            }
        } else {
            //Create default setting
            UserDefaults.standard.set("safariViewController", forKey: key)
            print("Writing UserDefault: defaultBrowser = safariViewController")
            return .safariViewController
        }
    }
    
    func setDefaultBrowser(value: Browser) {
        let key = "defaultBrowser"
        
        switch(value) {
            case .brave:
                UserDefaults.standard.set("brave", forKey: key)
            case .chrome:
                UserDefaults.standard.set("chrome", forKey: key)
            case .dolphin:
                UserDefaults.standard.set("dolphin", forKey: key)
            case .edge:
                UserDefaults.standard.set("edge", forKey: key)
            case .firefox:
                UserDefaults.standard.set("firefox", forKey: key)
            case .firefoxFocus:
                UserDefaults.standard.set("firefoxFocus", forKey: key)
            case .safari:
                UserDefaults.standard.set("safari", forKey: key)
            case .safariViewController:
                UserDefaults.standard.set("safariViewController", forKey: key)
        }
    }
    
}
