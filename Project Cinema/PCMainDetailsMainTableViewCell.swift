//
//  PCMainDetailsMainTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCMainDetailsMainTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRuntimeAndGenres: UILabel!
    @IBOutlet weak var movieBackdropImageView: UIImageView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var movieDetailsMainSubTableView: UITableView!
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
        
    var isFav: Bool? = false
    
    var movie: PCMediaItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if isFav == true {
            self.favoriteButtonOutlet.setImage(UIImage(named: "FavoritesFullBarIcon"), forState: UIControlState.Normal)
        }
        else {
            self.favoriteButtonOutlet.setImage(UIImage(named: "FavoritesOutlineBarIcon"), forState: UIControlState.Normal)
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("movieDescriptionCell", forIndexPath: indexPath) as! PCMainDetailsDescriptionTableViewCell
            
            cell.movieOverviewLabel.text = movie!.overview
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("movieTraillerCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Watch Trailer"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return CGFloat(125)
        default:
            return CGFloat(44)
        }
        
    }
    
    var parentViewController: PCMainDetailsTableViewController?
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row != 0 {
            return
        }
        
        let alertController = UIAlertController(title: "\(self.movie!.title)", message: "\(self.movie!.overview)", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let textAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            self.movieDetailsMainSubTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        alertController.addAction(textAction)
        
        self.parentViewController?.presentViewController(alertController, animated: true) { () -> Void in
            //code
        }
    }
    
}
