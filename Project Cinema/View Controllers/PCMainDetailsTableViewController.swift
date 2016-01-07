//
//  PCMainDetailsTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import RealmSwift

import CoreSpotlight
import MobileCoreServices

class PCMainDetailsTableViewController: UITableViewController {
    
    var lastActivity: NSUserActivity?
    
    @IBAction func favoriteButton(sender: AnyObject) {
        
        let sender = sender as! UIButton
        
        sender.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        UIView.animateWithDuration(1.0,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 10,
            options: .CurveLinear,
            animations: {
                sender.transform = CGAffineTransformIdentity
            },
            completion: nil
        )
        
        if currentMediaItemIsInFav {
            let realmObject = realm.objects(PCMediaItem).filter("itemId = \(self.movie!.itemId) AND itemType = '\(self.movie!.itemType)'").first!
            
            self.movie = PCMediaItem(object: realmObject)
            
            try! self.realm.write {
                    
            CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(["\(realmObject.itemType)_\(realmObject.itemId)"]) { (error: NSError?) -> Void in
                    //code
                }
                self.realm.delete(realmObject)
                self.currentMediaItemIsInFav = false
                sender.setImage(UIImage(named: "FavoritesOutlineBarIcon"), forState: UIControlState.Normal)
            }
            
        }
        else {
            let realmObject = PCMediaItem(object: self.movie!)
            try! self.realm.write {
                self.realm.add(realmObject)
                
                self.currentMediaItemIsInFav = true
                sender.setImage(UIImage(named: "FavoritesFullBarIcon"), forState: UIControlState.Normal)
            }
            
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            
            attributeSet.title = self.movie!.title

            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = .ShortStyle
            
            attributeSet.contentDescription = "\(self.movie!.releaseDate.componentsSeparatedByString("-")[0])\n\(self.movie!.voteAverage)/10"
            attributeSet.relatedUniqueIdentifier = "\(self.movie!.itemType)_\(self.movie!.itemId)"
            var keywords = self.movie!.title.componentsSeparatedByString(" ")
            keywords.append(self.movie!.title)
            keywords.append(self.movie!.itemType)
            attributeSet.keywords = keywords
            
            // NSUseractiviyy Start

            let activity = NSUserActivity(activityType: "com.atlantbh.Project-Cinema.openDetailsView")
            activity.title = self.movie!.title
            activity.userInfo = ["type": self.movie!.itemType, "id": self.movie!.itemId]
            activity.keywords = Set(keywords)
            activity.contentAttributeSet = attributeSet
            activity.eligibleForHandoff = false
            activity.eligibleForSearch = true
            //activity.eligibleForPublicIndexing = true
            //activity.expirationDate = NSDate()
            
            self.lastActivity = activity
            activity.becomeCurrent()
            
            let item = CSSearchableItem(uniqueIdentifier: "\(self.movie!.itemType)_\(self.movie!.itemId)", domainIdentifier: "MediaItems", attributeSet: attributeSet)
            
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error) -> Void in
                if error != nil {
                    print(error?.localizedDescription)
                }
                else {
                    // Items were indexed successfully
                }
            }

            let notification:UILocalNotification = UILocalNotification()
            notification.category = "Entertainment"
            notification.alertAction = "OK!"
            notification.alertBody = "\(self.movie!.title) is about to hit theatres!"
            notification.timeZone = NSTimeZone.defaultTimeZone()
            let dateMaker = NSDateFormatter()
            dateMaker.dateFormat = "yyyy-MM-dd HH-mm"
            notification.fireDate = dateMaker.dateFromString("\(self.movie!.releaseDate) 12-00")
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        
    }
    
    var movie: PCMediaItem?
    
    var cast: [PCMediaItemCast]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var crew: [PCMediaItemCrew]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var reviews: [PCMediaReview]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    var seasons: [PCMediaSeason]? {
        didSet {
            self.tableView.reloadData()
        }
    }

    var sessionId: String?
    var userRating: Int? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var preferedRowHeight: CGFloat = 52 {
        willSet {
            print(newValue)
        }
    }
    var selectedReviewRow: Int = -1 {
        didSet {
            //self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .Automatic)
            self.tableView.reloadData()
        }
    }
    
    var currentMediaItemIsInFav: Bool = false
    let realm = try! Realm()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let thisMovieInRealm = self.realm.objects(PCMediaItem).filter("itemId = \(self.movie!.itemId) AND itemType = '\(self.movie!.itemType)'")
        
        if thisMovieInRealm.count > 0 {
            self.currentMediaItemIsInFav = true
            self.tableView.reloadData()
        }
        else {
            self.currentMediaItemIsInFav = false
            self.tableView.reloadData()
        }
        
        // Check Login
        
        let session = self.realm.objects(Session)
        
        if let sessionId = session.first?.sessionId {
            self.sessionId = sessionId
            
            // Get User Rating
            
            var allRated = [PCMediaItem]()
            
            var itemType: String = ""
            
            if self.movie!.itemType == "movie" {
                itemType = "movies"
            }
            else {
                itemType = "tv"
            }
            
            let url = "https://api.themoviedb.org/3/account/\(self.movie!.itemId)/rated/\(itemType)"
            let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1", "session_id":sessionId]
            Alamofire
                .request(.GET, url, parameters: urlParamteres)
                .responseArray ("results") { (response4: Response<[PCMediaItem], NSError>) in
                    allRated = response4.result.value!
                    
                    for ratedItem in allRated {
                        if ratedItem.itemType == self.movie?.itemType && ratedItem.itemId == self.movie?.itemId {
                            self.userRating = ratedItem.rating
                        }
                    }
            }
        }
        
    }
    
    @IBAction func shareButtonAction(sender: AnyObject) {
        let objectsToShare: [String] = ["You should check out \(self.movie!.title)!", "https://www.themoviedb.org/\(self.movie!.itemType)/\(self.movie!.itemId)"]
        let activityController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityController.setValue(self.movie!.title, forKey: "Subject")
        self.presentViewController(activityController, animated: true) { () -> Void in
            //code
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        
        self.refreshControl?.addTarget(self, action: "refreshTableView:", forControlEvents: UIControlEvents.ValueChanged)
        
        let dateMaker = NSDateFormatter()
        dateMaker.dateFormat = "yyyy-MM-dd"
        let todayString = dateMaker.stringFromDate(NSDate())
        
        let todaysStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayString)'").first
        
        try! realm.write {
            if self.movie!.itemType == "movie" {
                todaysStatObject?.movieCount++
            }
            else {
                todaysStatObject?.tvCount++
            }
            self.realm.add(todaysStatObject!, update: true)
        }
        
        
        
        let url = "https://api.themoviedb.org/3/\(self.movie!.itemType)/\(self.movie!.itemId)"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseObject { (response: Response<PCMediaItem, NSError>) in
                self.movie = response.result.value
                
                if self.currentMediaItemIsInFav {
                    try! self.realm.write {
                        self.realm.add(self.movie!, update: true)
                    }
                }
        }
        
        
        if let movie = self.movie {
            var url = "https://api.themoviedb.org/3/\(movie.itemType)/\(movie.itemId)/credits"
            Alamofire
                .request(.GET, url, parameters: urlParamteres)
                .responseArray("cast") { (response: Response<[PCMediaItemCast], NSError>) in
                    self.cast = response.result.value
                }
                .responseArray("crew") { (response: Response<[PCMediaItemCrew], NSError>) in
                    self.crew = response.result.value
            }
            
            if self.movie?.itemType == "movie" {
                url = "https://api.themoviedb.org/3/movie/\(self.movie!.itemId)/reviews"
                Alamofire
                    .request(.GET, url, parameters: urlParamteres)
                    .responseArray("results") { (response: Response<[PCMediaReview], NSError>) in
                        self.reviews = response.result.value
                }
            }
            else {
                url = "https://api.themoviedb.org/3/tv/\(self.movie!.itemId)/season/"
                Alamofire
                    .request(.GET, url, parameters: urlParamteres)
                    .responseArray { (response: Response<[PCMediaSeason], NSError>) in
                        self.seasons = response.result.value
                }
                
            }

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableView(sender:AnyObject?) {
        self.viewWillAppear(false)
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return self.reviews?.count > 0 || self.seasons?.count > 0 ? 1 : 0
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCellWithIdentifier("movieMainCell", forIndexPath: indexPath) as! PCMainDetailsMainTableViewCell
                cell.parentViewController = self
                cell.movieBackdropImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w780/\(movie!.backdropPath)"), placeholderImage: UIImage(named: "placeholder"))
                cell.movie = movie
                cell.isFav = self.currentMediaItemIsInFav
                if self.currentMediaItemIsInFav {
                    cell.favoriteButtonOutlet.setImage(UIImage(named: "FavoritesFullBarIcon"), forState: UIControlState.Normal)
                }
                else {
                    cell.favoriteButtonOutlet.setImage(UIImage(named: "FavoritesOutlineBarIcon"), forState: UIControlState.Normal)
                }
                
                let attributedMediaTitleString = NSMutableAttributedString(string: "\(self.movie!.title) ")
                let attrs = [NSFontAttributeName : UIFont.systemFontOfSize(12.0)]
                
                var runtimeAndGenres = ""
                
                if self.movie!.itemType == "movie" {
                    let gString = NSMutableAttributedString(string: "(\(self.movie!.releaseDate.componentsSeparatedByString("-")[0]))", attributes:attrs)
                    attributedMediaTitleString.appendAttributedString(gString)
                    
                    runtimeAndGenres = "\(self.movie!.runtime/60)h \(self.movie!.runtime%60)m"
                }
                else {
                    
                    let gString = NSMutableAttributedString(string: "(\(self.movie!.firstAirDate.componentsSeparatedByString("-")[0]) - \(self.movie!.inProduction ? "Present" : self.movie!.lastAirDate.componentsSeparatedByString("-")[0]))", attributes:attrs)
                    attributedMediaTitleString.appendAttributedString(gString)
                    
                    //runtimeAndGenres = "\(self.episodeRuntimes![0]/60)h \(self.episodeRuntimes![0]%60)m - \(self.episodeRuntimes![1]/60)h \(self.episodeRuntimes![1]%60)m"
                }
                
                var genresString = ""
                
                if self.movie!.genres.count > 0 && self.movie!.itemType == "movie" {
                    genresString = " | "
                }
                
                for genre in self.movie!.genres {
                    
                    genresString.appendContentsOf(genre.name)
                    
                    if genre != self.movie!.genres.last {
                        genresString.appendContentsOf(", ")
                    }
                    
                }
                
                runtimeAndGenres.appendContentsOf(genresString)
                
                cell.movieTitleLabel.attributedText = attributedMediaTitleString
                cell.movieRuntimeAndGenres.text = runtimeAndGenres
                cell.moviePosterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w185/\(movie!.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("movieRatingCell", forIndexPath: indexPath) as! PCMainDetailsRatingTableViewCell
                
                cell.ratingProgress(Float(movie!.voteAverage))
                cell.parentViewController = self
                cell.userRating = self.userRating
                
                let ratingAttributedString = NSMutableAttributedString(string: "\(movie!.voteAverage)")
                ratingAttributedString.appendAttributedString(NSAttributedString(string: "\n\(movie!.voteCount)", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(10.0)]))
                
                cell.ratingLabel.attributedText = ratingAttributedString
                
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("movieMainCell", forIndexPath: indexPath)
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("castCollectionCell", forIndexPath: indexPath) as! PCMainDetailsCastTableViewCell
            cell.cast = self.cast
            
            cell.collectionView.scrollsToTop = false
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("reviewTableCell", forIndexPath: indexPath) as! PCMainDetialsReviewTableViewCell
            
            cell.reviewTable.scrollsToTop = false
            
            if self.movie!.itemType == "movie" {
                cell.cellTitleLabel.text = "Reviews"
                cell.reviews = self.reviews
            }
            else {
                cell.cellTitleLabel.text = "Seasons"
                cell.seasons = self.seasons
            }
            
            cell.parentViewController = self
            
            return cell
        default:
            break
        }
        return tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return 377
            default:
                return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            }
        case 1:
            return 213
        case 2:
            if self.selectedReviewRow != -1 {
                return CGFloat(37 + (52 * CGFloat(self.reviews!.count - 1)) + self.preferedRowHeight)
            }
            return CGFloat(37 + (52 * CGFloat(self.reviews!.count)))
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTrailers" {
            let destinationViewController = segue.destinationViewController as! PCTrailersTableViewController
            destinationViewController.mediaItemType = self.movie!.itemType
            destinationViewController.mediaItemId = self.movie!.itemId
            destinationViewController.title = "Videos"
            let senderCell = sender as! UITableViewCell
            senderCell.selected = false
        }
        else if segue.identifier == "showRatingScreen" {
            let destinationViewController = segue.destinationViewController as! PCRatingTableViewController
            destinationViewController.movie = self.movie
        }
    }
    
    
}

