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

class PCFeedTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UIViewControllerPreviewingDelegate, PCNetworkDependant {
    
    var mediaItems = [String:PCQueryResponse]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    let requests = [
        ("popular", "movie", 1),
        ("top_rated", "movie", 1),
        ("upcoming", "movie", 1),
        ("popular", "tv", 1),
        ("top_rated", "tv", 1)
    ]
    
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
    
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {

        showDetailViewController(viewControllerToCommit, sender: self)
        
    }
    
    var noNetworkBanner: UIView?
    var hasConnection: Bool? {
        didSet {
            if self.hasConnection! {
                self.getFeedData(self.requests)
                self.noNetworkBanner?.removeFromSuperview()
            }
            else {
                self.view.addSubview(self.noNetworkBanner!)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.hasConnection = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noNetworkBanner = PCNoNetworkView.getView(self.tableView.frame.width)
        
        if traitCollection.forceTouchCapability == .Available {
            registerForPreviewingWithDelegate(self, sourceView: self.view)
        }
        
        self.tableView.scrollsToTop = true
        
        let searchRresultsController = self.storyboard?.instantiateViewControllerWithIdentifier("SearchTableViewController")
        
        self.searchController = UISearchController(searchResultsController: searchRresultsController)
        
        self.searchController?.searchResultsUpdater = self;
        
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.searchController?.dimsBackgroundDuringPresentation = false
        
        self.searchController?.searchBar.searchBarStyle = .Default
        self.searchController?.searchBar.placeholder = "Search for Movies or TV Shows"
        self.searchController?.searchBar.tintColor = UIColor.lightTextColor()
        
        self.navigationItem.titleView = self.searchController!.searchBar
        
        self.refreshControl?.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refreshTableView(sender:AnyObject) {
        self.mediaItems = [:]
        self.tableView.reloadData()
        
        self.getFeedData(self.requests) {
            self.refreshControl?.endRefreshing()
        }
        self.refreshControl?.endRefreshing()
    }
    
    func getFeedData(categotyPagePairs: [(String, String, Int)], completionHandler: (()->(Void))? = nil) {
        
        for (category, type, page) in categotyPagePairs {
            
            let url = "https://api.themoviedb.org/3/\(type)/\(category)"
            let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1", "page":"\(page)"]
            
            Alamofire
                .request(.GET, url, parameters: urlParamteres)
                .responseObject { (response: Response<PCQueryResponse, NSError>) in
                    let dictionaryIdentifier = "\(category).\(type)"
                    if self.mediaItems[dictionaryIdentifier] == nil || page == 1 {
                        self.mediaItems[dictionaryIdentifier] = response.result.value
                    }
                    else {
                        self.mediaItems[dictionaryIdentifier]?.page = response.result.value!.page!
                        self.mediaItems[dictionaryIdentifier]?.results?.appendContentsOf(response.result.value!.results!)
                        self.tableView.reloadData()
                    }
            }
            
        }
        
        completionHandler?()
        
    }
    
    func loadAnotherPage(forDictionaryIdentifier dictionaryIdentifier: String) {
        if self.mediaItems[dictionaryIdentifier]?.page < self.mediaItems[dictionaryIdentifier]?.total_pages {
            let newPage = self.mediaItems[dictionaryIdentifier]!.page! + 1
            let splitIdentifier = dictionaryIdentifier.componentsSeparatedByString(".")
            
            self.getFeedData([(splitIdentifier[0], splitIdentifier[1], newPage)])
        }
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
            cell.movies = self.mediaItems["popular.movie"]?.results
            cell.dictionaryIdentifier = "popular.movie"
        case 1:
            cell.cellTitleLabel.text = "Top Rated Movies"
            cell.movies = self.mediaItems["top_rated.movie"]?.results
            cell.dictionaryIdentifier = "top_rated.movie"
        case 2:
            cell.cellTitleLabel.text = "Upcoming Movies"
            cell.movies = self.mediaItems["upcoming.movie"]?.results
            cell.dictionaryIdentifier = "upcoming.movie"
        case 3:
            cell.cellTitleLabel.text = "Most Popular TV Shows"
            cell.movies = self.mediaItems["popular.tv"]?.results
            cell.dictionaryIdentifier = "popular.tv"
        case 4:
            cell.cellTitleLabel.text = "Top Rated TV Shows"
            cell.movies = self.mediaItems["top_rated.tv"]?.results
            cell.dictionaryIdentifier = "top_rated.tv"
        default: break
        }
        
        cell.parentViewController = self
        
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
