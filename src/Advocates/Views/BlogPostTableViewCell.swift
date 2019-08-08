//
//  BlogPostTableViewCell.swift
//  Advocates
//
//  Created by Michael James on 17/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

class BlogPostTableViewCell : UITableViewCell {
    
    
    var moreButtonAction : (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
    }

    @IBOutlet var primaryImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var moreButton: UIButton!
    
    @IBAction func moreButtonTapped(_ sender: UIButton){
        // if the closure is defined (not nil)
        // then execute the code inside the subscribeButtonAction closure
        moreButtonAction?()
    }
    
}
