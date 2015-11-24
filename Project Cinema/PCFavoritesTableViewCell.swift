//
//  PCFavoritesTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 24.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import SDWebImage

class PCFavoritesTableViewCell: UITableViewCell {
    
    var movie: PCMediaItem?

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
