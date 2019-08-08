//
//  SocialProtocol.swift
//  Advocates
//
//  Created by Michael James on 18/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

protocol SocialServiceProtocol {
    
    static var isSetApp: Bool { get }
    
    static func share(text: String, complection: @escaping (_ isOpened: Bool)->())
    
}
