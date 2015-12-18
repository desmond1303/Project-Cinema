//
//  TableViewController.swift
//  test
//
//  Created by Dino Praso on 13.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PCFeedTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UIViewControllerPreviewingDelegate {
    
    var mediaItems = [String:[PCMediaItem]]()
    var searchResult: PCMediaItem?
    
    var searchController: UISearchController?
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let resultsTable = searchController.searchResultsController as! PCSearchTableViewController
        resultsTable.tableView.frame.origin = CGPoint(x: 0, y: 64)
        resultsTable.tableView.frame.size.height = self.tableView.frame.height - 64
        resultsTable.tableView.contentInset = UIEdgeInsetsZero
        resultsTable.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        resultsTable.parentController = self
        
        let url = "https://api.themoviedb.org/3/search/multi"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1", "query":"\(self.searchController!.searchBar.text!)"]
        
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                resultsTable.searchResults = response.result.value
                resultsTable.tableView.reloadData()
        }
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        self.searchController!.searchResultsController?.dismissViewControllerAnimated(false, completion: nil)
        searchBar.text = nil
    }
    
    func dismissSearchTable() {
        self.searchBarCancelButtonClicked(self.searchController!.searchBar)
    }
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRowAtPoint(location),
            cell = tableView.cellForRowAtIndexPath(indexPath) as? PCFeedTableViewCell else { return nil }
        
        guard let collectionIndexPath = cell.collectionView.indexPathForItemAtPoint(location),
            collectionCell = cell.collectionView.cellForItemAtIndexPath(collectionIndexPath) as? PCMediaItemCollectionViewCell else { return nil }
        
        guard let destinationViewController = storyboard?.instantiateViewControllerWithIdentifier("PCMainDetailsTableViewController") as? PCMainDetailsTableViewController else { return nil }

        destinationViewController.movie = collectionCell.movie
        
        destinationViewController.preferredContentSize = CGSize(width: 0.0, height: 0.0)
        
        previewingContext.sourceRect = collectionCell.frame
        
        return destinationViewController
        
    }
    
    /*
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        let tableRowIndexPath = self.tableView.indexPathForRowAtPoint(location)
        let tableRowCell = self.tableView.cellForRowAtIndexPath(tableRowIndexPath!) as! PCFeedTableViewCell
        
        let collectionCellIndexPath = tableRowCell.collectionView.indexPathForItemAtPoint(location)
        let collectionViewCell = tableRowCell.collectionView.cellForItemAtIndexPath(collectionCellIndexPath!) as! PCMediaItemCollectionViewCell
        
        let detailsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PCMainDetailsTableViewController") as! PCMainDetailsTableViewController
        
        detailsViewController.movie = collectionViewCell.movie
        detailsViewController.preferredContentSize = CGSize(width: 0, height: 300)
        
        previewingContext.sourceRect = collectionViewCell.frame
        
        return detailsViewController
    }
    */
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
        
        //self.presentViewController(viewControllerToCommit, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        showDetailViewController(viewControllerToCommit, sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        self.tableView.scrollsToTop = true
        
        let searchRresultsController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchTableViewController")
        
        self.searchController = UISearchController(searchResultsController: searchRresultsController)
        
        self.searchController!.searchResultsUpdater = self;
        
        self.searchController!.hidesNavigationBarDuringPresentation = false
        self.searchController!.dimsBackgroundDuringPresentation = false
        
        self.searchController!.searchBar.searchBarStyle = .Default
        self.searchController?.searchBar.placeholder = "Search for Movies or TV Shows"
        self.searchController!.searchBar.tintColor = UIColor.lightTextColor()
        
        self.navigationItem.titleView = self.searchController!.searchBar
        
        self.refreshControl?.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
        
        var url = "https://api.themoviedb.org/3/movie/popular"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                self.mediaItems["popular_movies"] = response.result.value
                self.tableView.reloadData()
        }
        
        url = "https://api.themoviedb.org/3/movie/top_rated"
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                self.mediaItems["top_rated_movies"] = response.result.value
                self.tableView.reloadData()
        }
        
        url = "https://api.themoviedb.org/3/movie/upcoming"
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                self.mediaItems["upcoming_movies"] = response.result.value
                self.tableView.reloadData()
        }
        
        url = "https://api.themoviedb.org/3/tv/popular"
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                self.mediaItems["popular_tv"] = response.result.value
                self.tableView.reloadData()
        }
        
        url = "https://api.themoviedb.org/3/tv/top_rated"
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                self.mediaItems["top_rated_tv"] = response.result.value
                self.tableView.reloadData()
        }
        
    }
    
    func refreshTableView(sender:AnyObject) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("collectionContainerCell", forIndexPath: indexPath) as! PCFeedTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.cellTitleLabel.text = "Most Popular Movies"
            cell.movies = self.mediaItems["popular_movies"]
        case 1:
            cell.cellTitleLabel.text = "Top Rated Movies"
            cell.movies = self.mediaItems["top_rated_movies"]
        case 2:
            cell.cellTitleLabel.text = "Upcoming Movies"
            cell.movies = self.mediaItems["upcoming_movies"]
        case 3:
            cell.cellTitleLabel.text = "Most Popular TV Shows"
            cell.movies = self.mediaItems["popular_tv"]
        case 4:
            cell.cellTitleLabel.text = "Top Rated TV Shows"
            cell.movies = self.mediaItems["top_rated_tv"]
        default: break
        }
        
        cell.collectionView.scrollsToTop = false
        return cell
        
    }
    
    // MARK: - Navigation
    
    var requestFromUrl = false
    var urlRequest = ""
    
    func showDetailsForMediaItem(itemId: String, type: String) {
        self.requestFromUrl = true
        self.urlRequest = itemId
        //self.performSegueWithIdentifier("showMediaItemDetailPage", sender: self)
    }
    
    var requestFromActivity: Bool = false
    var mediaItemActivityData = [NSObject: AnyObject]()
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        self.mediaItemActivityData = activity.userInfo!
        self.requestFromActivity = true
        self.performSegueWithIdentifier("showMediaItemDetailPage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! PCMainDetailsTableViewController
        
        if self.requestFromActivity {
            let realm = try! Realm()
            let mediaItemIdentifiers = self.mediaItemActivityData["kCSSearchableItemActivityIdentifier"]!.componentsSeparatedByString("_")
            let movie = realm.objects(PCMediaItem).filter("itemType = '\(mediaItemIdentifiers[0])' AND itemId = \(mediaItemIdentifiers[1])")
            destinationViewController.title = movie[0].title
            destinationViewController.movie = movie[0]
            self.requestFromActivity = false
        }
        else if self.requestFromUrl {
            //let realm = try! Realm()
            //let object = realm.objects(PCMediaItem).filter("itemType = 'movie' AND itemId = \(self.urlRequest)")[0]
            //destinationViewController.movie = object
            //destinationViewController.title = object.title
        }
        else if let senderCell = sender as? PCMediaItemCollectionViewCell {
            destinationViewController.title = senderCell.movie?.title
            destinationViewController.movie = senderCell.movie
        }
        else if let searchResult = self.searchResult {
            destinationViewController.title = searchResult.title
            destinationViewController.movie = searchResult
        }
        
        self.searchBarCancelButtonClicked(self.searchController!.searchBar)
    }
    
}
