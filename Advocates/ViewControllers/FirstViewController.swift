//
//  FirstViewController.swift
//  Advocates
//
//  Created by Michael James on 11/06/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import UIKit
import AppCenterData

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func refresh()
    {
        MSData.listDocuments(withType: BlogPost.self, partition: kMSDataUserDocumentsPartition, completionHandler: { documents in
            
            for document in documents.currentPage().items {
                var fetchedDocument: BlogPost
                fetchedDocument = document.deserializedValue as! BlogPost
                
                //We have the headline here.
                
            }
            
        })
    }
    

}

