//
//  PCMainDetailsMainTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift

class PCMainDetailsMainTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieBackdropImageView: UIImageView!
    @IBOutlet weak var moviePosterImageView: UIImageView!
    
    @IBOutlet weak var favoriteButtonOutlet: UIButton!
    @IBAction func favortieButtonAction(sender: UIButton) {
        
    }
    
    var movie: PCMediaItem?
    let realm = try! Realm()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}
