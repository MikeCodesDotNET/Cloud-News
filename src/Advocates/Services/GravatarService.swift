//
//  GravatarService.swift
//  Advocates
//
//  Created by Michael James on 17/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit

import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

class GravatarService {
    
    
    func gravatarUrlForEmail(emailString: String) -> URL
    {
        let email = emailString.lowercased()
        let md5Data = MD5(string: email)
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        let imageString = "https://gravatar.com/avatar/\(md5Hex).jpg?size=200&d=identicon"
        let url = URL.init(string: imageString)!
        return url
    }
    
    
    private func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
    
    
    struct Root: Codable {
        let entry: [Entry]
    }
    
    struct Entry: Codable {
        let id, hash, requestHash: String
        let profileURL: String
        let preferredUsername: String
        let thumbnailURL: String
        let photos: [Photo]
        let displayName: String
        
        enum CodingKeys: String, CodingKey {
            case id, hash, requestHash
            case profileURL = "profileUrl"
            case preferredUsername
            case thumbnailURL = "thumbnailUrl"
            case photos, displayName
        }
    }
    
    struct Photo: Codable {
        let value: String
        let type: String
    }
}

