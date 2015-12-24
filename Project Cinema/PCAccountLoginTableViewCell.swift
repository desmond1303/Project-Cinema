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

        var username: String? //desmond1303
        var password: String? //apiTestPassword
        
        let alertController = UIAlertController(title: "Login", message: "Use TheMovieDB Login credentails", preferredStyle: UIAlertControllerStyle.Alert)
        
        let textAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (textAction) -> Void in
            username = alertController.textFields![0].text
            password = alertController.textFields![1].text
            self.parentTableView?.loginWithUsername(username!, password: password!)
        }
        alertController.addAction(textAction)
        alertController.addTextFieldWithConfigurationHandler { (usernameField) -> Void in
            usernameField.placeholder = "Username"
        }
        alertController.addTextFieldWithConfigurationHandler { (passwordField) -> Void in
            passwordField.placeholder = "Password"
            passwordField.secureTextEntry = true
        }
        
        self.parentTableView?.presentViewController(alertController, animated: true) { () -> Void in
            //
        }
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
