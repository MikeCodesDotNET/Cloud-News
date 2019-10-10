//
//  SearchRssFeedViewController.swift
//  Advocates
//
//  Created by Michael James on 18/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class FilterRssFeedViewController: UIViewController {
    
    var interests: [String] = ["AI & ML", "Analytics", "Blockchain", "Compute",
                               "Containers", "Databases", "Developer Tools", "DevOps",
                               "Identity", "Integration", "IoT", "Media",
                               "Migration", "Mixed Reality", "Mobile", "Networking",
                               "Security", "Storage", "Web", "Windows Virtual Desktop"]
    
    var interestsScrollView = UIScrollView.init()
    let buttonPadding: CGFloat = 10
    var xOffset: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestsScrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: view.bounds.width, height: 115))
        view.addSubview(interestsScrollView)
        interestsScrollView.showsHorizontalScrollIndicator = false
        interestsScrollView.backgroundColor = UIColor.clear
        interestsScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        for index in 0 ... interests.count - 1 {
            let button = UIButton()
            
            let interest: String = interests[index]
            button.tag = index
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
            
            button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
            button.setTitleColor(UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1.0), for: UIControl.State.normal)
            button.titleLabel?.font = UIFont(name: "SF-Pro-Display-Semibold", size: 18)
            button.setTitle("\(interest)", for: .normal)
            //button.addTarget(self, action: #selector(btnTouch), for: UIControlEvents.touchUpInside)
            
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding + 10), width: 140, height: 90)
            
            xOffset += CGFloat(buttonPadding) + button.frame.size.width
            interestsScrollView.addSubview(button)
            
        }
        
        interestsScrollView.contentSize = CGSize(width: xOffset, height: interestsScrollView.frame.height)
            
        /*
        for (index, interest) in interests.enumerated() {
            
            let offset = 15 * (index + 1)
            let button = UIButton.init(frame:  CGRect.init(x: offset, y: 0, width: 150, height: 100))
            button.titleLabel?.text = interest
            button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
            button.backgroundColor = UIColor.red
            button.layer.cornerRadius = 4
            button.layer.masksToBounds = true
            
            interestsScrollView.insertSubview(button, at: 1)
            interestsScrollView.layoutSubviews()
        }
        
        view.addSubview(interestsScrollView)
 */
    }
    
    @IBAction func doneTouchedUpInside(_ sender: Any) {
    }
    
}
