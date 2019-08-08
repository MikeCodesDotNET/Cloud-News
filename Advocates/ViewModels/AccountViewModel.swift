//
//  AccountViewModel.swift
//  Advocates
//
//  Created by Michael James on 17/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import AppCenterAuth

class AccountViewModel {
    
    
    let gravatarService: GravatarService = GravatarService()
    
    var displayName: String
    var fullName: String
    
    var avatarImage: UIImage
    
    init(){
        displayName = ""
        fullName = ""
        avatarImage = UIImage.init()
    }
    
    func signIn() -> Bool {
        var didLogin = false
        
        MSAuth.signIn { userInformation, error in
            
            if error == nil {
                // Sign-in succeeded. Lets go ahead and deode the token for user details!
                self.decodeToken(token: userInformation!.accessToken!)
                didLogin = true
            }
        }
        return didLogin
    }
    
    private func decodeToken(token: String){
        
        let tokenSplit = token.components(separatedBy: ".")
        
        if tokenSplit.count > 1 {
            var rawClaims = tokenSplit[1]
            let paddedLength = rawClaims.count + (4 - rawClaims.count % 4) % 4
            rawClaims = rawClaims.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
            let claimsData = Data(base64Encoded: rawClaims, options: .ignoreUnknownCharacters)
            do {
                if claimsData != nil {
                    let claims = try JSONSerialization.jsonObject(with: claimsData!, options: []) as? [AnyHashable: Any]
                    if claims != nil {
                        
                        // Get display name.
                        let displayName = claims!["name"]
                        if displayName is String {
                            // Do something with display name.
                            self.displayName = "@\(displayName as? String ?? "")"
                        }
                        
                        let firstName = claims!["given_name"]
                        let lastName = claims!["family_name"]
                        
                        self.fullName = "\(firstName ?? "") \(lastName ?? "")"
                        
                        
                         // Get email addresses.
                         let emails = claims!["emails"] as? [Any]
                         if emails != nil && emails!.count > 0 {
                         let firstEmail = emails![0] as? String
                         
                         // Use the email address to get the users avatar from Gravatar
                         let url = gravatarService.gravatarUrlForEmail(emailString: firstEmail!)
                         URLSession.shared.dataTask(with: url) { data, response, error in
                         guard
                         let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                         let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                         let data = data, error == nil,
                         let image = UIImage(data: data)
                         else { return }
                         self.avatarImage = image
                         }.resume()
                         }
                        
                    }
                }
            } catch {
                
                // Handle error.
            }
        }
    }
    
}
