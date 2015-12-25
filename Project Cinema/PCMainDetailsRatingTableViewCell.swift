//
//  PVMainDetailsRatingTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCMainDetailsRatingTableViewCell: UITableViewCell {
    
    @IBOutlet weak private var ratingStarsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var rateThisTableView: UITableView!
    
    var parentViewController: PCMainDetailsTableViewController?
    var userRating: Int? {
        didSet {
            self.rateThisTableView.reloadData()
        }
    }
    
    func ratingProgress(progress: Float) {
        
        let stars = NSMutableAttributedString(string: "\u{f005} \u{f005} \u{f005} \u{f005} \u{f005}", attributes: [NSFontAttributeName: UIFont(name: "FontAwesome", size: 16)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        var numberOfFilledStars: Int = 0
        switch progress {
        case 0...1.9:
            numberOfFilledStars = 1
        case 2.0...3.9:
            numberOfFilledStars = 3
        case 4.0...5.9:
            numberOfFilledStars = 5
        case 6.0...7.9:
            numberOfFilledStars = 7
        default:
            numberOfFilledStars = 9
        }
        
        stars.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location:0,length:numberOfFilledStars))
        
        self.ratingStarsLabel.attributedText = stars
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension PCMainDetailsRatingTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rateThisCell", forIndexPath: indexPath) as! PCMainDetailsRateThisTableViewCell
        let star = NSMutableAttributedString(string: "\u{f005} ", attributes: [NSFontAttributeName: UIFont(name: "FontAwesome", size: 16)!, NSForegroundColorAttributeName: UIColor.redColor()])
        if let rate = self.userRating {
            star.appendAttributedString(NSAttributedString(string: "\(rate)"))
            cell.givenRating.attributedText = star
        }
        else {
            cell.givenRating.attributedText = NSAttributedString(string: "No Rating Yet", attributes: [NSFontAttributeName: UIFont.systemFontOfSize(1), NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.parentViewController?.performSegueWithIdentifier("showRatingScreen", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
