//
//  PCSettingsTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 7.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class Session: Object {
    dynamic var sessionId = ""
    
    override static func primaryKey() -> String? {
        return "sessionId"
    }
}

class PCSettingsTableViewController: UITableViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = "https://api.themoviedb.org/3/authentication/token/new"
        var urlParamteres = ["api_key":"d94cca56f8edbdf236c0ccbacad95aa1"]
        
        var sessionId: String = ""
        
        Alamofire
            .request(.GET, url, parameters: urlParamteres)
            .responseObject { (response: Response<PCRequestToken, NSError>) in
                if response.result.value!.success! == true {
                    
                    print(response.result.value!.request_token!)
                    
                    url = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
                    urlParamteres["request_token"] = response.result.value!.request_token!
                    urlParamteres["username"] = "desmond1303"
                    urlParamteres["password"] = "apiTestPassword"
                    
                    Alamofire
                        .request(.GET, url, parameters: urlParamteres)
                        .responseObject { (response2: Response<PCRequestToken, NSError>) in
                            if response2.result.value!.success! == true {
                                
                                print(response2.result.value!.request_token!)
                                
                                url = "https://api.themoviedb.org/3/authentication/session/new"
                                urlParamteres["request_token"] = response2.result.value!.request_token!
                                
                                Alamofire
                                    .request(.GET, url, parameters: urlParamteres)
                                    .responseObject { (response3: Response<PCRequestToken, NSError>) in
                                        if response3.result.value!.success! == true {
                                            
                                            print(response3.result.value!.request_token!)
                                            
                                            sessionId = response3.result.value!.request_token!
                                            let session = Session()
                                            session.sessionId = sessionId
                                            let realm = try! Realm()
                                            try! realm.write {
                                                realm.add(session)
                                            }
                                        }
                                    }
                                
                                
                            }
                        }
                }
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: "")!)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let values = ["value":"10"]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(values, options: [])


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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityChartCell", forIndexPath: indexPath) as! PCActivityChartTableViewCell
        cell.setupChart()
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Activity Chart"
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
