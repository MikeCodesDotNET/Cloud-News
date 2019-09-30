//
//  ShareSheetTableViewController.swift
//  Advocates
//
//  Created by Michael James on 29/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

import AppCenterData
import AppCenterAuth

import SPAlert

class ShareSheetTableViewController : UITableViewController {
    
    var blogPost: BlogPost?
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            bookmarkPost()
        case 1:
            share()
        case 2:
            hide()
        case 3:
            report()
        default:
            break
        }
        
    }
    
    func bookmarkPost(){
       
        //Check the user is logged in!
        MSAuth.signIn { userInformation, error in
            
            if error == nil {

                let id =  NSUUID().uuidString
                let bookmark = Bookmark.init(identifier: id, title: self.blogPost!.title, url: self.blogPost!.url, source: self.blogPost!.source, blogPostId: self.blogPost!.identifier, primaryImage: self.blogPost!.primaryImage.contentUrl)
                
                MSData.create(withDocumentID: bookmark.identifier, document: bookmark.self, partition: kMSDataUserDocumentsPartition, completionHandler: { document in
                    // Do something with the document
                    
                    if(document.error == nil){
                        DispatchQueue.main.async {
                            SPAlert.present(title: "Saved", preset: .heart)
                        }
                    } else {
                        // log it
                    }
                })
            }
            else {
               //log it
            }
        }

        self.dismiss(animated: true, completion: ({}))
        
       
    }
    
    //Some remarkably poor code...but it works, so its probably gonna stay forever
    func share() {
        //Medium blog post urls appear to have some extra bits for tracking. In order to share, we remove this guff first.
        var url: URL?
        if(blogPost?.source == "Medium.com"){
            let tempUrl = blogPost?.url.replacingOccurrences(of: "%3Fsource=rss----8bec1183ada9---4", with: "")
            
            url = urlWriterService.createTrackableLink(string: tempUrl!, sharableLink: true)
        } else {
            url = urlWriterService.createTrackableLink(string: blogPost!.url, sharableLink: true)
        }
   
        let activityViewController = UIActivityViewController(activityItems: [blogPost?.title, url!], applicationActivities: nil)
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    func hide() {
        
    }
    
    func report() {
        
    }
    
    
    
    let urlWriterService = UrlWriterService()
}
