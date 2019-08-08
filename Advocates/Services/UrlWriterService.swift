//
//  UrlWriterService.swift
//  Advocates
//
//  Created by Michael James on 29/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class UrlWriterService {
    
    
    /* Sample URL Format:
    // https://docs.microsoft.com/azure/security/azure-security-services-technologies?WT.mc_id=ignite-twitter-jeffsand
    // GOOD: ?WT.mc_id=ignite-twitter-jeffsand
    // BAD: ?WT.mc_id=ignite-twitter
    // BAD: ?WT.mc_id=ignite
    */
    
    let alias = "mijam"
    let source = "advocates"
    let inApp = "app"
    let external = "shared"
    
    func createTrackableLink(string: String, sharableLink: Bool) -> URL {
        
        //If the URL isn't pointing to a Microsoft web property then we don't need to add the ability to track.
        if(isMicrosoftProperty(string: string) == false){
            return URL.init(string: string)!
        }
        
        
        var appendableTrackingQuery = "";
        if(sharableLink == true) {
            appendableTrackingQuery = "?WT.mc_id=\(source)-\(external)-\(alias)"
        } else {
            appendableTrackingQuery = "?WT.mc_id=\(source)-\(inApp)-\(alias)"
        }
        
        
        
        if(string.contains("?")){
            //The URL contains queries. We'll need to append on the end
            
            var comp = URLComponents(string: string)
            comp?.query = nil
            
            return URL.init(string: "\(string)\(appendableTrackingQuery)")!
            
        } else {
            //No queries found. We'll add our own
            
             return URL.init(string: "\(string)\(appendableTrackingQuery)")!
        }
        
    }
    
    private func isMicrosoftProperty(string: String) -> Bool {
        
        if(string.contains("microsoft.com")) {
            return true
        }
        
        return false
        
    }
    
    
    
    
}
