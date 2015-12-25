//
//  PCMainDetailsRateThisTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 25.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCMainDetailsRateThisTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var givenRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellTitle.text = "Your\nRating"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
