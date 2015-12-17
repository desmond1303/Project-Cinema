//
//  PCFavoritesTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift

import CoreSpotlight
import MobileCoreServices

class PCFavoritesTableViewController: UITableViewController {
    
    var favorites = [PCMediaItem]()
    
    func getRealmMovies() {
        let realmFavorites = try! Realm().objects(PCMediaItem).sorted("title")
        self.favorites.removeAll()
        for fav in realmFavorites {
            self.favorites.append(fav)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getRealmMovies()
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.scrollsToTop = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            let realmObject = try! Realm().objects(PCMediaItem).filter("itemId = \(self.favorites[indexPath.row].itemId)")
            try! Realm().write {
                for rObject in realmObject {
                    CSSearchableIndex.defaultSearchableIndex().deleteSearchableItemsWithIdentifiers(["\(rObject.itemType)_\(rObject.itemId)"], completionHandler: nil)
                    try! Realm().delete(rObject)
                }
            }
            
            self.favorites.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favorites.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteMovie", forIndexPath: indexPath) as! PCFavoritesTableViewCell

        cell.movie = self.favorites[indexPath.row]
        cell.posterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w92/\(self.favorites[indexPath.row].posterPath)"))
        
        let favTitleText = NSMutableAttributedString(string: self.favorites[indexPath.row].title)
        let attrsMedium = [NSFontAttributeName : UIFont.systemFontOfSize(12.0)]
        let attrsSmall = [NSFontAttributeName : UIFont.systemFontOfSize(10.0)]
        
        var date: String?
        if self.favorites[indexPath.row].itemType == "movie" {
            date = self.favorites[indexPath.row].release_date.componentsSeparatedByString("-")[0]
        }
        else {
            date = "From \(self.favorites[indexPath.row].first_air_date.componentsSeparatedByString("-")[0])"
        }
        
        favTitleText.appendAttributedString(NSAttributedString(string: "\n\(date!)", attributes: attrsMedium))
        favTitleText.appendAttributedString(NSAttributedString(string: "\n\(self.favorites[indexPath.row].voteAverage)/10", attributes: attrsSmall))
        
        cell.titleLabel.attributedText = favTitleText
    
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let senderCell = sender as? PCFavoritesTableViewCell
        let destinationViewController = segue.destinationViewController as! PCMainDetailsTableViewController
        
        destinationViewController.title = senderCell?.movie?.title
        destinationViewController.movie = senderCell?.movie
    }


}
