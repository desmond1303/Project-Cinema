//
//  PCAccountLoginTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 24.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit

class PCAccountLoginTableViewCell: UITableViewCell {
    
    var parentTableView: PCAccountTableViewController?

    @IBAction func LogInButtonAction(sender: AnyObject) {
        self.parentTableView?.loginWithUsername("desmond1303", password: "apiTestPassword")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
