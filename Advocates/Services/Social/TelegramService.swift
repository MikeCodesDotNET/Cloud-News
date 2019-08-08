//
//  TelegramService.swift
//  Advocates
//
//  Created by Michael James on 18/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//  Origins:  Based on code from hello@ivanvorobei.by

import Foundation
import UIKit

/*
class TelegramService : SocialServiceProtocol {
    
    
    static var isSetApp: Bool {
        return UIApplication.shared.canOpenURL(URL(string: "tg://msg?text=test")!)
    }
    
    static func share(text: String, complection: @escaping (_ isOpened: Bool)->() = {_ in }) {
        let urlStringEncoded = text.addingPercentEncoding( withAllowedCharacters: .urlHostAllowed)
        let urlOptional = URL(string: "tg://msg?text=\(urlStringEncoded ?? "")")
        if let url = urlOptional {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: complection)
            } else {
                complection(false)
            }
        } else {
            complection(false)
        }
    }
    
    static func joinChannel(id: String) {
        let url = "https://t.me/joinchat/\(id)"
        SPApp.open(link: url)
    }
    
    static func joinChat(id: String) {
        let url = "https://t.me/joinchat/\(id)"
        SPApp.open(link: url)
    }
    
    static func openBot(username: String) {
        var username = username
        if username.first == "@" {
            username.removeFirst()
        }
        let url = "https://telegram.me/\(username)"
        SPApp.open(link: url)
    }
    
    static func openDialog(username: String) {
        let url = "https://t.me/\(username)"
        SPApp.open(link: url)
    }
    
    private init() {}
}

fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
*/
