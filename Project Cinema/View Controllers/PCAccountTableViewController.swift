//
//  PCAccountTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 22.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PCAccountTableViewController: UITableViewController {
    
    var sessionId: String?
    var account: PCAccount? {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let session = realm.objects(Session)
        
        if let sessionId = session.first?.sessionId {
            
            self.sessionId = sessionId
            
            // Get request Token
            var url = "https://api.themoviedb.org/3/authentication/token/new"
            var urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
            
            var sessionId: String = ""
            
            Alamofire
                .request(.GET, url, parameters: urlParamteres)
                .responseObject { (response: Response<PCRequestToken, NSError>) in
                    if response.result.value!.success! == true {
                        
                        // Get Token Authenticated
                        
                        url = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
                        urlParamteres["request_token"] = response.result.value!.request_token!
                        urlParamteres["username"] = "desmond1303"
                        urlParamteres["password"] = "apiTestPassword"
                        
                        Alamofire
                            .request(.GET, url, parameters: urlParamteres)
                            .responseObject { (response2: Response<PCRequestToken, NSError>) in
                                if response2.result.value!.success! == true {
                                    
                                    // Create New Session
                                    
                                    url = "https://api.themoviedb.org/3/authentication/session/new"
                                    urlParamteres["request_token"] = response2.result.value!.request_token!
                                    
                                    Alamofire
                                        .request(.GET, url, parameters: urlParamteres)
                                        .responseObject { (response3: Response<PCRequestToken, NSError>) in
                                            if response3.result.value!.success! == true {
                                                
                                                sessionId = response3.result.value!.request_token!
                                                let session = Session()
                                                session.sessionId = sessionId
                                                let realm = try! Realm()
                                                try! realm.write {
                                                    realm.add(session)
                                                }
                                                
                                                // Get Account Data
                                                
                                                url = "https://api.themoviedb.org/3/account"
                                                urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1", "session_id":self.sessionId!]
                                                Alamofire
                                                    .request(.GET, url, parameters: urlParamteres)
                                                    .responseObject { (response4: Response<PCAccount, NSError>) in
                                                        self.account = response4.result.value!
                                                }
                                                
                                            }
                                    }
                                    
                                    
                                }
                        }
                    }
            }
            
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let account = self.account {
            let cell = tableView.dequeueReusableCellWithIdentifier("accountNameCell", forIndexPath: indexPath) as! PCAccountNameTableViewCell
            
            let nameWithUsername = NSMutableAttributedString(string: account.name, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(18)])
            nameWithUsername.appendAttributedString(NSAttributedString(string: "\n\(account.username)", attributes: [NSFontAttributeName : UIFont.systemFontOfSize(12)]))
            
            cell.accountNameLabel.attributedText = nameWithUsername
            
            cell.avatarImageView.sd_setImageWithURL(NSURL(string: "https://secure.gravatar.com/avatar/\(account.avatarHash).jpg?s=71"))
            
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("loginButtonCell", forIndexPath: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            if let _ = self.account {
                return 88
            }
            else {
                return 44
            }
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
