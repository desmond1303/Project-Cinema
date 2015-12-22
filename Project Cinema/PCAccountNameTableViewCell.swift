//
//  PCAccountNameTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 22.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCAccountNameTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
