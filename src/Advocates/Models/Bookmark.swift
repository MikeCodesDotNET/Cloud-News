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

class Bookmark: NSObject, MSSerializableDocument {

    var identifier: String
    var classType: String
    var title: String
    var url: String
    var source: String
    var blogPostId: String
    var primaryImage: String
    
    required public init(from dictionary: [AnyHashable: Any]) {
        
        //Title
        if let tempTitle = dictionary["title"] as? String {
            title = tempTitle
        } else {
            title = ""
        }
        
        //self.summary = dictionary["summary"] as! String
        
        //Blog post id
        if let tempBlogPostId = dictionary["blogPostId"] as? String {
             blogPostId = tempBlogPostId
        } else {
            blogPostId = ""
        }
        
        
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
        
        if let tempPrimaryImage = dictionary["primaryImage"] as? String {
                       primaryImage = tempPrimaryImage
                  } else {
                      primaryImage = ""
                  }
        
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
    
    public func serializeToDictionary() -> [AnyHashable: Any] {
        
        return ["identifier": self.identifier,
                "classType": self.classType,
                "title": self.title,
                "url": self.url,
                "source": self.source,
                "blogPostId": self.blogPostId,
                "primaryImage": self.primaryImage]
    }
    
}
