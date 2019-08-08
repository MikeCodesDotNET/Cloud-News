//
//  SearchSuggestionsTableView.swift
//  Advocates
//
//  Created by Michael James on 19/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import UIKit
import SafariServices

class SearchSuggestionsTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var searchResults = [SearchResult]()
    

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.initView()
    }
    
    func initData(database: [SearchResult]) {
        self.searchResults = database
        
        print(database.count)
        DispatchQueue.main.async {
            self.reloadData()
        }

    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UITableViewDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchSuggestionListViewCell()
        
        let result = searchResults[indexPath.row]
        cell.searchLabel?.attributedText = hitHighlightText(searchText: result.searchText!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        
        if let url = URL(string: result.url) {
            let browserService = BrowsersService()
            browserService.openUrl(url: url)
        }
        
    }
    
    // Handle displaying Hit Highlight. Currently set the font to be slightly bolder
    func hitHighlightText(searchText: String) -> NSMutableAttributedString{
        
        let hitAttributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Avenir-Black", size: 15)!]
        let defaultAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        
        let attributedString: NSMutableAttributedString
        attributedString = NSMutableAttributedString(string: String(""), attributes: defaultAttributes)
        var highlight = false
        var attributedChars = [NSAttributedString]()
        
        for c in Array(searchText) {
            
            if(c == "[") {
                
                //We need to start highlighting
                highlight = true
                continue
            }
            if(c == "]") {
                highlight = false
                continue
            }
            
            if(highlight == false){
                //This is the default!
                let textAttributes = NSAttributedString(string: String(c), attributes: defaultAttributes)
                attributedChars.append(textAttributes)
            }
            
            if(highlight == true){
                //This is the default!
                let textAttributes = NSAttributedString(string: String(c), attributes: hitAttributes)
                attributedChars.append(textAttributes)
            }
        }
        
        for ta in attributedChars {
            
            attributedString.append(ta)
        }
        
        return attributedString
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // self.searchListViewDelegate?.searchListViewDidScroll()
    }
    
    
    func initView() {
        self.delegate = self
        self.dataSource = self
        self.register(SearchSuggestionListViewCell.self, forCellReuseIdentifier: SearchSuggestionListViewCell.ID)
        
        self.rowHeight = 60
        
    }
    
    let searchService = SearchService.init(indexName: "blog-posts")
}
