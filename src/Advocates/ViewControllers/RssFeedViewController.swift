//
//  RssFeedViewController.swift
//  Advocates
//
//  Created by Michael James on 17/07/2019.
//  Copyright © 2019 Mike James. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import CoreSpotlight
import MobileCoreServices

import AppCenterAnalytics

import SPStorkController
import Kingfisher

class RssFeedViewController : UITableViewController, UIViewControllerPreviewingDelegate, UISearchBarDelegate {
    
    private let filterButton = UIButton.init(type: .custom)
    private var shoulResize: Bool?
    private var suggestsionsTableView = SearchSuggestionsTableView.init()

    
    // MARK: - Peek & Pop Preview
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let indexPath = tableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
      
            //Get the blog post item
            let index = tableView.indexPathForRow(at: location)
            let blogPost = viewModel.blogPosts[(index?.row)!]
            
            let url = URL.init(string: blogPost.url)!
            
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            config.barCollapsingEnabled = true
            
            let vc = SFSafariViewController(url: url, configuration: config )
            return vc
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        present(viewControllerToCommit, animated: true)
    }
    
    
    // MARK: - UITextFieldDelegate for SearchBar
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Animate the hiding of the search suggestions
        UIView.animate(withDuration: 0.3, animations: {
            self.suggestsionsTableView.alpha = 0
        }, completion: { result in
            self.suggestsionsTableView.initData(database: [SearchResult]())
            self.suggestsionsTableView.removeFromSuperview()
            self.dismissKeyboard()
        })
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        suggestsionsTableView.alpha = 0
        self.view.addSubview(suggestsionsTableView)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.suggestsionsTableView.alpha = 1
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        //Animate the hiding of the search suggestions
        UIView.animate(withDuration: 0.3, animations: {
            self.suggestsionsTableView.alpha = 0
        }, completion: { result in
            self.suggestsionsTableView.removeFromSuperview()
            self.dismissKeyboard()
        })
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //We call off to Azure Search to provide suggestions.
        
        if searchText.isEmpty == false {
            
            viewModel.suggest(searchTerm: searchText, completionHandler: {
                self.suggestsionsTableView.initData(database: self.viewModel.suggestions)
            })
        } else {
            
            self.suggestsionsTableView.initData(database: [SearchResult]())
            UIView.animate(withDuration: 0.3, animations: {
                self.suggestsionsTableView.alpha = 0
            }, completion: { result in
                self.suggestsionsTableView.removeFromSuperview()
                self.dismissKeyboard()
            })
        }
    
        
                
        
    }
    
    
    // MARK: - Filter Button
    private func resizeImageForLandscape() {
        let yTranslation = Const.ImageSizeForLargeState * Const.ScaleForImageSizeForLandscape
        filterButton.transform = CGAffineTransform.identity
            .scaledBy(x: Const.ScaleForImageSizeForLandscape, y: Const.ScaleForImageSizeForLandscape)
            .translatedBy(x: 0, y: yTranslation)
    }
    
    /// Show or hide the image from NavBar while going to next screen or back to initial screen
    ///
    /// - Parameter show: show or hide the image from NavBar
    private func showImage(_ show: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.filterButton.alpha = show ? 1.0 : 0.0
        }
    }
    
    private func showTutorialAlert() {
        let alert = UIAlertController(title: "Tutorial", message: "Scroll down and up to resize the image in navigation bar.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Got it!", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func moveAndResizeImageForPortrait() {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        filterButton.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    // Filter button clicked
    @objc func filterButtonTouchedUpInside() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchRssFeed")
        guard (vc != nil) else {
            return
        }
        presentAsStork(vc!, height: CGFloat.init(350))
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        useLargeCells = settingsService.useLargeContentMode()
        if(useLargeCells == true) {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
        
        
        tableView.reloadData()
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let shoulResize = shoulResize
            else { assertionFailure("shoulResize wasn't set. reason could be non-handled device orientation state"); return }
        
        if shoulResize {
            moveAndResizeImageForPortrait()
        }
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
       
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(useLargeCells == true)
        {
            return 280
        }
        else {
            return 110
        }
    }
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 20
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 20
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 14
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 14
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 17.5
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
        /// Image height/width for Landscape state
        static let ScaleForImageSizeForLandscape: CGFloat = 0.65
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        
        //Override the instance of suggestions table view, allowing for searchbar to be shown.
        self.suggestsionsTableView = SearchSuggestionsTableView.init(frame: CGRect.init(x: 0, y: searchBar.frame.height, width: view.frame.width, height: view.frame.height - searchBar.frame.height))
        
        self.shoulResize = true
        self.searchBar.delegate = self
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        navigationController?.navigationBar.tintColor = AppColours().info
        registerForPreviewing(with: self, sourceView: tableView)
        
        //Dismis keyboard on none-text entry tap
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.navigationController?.navigationBar.addGestureRecognizer(tap)

        viewModel.refresh(completionHandler: {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
        filterButton.addTarget(self, action:#selector(self.filterButtonTouchedUpInside), for: .touchUpInside)

       
        
        if UIDevice.current.orientation.isPortrait {
            shoulResize = true
        } else if UIDevice.current.orientation.isLandscape {
            shoulResize = false
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(filterButton)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            filterButton.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            filterButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            filterButton.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            filterButton.widthAnchor.constraint(equalTo: filterButton.heightAnchor)
            ])
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let shoulResize = shoulResize
            else { assertionFailure("shoulResize wasn't set. reason could be non-handled device orientation state"); return }
        
        if shoulResize {
            moveAndResizeImageForPortrait()
        }
    }

    
   
    
    
    // MARK: - UITableViewController Overrides
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.blogPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: BlogPostTableViewCell
        if useLargeCells == true {
            cell = tableView.dequeueReusableCell(withIdentifier: "largePostCell", for: indexPath) as! BlogPostTableViewCell

        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! BlogPostTableViewCell
        }
        
        let blogPost = viewModel.blogPosts[indexPath.row]
        
        cell.moreButtonAction = { [unowned self] in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "shareSheet") as! ShareSheetTableViewController
            
            vc.blogPost = blogPost
            self.presentAsStork(vc, height: 270)
            
        }
        
        
        
        let url = URL(string: blogPost.primaryImage.contentUrl)
        cell.primaryImageView.kf.setImage(with: url, options: [.transition(.fade(0.5))])
        cell.primaryImageView.layer.cornerRadius = 8
        cell.primaryImageView.layer.borderWidth = 1
        cell.primaryImageView.layer.borderColor = UIColor.clouds.cgColor
        
        cell.primaryImageView.layer.shadowColor = UIColor.black.cgColor
        cell.primaryImageView.layer.shadowOpacity = 1
        cell.primaryImageView.layer.shadowOffset = .zero
        cell.primaryImageView.layer.shadowRadius = 10
        
        cell.titleLabel.text = blogPost.title
        cell.sourceLabel.text = blogPost.source
        return cell
    }
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let blogPost = viewModel.blogPosts[indexPath.row]
        if let url = URL(string: blogPost.url) {
            /*
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            config.barCollapsingEnabled = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            vc.preferredBarTintColor = UIColor.black
            vc.preferredControlTintColor = UIColor.white
            present(vc, animated: true)
 */
            
            let properties = ["Title" : blogPost.title, "URL" : blogPost.url];
            MSAnalytics.trackEvent("Blog Post Tapped", withProperties: properties)

            browserService.openUrl(url: url)
            saveToSpotlight(blogPost: blogPost)
        }
    }
    
    
    func saveToSpotlight(blogPost: BlogPost) {
        
        if(self.settingsService.spotlightIntegrationEnabled() == true){
            
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = blogPost.title
            attributeSet.thumbnailURL = URL.init(string: blogPost.primaryImage.contentUrl)
            attributeSet.contentURL = URL.init(string: blogPost.url)
            
            let item = CSSearchableItem(uniqueIdentifier: blogPost.identifier, domainIdentifier: "com.mikecodesdotnet.advocates", attributeSet: attributeSet)
            CSSearchableIndex.default().indexSearchableItems([item]) { error in
                if let error = error {
                    print("Indexing error: \(error.localizedDescription)")
                } else {
                    print("Search item successfully indexed!")
                }
            }
            
        }
        
    }
    
    //MARK: - Outlets
    @IBOutlet var searchBar: UISearchBar!
    
    
    
    // MARK: - Fields
    let viewModel = RssFeedViewModel()
    var useLargeCells = false
    let browserService = BrowsersService.init()
    let settingsService = SettingsService()

}
