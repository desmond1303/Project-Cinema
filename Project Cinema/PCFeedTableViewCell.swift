//
//  PCFeedTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import SDWebImage

class PCFeedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var edgeLeftMoreIndicator: UIImageView!
    @IBOutlet weak var edgeRightMoreIndicator: UIImageView!
    
    var movies: [PCMediaItem]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //Collection View Setup
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies?.count ?? 0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x <= 0 {
            self.edgeLeftMoreIndicator.alpha = 0
        }
        else if scrollView.contentOffset.x > 0 && scrollView.contentOffset.x <= 30 {
            self.edgeLeftMoreIndicator.alpha = scrollView.contentOffset.x / 30
        }
        else if scrollView.contentOffset.x > 30 {
            self.edgeLeftMoreIndicator.alpha = 1
        }
        
        if scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width {
            self.edgeRightMoreIndicator.alpha = 0
        }
        else if scrollView.contentOffset.x + scrollView.frame.size.width >= scrollView.contentSize.width - 30 && scrollView.contentOffset.x + scrollView.frame.size.width < scrollView.contentSize.width {
            self.edgeRightMoreIndicator.alpha = (scrollView.contentSize.width - (scrollView.contentOffset.x + scrollView.frame.size.width)) / 30
        }
        else if scrollView.contentOffset.x + scrollView.frame.size.width < scrollView.contentSize.width - 30 {
            self.edgeRightMoreIndicator.alpha = 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! PCMediaItemCollectionViewCell
        
        cell.movie = movies![indexPath.item]
        cell.movieTitleLabel.text = movies![indexPath.item].title
        cell.movieImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w342/\(movies![indexPath.item].posterPath)"),
            completed: {
                (image: UIImage!, error: NSError!, cacheType: SDImageCacheType!, imageURL: NSURL!) -> Void in
                //print(self)
        })
            
        cell.movieYearLabel.text = "2016"
        
        return cell
    }
    
}