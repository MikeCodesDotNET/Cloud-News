//
//  AppDelegate.swift
//  Advocates
//
//  Created by Michael James on 11/06/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import UIKit
import SafariServices
import UserNotifications
import CoreSpotlight
import MobileCoreServices

import AppCenter
import AppCenterAuth
import AppCenterData
import AppCenterPush
import AppCenterCrashes
import AppCenterAnalytics
import AppCenterDistribute


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MSPushDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MSPush.setDelegate(self)

        MSAppCenter.start(Constants.AppCenter.apiKey, withServices: [MSDistribute.self, MSCrashes.self, MSAuth.self, MSData.self, MSPush.self, MSAnalytics.self])


        setupApperance()
        
        
        //Used when testing authentication flow.
        //MSAuth.signOut()
        
       
        return true
    }
    
    func setupApperance() {
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        
        //Handle push notifications
        let title: String = pushNotification.title ?? ""
        var message: String = pushNotification.message ?? ""
        var customData = pushNotification.customData
      
        var root = ""
        var article = ""
    
        for item in pushNotification.customData {
            
            if item.key == "root" {
                root = item.value
            }
            
            if item.key == "article" {
                article = item.value
            }
            
            
        }
        
          if (UIApplication.shared.applicationState == .inactive) {
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            
            let url = URL(string: "\(root)\(article)")
            
            let browserService = BrowsersService.init()
            browserService.openUrl(url: url!)
        }
        
        if (UIApplication.shared.applicationState == .active) {
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            
            let notiData = HDNotificationData(
                iconImage: UIImage(named: "Icon"),
                appTitle: "AZURE NEWS",
                title: title,
                message: message,
                time: "now")
            
            HDNotificationView.show(data: notiData, onTap: {
                let url = URL(string: "\(root)\(article)")
                
                let browserService = BrowsersService.init()
                browserService.openUrl(url: url!)
            }, onDidDismiss: nil)

        }
        
        
        if (UIApplication.shared.applicationState == .background) {
            
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            
             NSLog("Notification received in background, title: \"\(title)\", message: \"\(message)\", custom data: \"\(customData)\"");
            
        } else {
            
           // message =  message + ((customData.isEmpty) ? "" : "\n\(customData)")
            /*
            let banner = GrowingNotificationBanner(title: title, subtitle: message, style: .info, colors: InAppBannerColours())
            
            //Handle banner tap
            banner.onTap = {
                
                if let url = URL(string: "\(root)\(article)") {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    config.barCollapsingEnabled = true
                    
                    let vc = SFSafariViewController(url: url, configuration: config)
                    vc.preferredBarTintColor = UIColor.black
                    vc.preferredControlTintColor = UIColor.white
                    
                    let root = self.window?.rootViewController?.children.first as! UINavigationController
                    root.present(vc, animated: true)
                    
                }
                
            }
            banner.show()
         */
            
        }
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                
                //Download the item from App Center!
                print("Downloading \(uniqueIdentifier) from App Center")
                
                MSData.read(withDocumentID: uniqueIdentifier, documentType: BlogPost.self, partition: kMSDataAppDocumentsPartition, completionHandler: { document in
                    
                    let blogPost = document.deserializedValue as! BlogPost
                    
                    let browserService = BrowsersService.init()
                    browserService.openUrl(url: URL.init(string: blogPost.url)!)
                })
                
            }
        }
    
        return true
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

      // Pass the URL to MSAuth.
      return MSAuth.open(url)
    }
    

    func setupAppearance(){
        
        //Tabbar
        let tabColor = UIColor(hex: "#F6F6F6")
        
        UITabBar.appearance().backgroundColor = tabColor
        UITabBar.appearance().tintColor = tabColor
        
        
        
    }

}

