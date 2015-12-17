//
//  TodayViewController.swift
//  Project Cinema: Upcoming
//
//  Created by Dino Praso on 13.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift
import CoreSpotlight
import MobileCoreServices

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    var upcommingMovies = [PCMediaItem]()
    
    let dateMaker = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.atlantbh.Project-Cinema-Private")!
        let realmPath = directory.path!.stringByAppendingString("/db.realm")
        Realm.Configuration.defaultConfiguration.path = realmPath
        
        self.getRealmData()
    }
    
    func getRealmData() {

        let realm = try! Realm()
        let realmObjects = realm.objects(PCMediaItem).sorted("release_date")
        
        self.upcommingMovies.removeAll()
        
        self.dateMaker.dateFormat = "yyyy-MM-dd"
        
        for RLMmediaItem in realmObjects {
            if self.dateMaker.dateFromString(RLMmediaItem.release_date)?.timeIntervalSinceDate(NSDate()) > 0 && RLMmediaItem.itemType == "movie" {
                self.upcommingMovies.append(RLMmediaItem)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsZero
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        self.getRealmData()
        self.tableViewHeightConstraint.constant = CGFloat(self.upcommingMovies.count * 43)
        completionHandler(NCUpdateResult.NewData)
        self.tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.upcommingMovies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("upcommingMoive", forIndexPath: indexPath)
        cell.textLabel?.text = self.upcommingMovies[indexPath.row].title
        
        self.dateMaker.dateFormat = "yyyy-MM-dd"
        
        let interval = self.dateMaker.dateFromString(self.upcommingMovies[indexPath.row].release_date)?.timeIntervalSinceDate(NSDate())
        
        let days = Int(ceil(interval!/60/60/24))
        
        cell.detailTextLabel?.text = "\(days) Days until release"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let url = NSURL(string: "pcmediaitem://\(self.upcommingMovies[indexPath.row].itemType)/\(self.upcommingMovies[indexPath.row].itemId)")
        self.extensionContext?.openURL(url!, completionHandler: nil)
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        selectedCell?.selected = false
        
    }
}
