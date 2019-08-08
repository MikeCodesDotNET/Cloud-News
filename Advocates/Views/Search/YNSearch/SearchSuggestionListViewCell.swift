//
//  SearchSuggestionListViewCell.swift
//  Advocates
//
//  Created by Michael James on 19/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//


import UIKit

class SearchSuggestionListViewCell: UITableViewCell {
    public static let ID = "searchSuggestionTableViewCell"
    
    var searchResult: SearchResult?
    var searchLabel: UILabel!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initView() {
        
        self.searchLabel = UILabel(frame: CGRect(x: 25, y: 0, width: self.frame.width + 30, height: self.frame.height))
        self.searchLabel.numberOfLines = 2
        self.searchLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.searchLabel.textColor = UIColor.darkGray
        self.searchLabel.font = UIFont(name: "Avenir-Medium", size: 14)
        self.addSubview(searchLabel)
    }
    
    
}
