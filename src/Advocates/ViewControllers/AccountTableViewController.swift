//
//  SecondViewController.swift
//  Advocates
//
//  Created by Michael James on 11/06/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import UIKit

import AppCenter
import AppCenterData
import AppCenterAuth

import SkeletonView
import Kingfisher

import SPAlert

class AccountTableViewController: UITableViewController {
    
    var bookmarkedBlogPosts = [BlogPost]()
    var bookmarks = [Bookmark]()
    let headerViewHeight = 100
    
    
    //MARK: - UIView Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
        
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        MSAuth.signIn { userInformation, error in
            
            if (error == nil) {
                // Sign-in succeeded. Lets go ahead and deode the token for user details!
                self.decodeToken(token: userInformation!.accessToken!)

                self.refresh()
            } else {
                
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupHeader(contentOffset: CGFloat.init())
    }
    
    //MARK: - ScrollView Events
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.setupHeader(contentOffset: scrollView.contentOffset.y)
    }
    
    
    //MARK: - UITableView Overrides
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! BlogPostTableViewCell
     
        let bookmark = self.bookmarks[indexPath.row]
        cell.titleLabel.text = bookmark.title
        cell.sourceLabel.text = bookmark.source
       
        let url = URL(string: bookmark.primaryImage)
        cell.primaryImageView.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        cell.primaryImageView.layer.cornerRadius = 8
        cell.primaryImageView.layer.borderWidth = 1
        cell.primaryImageView.layer.borderColor = UIColor.clouds.cgColor
        
        cell.primaryImageView.layer.shadowColor = UIColor.black.cgColor
        cell.primaryImageView.layer.shadowOpacity = 1
        cell.primaryImageView.layer.shadowOffset = .zero
        cell.primaryImageView.layer.shadowRadius = 10
        
        cell.moreButton.isHidden = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let bookmark = bookmarks[indexPath.row]
        
        let browserService = BrowsersService.init()
        browserService.openUrl(url: URL.init(string: bookmark.url)!)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let bookmark = self.bookmarks[indexPath.row]
            self.bookmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            SPAlert.present(title: "Deleted", preset: .done)
            
            MSData.delete(withDocumentID: bookmark.identifier, partition: kMSDataUserDocumentsPartition, completionHandler: {   document in
                
                if(document.error == nil) {
                    
                }
            })
        }
    }
    
    
    //MARK: - Authentication
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
                            self.displayNameLabel.text = "@\(displayName as? String ?? "")"
                        }
                        
                        let firstName = claims!["given_name"]
                        let lastName = claims!["family_name"]
                        
                      //  self.fullNameLabel.text = "\(firstName ?? "") \(lastName ?? "")"
                        self.title = "\(firstName ?? "") \(lastName ?? "")"
                        
                        // Get email addresses.
                        let emails = claims!["emails"] as? [Any]
                        if emails != nil && emails!.count > 0 {
                            let firstEmail = emails![0] as? String
                            
                            // Use the email address to get the users avatar from Gravatar
                            let url = gravatarService.gravatarUrlForEmail(emailString: firstEmail!)
                            URLSession.shared.dataTask(with: url) { data, response, error in
                       
                                DispatchQueue.main.async {
                                    self.avatarImageView.kf.setImage(with: url)
                                    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
                                    self.avatarImageView.layer.masksToBounds = true
                                }
                            }.resume()
                        }
                        
                    }
                }
            } catch {
                
                // Handle error.
            }
        }
    }

    
    //MARK: - Services
    let accountViewModel: AccountViewModel = AccountViewModel.init()
    let gravatarService: GravatarService = GravatarService.init()
    
    
    //MARK: - UI
    private func setupUI(){
        
        //Loading Animations
        let gradient = SkeletonGradient(baseColor: UIColor.clouds)
        
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topLeftBottomRight)
        
        //Setup Avatar Image
        avatarImageView.isSkeletonable = true
        avatarImageView.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.masksToBounds = true
        
        //Labels
        displayNameLabel.isSkeletonable = true
        displayNameLabel.linesCornerRadius = 10
        displayNameLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
    }
    
    private func refresh() {
        
        self.bookmarkedBlogPosts.removeAll()
        self.bookmarks.removeAll()
        
        MSData.listDocuments(withType: Bookmark.self, partition: kMSDataUserDocumentsPartition, completionHandler: { documents in
            
            for document in documents.currentPage().items {
                let bookmark = document.deserializedValue as! Bookmark
                self.bookmarks.append(bookmark)
                
            }
            print("Bookmarks: \(self.bookmarkedBlogPosts.count)")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
    }
    
    private func setupHeader(contentOffset: CGFloat){
        
        let width = self.view.frame.width
        
        var avatarImageViewRect = CGRect.init(x: 0, y: Int(contentOffset), width: Int(width), height: headerViewHeight)
        
        if(Int(tableView.contentOffset.y) <= headerViewHeight){
            avatarImageView.frame.origin = CGPoint.init(x: avatarImageViewRect.origin.x, y: avatarImageViewRect.origin.y)
            avatarImageView.frame.size = CGSize.init(width: avatarImageViewRect.size.width + contentOffset, height: avatarImageView.frame.size.height + contentOffset )
        }
        avatarImageView.frame = avatarImageViewRect
    }
    
    //MARK: - Outlets
    @IBOutlet var headerView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var displayNameLabel: UILabel!
}

