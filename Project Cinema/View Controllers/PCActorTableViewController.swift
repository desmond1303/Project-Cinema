//
//  PCActorTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 8.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire

class PCActorTableViewController: UITableViewController {
    
    var actorId: Int = 0 {
        didSet {
            self.loadActor(withId: self.actorId)
        }
    }
    
    var actor: PCPerson? {
        didSet {
            self.navigationItem.title = self.actor!.name
            self.loadActorImages()
            self.tableView.reloadData()
        }
    }
    
    var actorImages = [PCPersonTaggedImage]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var moviesAppearedIn = [PCPersonCredit]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tvAppearedIn = [PCPersonCredit]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func loadActor(withId id: Int) {
        let url = "https://api.themoviedb.org/3/person/\(self.actorId)"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseObject { (response: Response<PCPerson, NSError>) in
                self.actor = response.result.value
        }
    }
    
    func loadActorImages() {
        let url = "https://api.themoviedb.org/3/person/\(self.actorId)/tagged_images"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray ("results") { (response: Response<[PCPersonTaggedImage], NSError>) in
                self.actorImages = response.result.value!
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://api.themoviedb.org/3/person/\(self.actorId)/movie_credits"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray ("cast") { (response: Response<[PCPersonCredit], NSError>) in
                self.moviesAppearedIn = response.result.value!
        }
        
        url = "https://api.themoviedb.org/3/person/\(self.actorId)/tv_credits"
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseArray ("cast") { (response: Response<[PCPersonCredit], NSError>) in
                self.tvAppearedIn = response.result.value!
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
        var rowCount = 0
        if self.moviesAppearedIn.count > 0 {
            rowCount++
        }
        if self.tvAppearedIn.count > 0 {
            rowCount++
        }
        return rowCount
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("mainActorCell", forIndexPath: indexPath) as! PCActorMainTableViewCell
            
            if let actor = self.actor {
                cell.actorNameLabel.text = actor.name
                cell.actorBiographyLabel.text = actor.biography
                cell.actorBirthdayLabel.text = "Born \(actor.birthday) in \(actor.placeOfBirth)"
                cell.actorProfileImageView.sd_setImageWithURL(NSURL(string: "https://image.tmdb.org/t/p/w185/\(actor.profilePath)"))
                
                if self.actorImages.count > 0 {
                    cell.actorBackdrop.sd_setImageWithURL(NSURL(string: "https://image.tmdb.org/t/p/w780/\(self.actorImages[0].filePath)"))
                }
            }
            
            return cell
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("appearedInCell", forIndexPath: indexPath) as! PCActorCreditsTableViewCell
            
            switch indexPath.row {
            case 0:
                cell.mediaItemIdentifier = "movie"
                cell.cellTitleLabel.text = "Movies"
                cell.movies = self.moviesAppearedIn
                
            default:
                cell.mediaItemIdentifier = "tv"
                cell.cellTitleLabel.text = "TV"
                cell.movies = self.tvAppearedIn
                
            }
            
            return cell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 377
        }
        else {
            return 213
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Actor Appeared In"
        }
        else {
            return nil
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! PCMainDetailsTableViewController
        
        if let senderCell = sender as? PCMediaItemCollectionViewCell {
            
            destinationViewController.movie = senderCell.movie
            destinationViewController.title = senderCell.movie?.title
            
        }

    }

}
