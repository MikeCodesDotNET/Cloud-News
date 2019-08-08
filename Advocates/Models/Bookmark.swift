//
//  Bookmark.swift
//  Advocates
//
//  Created by Michael James on 30/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit
import AppCenterData

class Bookmark : NSObject, MSSerializableDocument    {

    var identifier: String
    var classType: String
    var title: String
    var url: String
    var source: String
    var blogPostId: String
    var primaryImage: String
    
    required public init(from dictionary: [AnyHashable : Any]) {
        self.classType = dictionary["classType"] as! String
        self.identifier = dictionary["identifier"] as! String
        self.title = dictionary["title"] as! String
        self.url = dictionary["url"] as! String
        self.source = dictionary["source"] as! String
        self.blogPostId = dictionary["blogPostId"] as! String
        self.primaryImage = dictionary["primaryImage"] as! String

    }
    
    
    init(identifier: String, title: String, url: String, source: String, blogPostId: String, primaryImage: String) {
      
        self.identifier = identifier
        self.classType = "Bookmark"
        self.title = title
        self.url = url
        self.source = source
        self.blogPostId = blogPostId
        self.primaryImage = primaryImage
    } 
    
    public func serializeToDictionary() -> [AnyHashable : Any] {
        
        return ["identifier": self.identifier,
                "classType": self.classType,
                "title": self.title,
                "url": self.url,
                "source": self.source,
                "blogPostId": self.blogPostId,
                "primaryImage": self.primaryImage]
    }
    
}
