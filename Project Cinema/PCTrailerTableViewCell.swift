//
//  PCTrailerTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PCTrailerTableViewCell: UITableViewCell {

    @IBOutlet weak var trailerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
