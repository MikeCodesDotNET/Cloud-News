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
        self.title = dictionary["title"] as! String
        self.isFamilyFriendly = dictionary["isFamilyFriendly"] as! Bool
        self.primaryImage = PrimaryImage.init(from: dictionary["primaryImage"] as! [AnyHashable: Any] )
        //self.summary = dictionary["summary"] as! String
        self.url = dictionary["url"] as! String
        self.classType = dictionary["classType"] as! String
        self.identifier = dictionary["identifier"] as! String
        self.source = dictionary["source"] as! String

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
         self.contentUrl = dictionary["contentUrl"] as! String
    }
    
    public func serializeToDictionary() -> [AnyHashable: Any] {
        return ["contentUrl": self.contentUrl]
    }
    
    init(contentUrl: String) {
        self.contentUrl = contentUrl
    }
}
