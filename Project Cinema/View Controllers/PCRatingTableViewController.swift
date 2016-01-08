//
//  PCRatingTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PCRatingTableViewController: UITableViewController {
    
    var selectedRate = 10
    
    @IBAction func submitButtonAction(sender: AnyObject) {
        
        let realm = try! Realm()
        let session = realm.objects(Session)
        
        if let sessionId = session.first?.sessionId {
            
            self.sessionId = sessionId
            
            let url = NSURL(string: "https://api.themoviedb.org/3/\(self.movie!.itemType)/\(self.movie!.itemId)/rating?api_key=d94cca56f8edbdf236c0ccbacad95aa1&session_id=\(sessionId)")!
            
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.HTTPBody = "{\"value\": \(self.selectedRate)}".dataUsingEncoding(NSUTF8StringEncoding);
            
            Alamofire
                .request(request)
                .responseJSON { response in
                    self.navigationController?.popViewControllerAnimated(true)
            }

        }
        else {
            let alertController = UIAlertController(title: "Not Logged In", message: "You have to be logged in to be able to submit ratings.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let textAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(textAction)
            
            self.presentViewController(alertController, animated: true) { () -> Void in
                //code
            }

        }
        
    }
    
    var movie: PCMediaItem? {
        didSet {
            self.navigationItem.title = "Rate \(self.movie!.title)"
        }
    }
    
    var sessionId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let cell = tableView.dequeueReusableCellWithIdentifier("ratingPicker", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 217
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
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

extension PCRatingTableViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let pickerItemLabel = UILabel()
        pickerItemLabel.textAlignment = .Center
        
        var stars = String()
        let attributes = [
            NSFontAttributeName: UIFont(name: "FontAwesome", size: 19)!,
            NSForegroundColorAttributeName: UIColor.redColor()
        ]
        
        var starCount = String()
        
        switch row {
        case 0:
            stars = "\u{f005} \u{f005} \u{f005} \u{f005} \u{f005} "
            starCount = "10"
        case 1:
            stars = "\u{f005} \u{f005} \u{f005} \u{f005} \u{f005} "
            starCount = "9"
        case 2:
            stars = "\u{f005} \u{f005} \u{f005} \u{f005} "
            starCount = "8"
        case 3:
            stars = "\u{f005} \u{f005} \u{f005} \u{f005} "
            starCount = "7"
        case 4:
            stars = "\u{f005} \u{f005} \u{f005} "
            starCount = "6"
        case 5:
            stars = "\u{f005} \u{f005} \u{f005} "
            starCount = "5"
        case 6:
            stars = "\u{f005} \u{f005} "
            starCount = "4"
        case 7:
            stars = "\u{f005} \u{f005} "
            starCount = "3"
        case 8:
            stars = "\u{f005} "
            starCount = "2"
        case 9:
            stars = "\u{f005} "
            starCount = "1"
        default: break
        }
        
        let attributedStars = NSMutableAttributedString(string: stars, attributes: attributes)
        attributedStars.appendAttributedString(NSAttributedString(string: starCount))
        
        pickerItemLabel.attributedText = attributedStars
        
        return pickerItemLabel
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            self.selectedRate = 10
        case 1:
            self.selectedRate = 9
        case 2:
            self.selectedRate = 8
        case 3:
            self.selectedRate = 7
        case 4:
            self.selectedRate = 6
        case 5:
            self.selectedRate = 5
        case 6:
            self.selectedRate = 4
        case 7:
            self.selectedRate = 3
        case 8:
            self.selectedRate = 2
        case 9:
            self.selectedRate = 1
        default: break
        }
    }
    
}
