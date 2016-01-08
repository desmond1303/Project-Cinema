//
//  PCActorMainTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 8.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit

class PCActorMainTableViewCell: UITableViewCell {

    @IBOutlet weak var actorBackdrop: UIImageView!
    @IBOutlet weak var actorNameLabel: UILabel!
    @IBOutlet weak var actorBirthdayLabel: UILabel!
    @IBOutlet weak var actorProfileImageView: UIImageView!
    @IBOutlet weak var actorBiographyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
