//
//  PCRatingTableViewController.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift

class PCRatingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        let sessionId = realm.objects(Session).first?.sessionId

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
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var stars = String()
        let attributes = [
            NSFontAttributeName: UIFont(name: "FontAwesome", size: 16)!,
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
        
        return attributedStars
        
    }
    
}
