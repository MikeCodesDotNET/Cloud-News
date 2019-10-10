//
//  BlogPost.swift
//  Advocates
//
//  Created by Michael James on 11/06/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import AppCenterData

class BlogPost: NSObject, MSSerializableDocument {
    
    var title: String
    var isFamilyFriendly: Bool
    var primaryImage: PrimaryImage
    //var summary: String
    var url: String
    var classType: String
    var identifier: String
    var source: String
    
    required public init(from dictionary: [AnyHashable: Any]) {
        
        //Title
        if let tempTitle = dictionary["title"] as? String {
            title = tempTitle
        } else {
            title = ""
        }
        
        //Is Family Friendly
        if let tempIsFamilyFriendly = dictionary["isFamilyFriendly"] as? Bool {
            isFamilyFriendly = tempIsFamilyFriendly
        } else {
            isFamilyFriendly = false
        }
        
        if let primaryImageDict = dictionary["primaryImage"] as? [AnyHashable: Any] {
            self.primaryImage = PrimaryImage.init(from: primaryImageDict)
        } else {
            self.primaryImage = PrimaryImage.init(contentUrl: "")
        }
        //self.summary = dictionary["summary"] as! String
        
        //URL
        if let tempUrl = dictionary["url"] as? String {
             url = tempUrl
        } else {
            url = ""
        }
        
        if let tempClassType = dictionary["classType"] as? String {
             classType = tempClassType
        } else {
            classType = ""
        }
        
        if let tempIdentifier = dictionary["identifier"] as? String {
              identifier = tempIdentifier
         } else {
             identifier = ""
         }
         
        if let tempSource = dictionary["source"] as? String {
                source = tempSource
           } else {
               source = ""
           }
        

    }
   
    init(title: String, url: String, source: String, identifier: String) {
        self.title = title
        self.url = url
        self.source = source
        self.identifier = identifier
        
        self.isFamilyFriendly = true
        self.primaryImage = PrimaryImage.init(contentUrl: "")
        self.classType = "BlogPost"
        
    }
    
    public func serializeToDictionary() -> [AnyHashable: Any] {
        return ["title": self.title,
                "isFamilyFriendly": self.isFamilyFriendly,
                "primaryImage": self.primaryImage,
                //"summary": self.summary,
                "url": self.url,
                "classType": self.classType,
                "identifier": self.identifier,
                "source": self.source]
    }

}

class PrimaryImage: NSObject, MSSerializableDocument {
    
    let contentUrl: String
    
    required public init(from dictionary: [AnyHashable: Any]) {
        
        if let tempContentUrl = dictionary["contentUrl"] as? String {
                    contentUrl = tempContentUrl
               } else {
                   contentUrl = ""
               }
    }
    
    public func serializeToDictionary() -> [AnyHashable: Any] {
        return ["contentUrl": self.contentUrl]
    }
    
    init(contentUrl: String) {
        self.contentUrl = contentUrl
    }
}
