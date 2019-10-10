//
//  Browsers.swift
//  Advocates
//
//  Created by Michael James on 26/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class BrowsersService {
    
    private let brave = "brave://open-url?url=https://"
    private let firefox = "firefox://open-url?url=https://"
    private let dolphin = "dolphin://"
    private let chrome = "googlechrome://"
    private let edge = "microsoft-edge-https://"
    private let opera = "touch-http"
    private let safari = ""
    
    func openUrl(url: URL) {
       
        if(settingsService.defaultBrowser() == .safariViewController) {
            let config = SFSafariViewController.Configuration()
            if(settingsService.readerModeEnabled() == true ) {
                config.entersReaderIfAvailable = true
                config.barCollapsingEnabled = true
            }
            let vc = SFSafariViewController(url: url, configuration: config)
            UIApplication.shared.keyWindow?.rootViewController?.present(vc, animated: true)
        } else {
            UIApplication.shared.open(rebuildUrl(url: url), options: [:], completionHandler: nil)
        }
    }
    
    func installedBrowsers() -> [Browser] {
        
        var installed = [Browser]()
        
        for browser in Browser.allCases {
            
            if(isInstalled(browser: browser) == true) {
                installed.append(browser)
            }
            
        }
    
        return installed
    }
    
    private func rebuildUrl(url: URL) -> URL {
        
        //To open a URL in a specific browser requires a re-write of the URL to include a custom schema (defined by the browser developer)
        var tmpUrl = url.absoluteString.replacingOccurrences(of: "http://", with: "")
        tmpUrl = url.absoluteString.replacingOccurrences(of: "https://", with: "")

        var tmp2Url: URL = url
        
        switch (settingsService.defaultBrowser()) {
            case . brave:
                tmp2Url = URL.init(string: "\(brave)\(tmpUrl)")!
            
        case .chrome:
            tmp2Url = URL.init(string: "\(chrome)\(tmpUrl)")!
        case .dolphin:
            tmp2Url = URL.init(string: "\(dolphin)\(tmpUrl)")!
        case .firefox:
            tmp2Url = URL.init(string: "\(firefox)\(tmpUrl)")!
 
        case .safari:
            return url

        case .edge:
            tmp2Url = URL.init(string: "\(edge)\(tmpUrl)")!
            break

        case .safariViewController:
            break

        case .firefoxFocus:
            break
        }
        
        return tmp2Url
    }
        
    func isInstalled(browser: Browser) -> Bool {
        
        let testDestination: String = "www.microsoft.com"
        var testLink: String = ""
        
        switch(browser) {
            case .brave:
                testLink = "\(brave)\(testDestination)"
                break
            case .chrome:
                testLink = "\(chrome)\(testDestination)"
                break
            case .dolphin:
                testLink = "\(dolphin)\(testDestination)"
                break
            case .firefox:
                testLink = "\(firefox)\(testDestination)"
                break
            case .firefoxFocus:
                testLink = "firefox-focus://open-url?url=\(testDestination)"
                break
            case .safari:
                return true
            case .edge:
                testLink = "\(edge)\(testDestination)"
                break
            
            case . safariViewController:
                return true
                break
            
        }
        
        if UIApplication.shared.canOpenURL(URL(string: testLink)!) {
            return true
        } else {
            return false
        }
    }
    
    let settingsService = SettingsService()
    
}

public enum Browser: CaseIterable {
    case brave
    case chrome
    case dolphin
    case edge
    case firefox
    case firefoxFocus
    case safari
    case safariViewController
}
