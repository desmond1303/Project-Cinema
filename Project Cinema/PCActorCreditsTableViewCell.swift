//
//  PCActorCreditsTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 11.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire

class PCActorCreditsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var movies = [PCPersonCredit]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var mediaItemIdentifier: String?

}

extension PCActorCreditsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("castMemberCell", forIndexPath: indexPath) as! PCMediaItemCollectionViewCell
        
        let url = "https://api.themoviedb.org/3/\(self.mediaItemIdentifier!)/\(self.movies[indexPath.item].id!)"
        let urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseObject { (response: Response<PCMediaItem, NSError>) in
                cell.movie = response.result.value
        }

        if movies[indexPath.item].title != nil {
            cell.movieTitleLabel.text = self.movies[indexPath.item].title
        }
        else {
            cell.movieTitleLabel.text = self.movies[indexPath.item].name
        }
        
        if let posterPath = self.movies[indexPath.item].posterPath {
            cell.movieImageView.sd_setImageWithURL(NSURL(string: "https://image.tmdb.org/t/p/w185\(posterPath)"))
        }
        
        cell.movieYearLabel.text = self.movies[indexPath.item].character
        
        return cell
        
    }
    
}