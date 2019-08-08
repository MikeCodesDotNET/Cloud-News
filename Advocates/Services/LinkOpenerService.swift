//
//  LinkOpenerService.swift
//  Advocates
//
//  Created by Michael James on 18/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class LinkOpenerService {
    /*
    static func open(link: String) {
        
        let defaults = UserDefaults.standard
        let browserType = defaults.string(forKey: "browserType")
        
        switch browserType {
        case "External":
            guard let url = URL(string: link) else {
                print("SPOpener - can not create URL")
            }
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        default:
            /*
            let safariController = SFSafariViewController.init(url: url)
            
            let root = self.window?.rootViewController?.children.first as! UINavigationController
            root.present(safariController, animated: true)
            */
            
        }
        
      
        
    }
    
    static func open(link: String, on controller: UIViewController) {
        guard let url = URL(string: link) else {
            print("SPOpener - can not create URL")
            return
        }
        let safariController = SFSafariViewController.init(url: url)
        controller.present(safariController, animated: true, completion: nil)
    }
    
    
}
*/
}
