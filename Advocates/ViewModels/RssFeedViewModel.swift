//
//  RssFeedViewModel.swift
//  Advocates
//
//  Created by Michael James on 17/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import AppCenterData


class RssFeedViewModel {
    
    private var preSearchPosts: [BlogPost] = []
    
    var blogPosts: [BlogPost] = []
    var suggestions: [SearchResult] = []
    
    func refresh(completionHandler: @escaping () -> ()){
        self.blogPosts.removeAll()
        
        MSData.listDocuments(withType: BlogPost.self, partition: kMSDataAppDocumentsPartition, completionHandler: { documents in
            for document in documents.currentPage().items {
                var fetchedDocument: BlogPost
                fetchedDocument = document.deserializedValue as! BlogPost
                self.blogPosts.append(fetchedDocument)
            }
            self.blogPosts = self.blogPosts.reversed()
            completionHandler()
        })
    }

    
    func suggest(searchTerm: String, completionHandler: @escaping () -> ()){
    
        searchService.suggest(query: searchTerm, completion: { results in
            self.suggestions.removeAll(keepingCapacity: false)
            self.suggestions.append(contentsOf: results)
            completionHandler()
        })
    }
    
    
    private let searchService = SearchService.init(indexName: "blog-posts")
    
   
}
