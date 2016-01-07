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
    var seasons: [PCMediaItemSeason]? {
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
        return self.reviews?.count ?? self.seasons?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mediaReviewCell", forIndexPath: indexPath) as! PCReviewsRowTableViewCell
        
        if let reviews = self.reviews {
            cell.authorLabel.text = reviews[indexPath.row].author
            cell.contentLabel.text = reviews[indexPath.row].content
        }
        if let seasons = self.seasons {
            
            if seasons[indexPath.row].seasonNumber != "" {
                cell.authorLabel.text = "Season \(seasons[indexPath.row].seasonNumber)"
            }
            else {
                cell.authorLabel.text = "Season \(indexPath.row+1)"
            }
            
            cell.authorLabel.text?.appendContentsOf(" (\(seasons[indexPath.row].airDate.componentsSeparatedByString("-")[0]))")
            
            cell.contentLabel.text = "\(seasons[indexPath.row].episodeCount) Episodes"
        }
        
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
        
        if let _ = self.reviews {
            
            if self.selectedIndex == indexPath.row  {
                self.selectedIndex = -1
            }
            else {
                self.selectedIndex = indexPath.row
            }
            
        }
        else {
            self.reviewTable.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }

}
