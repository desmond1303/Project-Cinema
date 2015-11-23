//
//  PCMainDetailsTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SDWebImage

class PCMainDetailsTableViewController: UITableViewController {
    
    var movie: PCMediaItem?
    var cast: [PCMediaItemCast]?
    var crew: [PCMediaItemCrew]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = self.movie {
            let url = "https://api.themoviedb.org/3/\(movie.itemType)/\(movie.itemId)/credits"
            let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
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
                
                cell.movieBackdropImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w1000/\(movie!.backdropPath)"),
                    completed: {
                        (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                        print(self)
                })
                cell.movie = movie
                cell.movieTitleLabel.text = movie!.title
                cell.moviePosterImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w342/\(movie!.posterPath)"),
                    completed: {
                        (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                        print(self)
                })
                
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

