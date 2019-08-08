//
//  Colours.swift
//  Advocates
//
//  Created by Michael James on 18/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import UIKit
import NotificationBannerSwift

struct AppColours {
    
    let danger = UIColor(red:0.79, green:0.17, blue:0.38, alpha:1.0)
    let info = UIColor(red:0.00, green:0.47, blue:0.83, alpha:1.0)
    let clear = UIColor.clear
    let success = UIColor(red:0.30, green:0.48, blue:0.07, alpha:1.0)
    let warning = UIColor(red:0.91, green:0.59, blue:0.23, alpha:1.0)
    
}


//Notification Banner Header
class InAppBannerColours : BannerColorsProtocol {
    
    let colours = AppColours()
    
    internal func color(for style: BannerStyle) -> UIColor {
        switch style {
        case .danger:
            return colours.danger
        case .info:
            return colours.info
        case .none:
            return colours.clear
        case .success:
            return colours.success
        case .warning:
            return colours.warning
        }
    }
    
}
