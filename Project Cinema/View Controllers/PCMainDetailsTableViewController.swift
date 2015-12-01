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
import Social

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
            let realmObject = realm.objects(PCMediaItem).filter("itemId = \(self.movie!.itemId)")
            
            try! self.realm.write {
                for rObject in realmObject {
                    CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(["\(rObject.itemType)_\(rObject.itemId)"]) { (error: NSError?) -> Void in
                        //code
                    }
                    self.realm.delete(rObject)
                    self.currentMediaItemIsInFav = false
                    sender.setImage(UIImage(named: "FavoritesOutlineBarIcon"), forState: UIControlState.Normal)
                }
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
            
            attributeSet.contentDescription = "\(self.movie!.release_date.componentsSeparatedByString("-")[0])\n\(self.movie!.voteAverage)/10"
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
            notification.fireDate = dateMaker.dateFromString("\(self.movie!.release_date) 12-00")
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
        
    }
    
    var movie: PCMediaItem?
    var cast: [PCMediaItemCast]?
    var crew: [PCMediaItemCrew]?
    
    var currentMediaItemIsInFav: Bool = false
    let realm = try! Realm()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let thisMovieInRealm = realm.objects(PCMediaItem).filter("itemId = \(movie!.itemId)")
        
        if thisMovieInRealm.count > 0 {
            self.currentMediaItemIsInFav = true
            self.tableView.reloadData()
        }
        else {
            self.currentMediaItemIsInFav = false
            self.tableView.reloadData()
        }
    }
    
    var animator:UIDynamicAnimator?
    
    func triggerFacebookShare() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func triggerTwitterShare() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            let tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareButtonAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Share \(self.movie!.title)", message: "Choose where to share this movie", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let faceookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.triggerFacebookShare()
        }
        let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.triggerTwitterShare()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            //
        }
        
        alertController.addAction(faceookAction)
        alertController.addAction(twitterAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            //code
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.scrollsToTop = true
        
        
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
                
                self.tableView.reloadData()
        }
        
        if let movie = self.movie {
            let url = "https://api.themoviedb.org/3/\(movie.itemType)/\(movie.itemId)/credits"
            Alamofire
                .request(.GET, url, parameters: urlParamteres)
                .responseArray("cast") { (response: Response<[PCMediaItemCast], NSError>) in
                    self.cast = response.result.value
                    self.tableView.reloadData()
                }
                .responseArray("crew") { (response: Response<[PCMediaItemCrew], NSError>) in
                    self.crew = response.result.value
                    self.tableView.reloadData()
            }

        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
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
                cell.movieBackdropImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w1000/\(movie!.backdropPath)"))
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
                let gString = NSMutableAttributedString(string: "(\(self.movie!.release_date.componentsSeparatedByString("-")[0]))", attributes:attrs)
                
                attributedMediaTitleString.appendAttributedString(gString)
                
                
                cell.movieTitleLabel.attributedText = attributedMediaTitleString
                cell.movieRuntimeAndGenres.text = "\(self.movie!.runtime/60)h \(self.movie!.runtime%60)m"
                cell.moviePosterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w342/\(movie!.posterPath)"))
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCellWithIdentifier("movieRatingCell", forIndexPath: indexPath) as! PCMainDetailsRatingTableViewCell
                
                cell.ratingProgrssView.progress = Float(movie!.voteAverage/10)
                cell.ratingLabel.text = "\(movie!.voteAverage) | \(movie!.voteCount) votes"
                
                return cell
            default:
                let cell = tableView.dequeueReusableCellWithIdentifier("movieMainCell", forIndexPath: indexPath)
                return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("castCollectionCell", forIndexPath: indexPath) as! PCMainDetailsCastTableViewCell
            cell.cast = self.cast
            
            cell.collectionView.scrollsToTop = false
            cell.collectionView.reloadData()
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
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
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
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

