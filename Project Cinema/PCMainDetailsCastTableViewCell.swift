//
//  PCMainDetailsCastTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class PCMainDetailsCastTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cast: [PCMediaItemCast]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTitleLabel.text = "Cast"
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cast?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("castMemberCell", forIndexPath: indexPath) as! PCMediaItemCollectionViewCell
        if let cast = self.cast {
            cell.movieTitleLabel.text = cast[indexPath.item].name
            cell.movieYearLabel.text = cast[indexPath.item].character
            cell.movieImageView.sd_setImageWithURL(NSURL(string: "http://image.tmdb.org/t/p/w342/\(cast[indexPath.item].profilePath)"))
            
        }
        return cell
    }
    
}
