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

class PCFeedTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    var mediaItems = [String:[PCMediaItem]]()
    var searchResult: PCMediaItem?
    
    let searchController = UISearchController(searchResultsController: PCSearchTableViewController())
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let resultsTable = searchController.searchResultsController as! PCSearchTableViewController
        resultsTable.tableView.frame.origin = CGPoint(x: 0, y: 64)
        resultsTable.tableView.frame.size.height = self.tableView.frame.height - 113
        resultsTable.tableView.tableHeaderView = nil
        resultsTable.tableView.contentInset = UIEdgeInsetsZero
        resultsTable.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        resultsTable.parentController = self
        //let resultCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "searchResultCell")
        resultsTable.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "searchResultCell")
        
        let url = "https://api.themoviedb.org/3/search/movie"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1", "query":"\(self.searchController.searchBar.text!)"]
        
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray("results") { (response: Response<[PCMediaItem], NSError>) in
                resultsTable.searchResults = response.result.value
                resultsTable.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        
//        let statusView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: -20), size: CGSize(width: self.navigationController!.navigationBar.frame.width , height: 20)))
//        statusView.backgroundColor = UIColor.blackColor()
//        statusView.alpha = 0.1
//        
//        self.navigationController?.navigationBar.addSubview(statusView)

        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.searchController.searchBar.placeholder = "Search for Movies or TV Shows"
        self.searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        self.searchController.searchBar.barStyle = UIBarStyle.Black
        UILabel.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = UIColor.lightTextColor()
        
        self.navigationItem.titleView = searchController.searchBar
        
        self.refreshControl?.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.None
    }
    
    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    // MARK: - Navigation
    
    var requestFromActivity: Bool = false
    var mediaItemActivityData = [NSObject: AnyObject]()
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        self.mediaItemActivityData = activity.userInfo!
        self.requestFromActivity = true
        self.performSegueWithIdentifier("showMediaItemDetailPage", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        else if let senderCell = sender as? PCMediaItemCollectionViewCell {
            destinationViewController.title = senderCell.movie?.title
            destinationViewController.movie = senderCell.movie
        }
        else if let searchResult = self.searchResult {
            self.searchController.searchResultsController?.dismissViewControllerAnimated(true, completion: nil)
            destinationViewController.title = searchResult.title
            destinationViewController.movie = searchResult
        }
        
    }
    
}
