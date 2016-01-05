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
        let cell = tableView.dequeueReusableCellWithIdentifier("mediaReviewCell", forIndexPath: indexPath) as! PCReviewsRowTableViewCell
        cell.authorLabel.text = self.reviews![indexPath.row].author
        cell.contentLabel.text = self.reviews![indexPath.row].content
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == self.selectedIndex {
            return self.parentViewController!.preferedRowHeight
        }
        
        return 52
    }
    
    var selectedIndex: Int = -1 {
        willSet {
            if newValue >= 0 {
                let font = UIFont.systemFontOfSize(14)
                let size = CGSizeMake(self.parentViewController!.tableView.frame.width-125, CGFloat.max)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .ByWordWrapping;
                let attributes = [NSFontAttributeName:font,
                    NSParagraphStyleAttributeName:paragraphStyle.copy()]
                
                let text = self.reviews![newValue].content! as NSString
                let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
                self.parentViewController?.preferedRowHeight = rect.size.height
            }
            else {
                self.parentViewController?.preferedRowHeight = 52
            }
        }
        didSet {
            self.parentViewController?.selectedReviewRow = self.selectedIndex
            self.reviewTable.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if self.selectedIndex == indexPath.row  {
            self.selectedIndex = -1
        }
        else {
            self.selectedIndex = indexPath.row
        }
        
    }

}
