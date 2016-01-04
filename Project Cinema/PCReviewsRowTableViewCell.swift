//
//  PCReviewsRowTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit

class PCReviewsRowTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
