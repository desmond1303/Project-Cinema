//
//  PCAccountNameTableViewCell.swift
//  Project Cinema
//
//  Created by Dino Praso on 22.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import QuartzCore
import RealmSwift

class PCAccountNameTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    
    var parentTableView: PCAccountTableViewController?
    
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBAction func LogOutButtonAction(sender: AnyObject) {
        let realm = try! Realm()
        let sessionId = realm.objects(Session)
        
        try! realm.write {
            realm.delete(sessionId)
        }
        
        self.parentTableView?.sessionId = nil
        self.parentTableView?.account = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        logOutButton.layer.cornerRadius = 2
        logOutButton.layer.borderWidth = 1
        logOutButton.layer.borderColor = logOutButton.tintColor.CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
