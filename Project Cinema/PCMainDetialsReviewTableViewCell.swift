//
//  PCMainDetialsReviewTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 3.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCMainDetialsReviewTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    var reviews: [PCMediaReview]? {
        didSet {
            self.reviewTable.reloadData()
        }
    }
    var seasons: [PCMediaSeason]? {
        didSet {
            self.reviewTable.reloadData()
        }
    }
    
    var parentViewController: PCMainDetailsTableViewController?
    
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
        return self.reviews?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mediaReviewCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.reviews![indexPath.row].author
        cell.detailTextLabel?.text = self.reviews![indexPath.row].content
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alertController = UIAlertController(title: "\(self.reviews![indexPath.row].author)", message: "\(self.reviews![indexPath.row].content)", preferredStyle: UIAlertControllerStyle.Alert)
        
        let textAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            self.parentViewController?.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        alertController.addAction(textAction)
        
        self.parentViewController?.presentViewController(alertController, animated: true) { () -> Void in
            //code
        }

        
    }

}
