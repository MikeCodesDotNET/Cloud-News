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

class AccountTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if accountViewModel.signIn() == true {
            //Ensure we update the UI on the main thread.
            self.fullNameLabel.text = self.accountViewModel.fullName
            self.displayNameLabel.text = self.accountViewModel.displayName
            self.avatarImageView.image = self.accountViewModel.avatarImage
        } else {
            setupUI()
        }
        
        refresh()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? BlogPostTableViewCell
        else {
            FatalErorr()
        }
     
        let blogPost = self.bookmarks[indexPath.row]
        cell.titleLabel.text = blogPost.title
        cell.sourceLabel.text = blogPost.source
       
        let url = URL(string: blogPost.primaryImage.contentUrl)
        cell.primaryImageView.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        cell.primaryImageView.layer.cornerRadius = 8
        cell.primaryImageView.layer.borderWidth = 1
        cell.primaryImageView.layer.borderColor = UIColor.clouds.cgColor
        
        cell.primaryImageView.layer.shadowColor = UIColor.black.cgColor
        cell.primaryImageView.layer.shadowOpacity = 1
        cell.primaryImageView.layer.shadowOffset = .zero
        cell.primaryImageView.layer.shadowRadius = 10
        
        return cell
    }
    
    private func setupUI() {
        
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
        fullNameLabel.isSkeletonable = true
        fullNameLabel.linesCornerRadius = 10
        fullNameLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
        displayNameLabel.isSkeletonable = true
        displayNameLabel.linesCornerRadius = 10
        displayNameLabel.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
        
    }
    
    var bookmarks = [BlogPost]()
    
    func refresh() {
        
        MSData.listDocuments(withType: Bookmark.self, partition: kMSDataUserDocumentsPartition, completionHandler: { documents in
            
            for document in documents.currentPage().items {
                guard let bookmark = document.deserializedValue as? Bookmark
                    else {
                        FatalErorr()
                }
                
                MSData.read(withDocumentID: bookmark.blogPostId, documentType: BlogPost.self,
                            partition: kMSDataAppDocumentsPartition, completionHandler: { _ in
                    
                    guard let bookmark = document.deserializedValue as? BlogPost
                    else {
                        FatalErorr()
                    }
    
                    self.bookmarks.append(bookmark)
                })
                
            }
            print("Bookmarks: \(self.bookmarks.count)")
        })
        
        tableView.reloadData()
    }
    
    //Services
    let accountViewModel: AccountViewModel = AccountViewModel.init()
    
    //Outlets
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var displayNameLabel: UILabel!

}
