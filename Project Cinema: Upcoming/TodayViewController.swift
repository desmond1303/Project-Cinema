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

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var upcommingMovies = [PCMediaItem]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.getRealmData()
    }
    
    func getRealmData() {
        let realm = try! Realm()
        let realmObjects = realm.objects(PCMediaItem)
        
        let dateMaker = NSDateFormatter()
        dateMaker.dateFormat = "yyyy-MM-dd"
        for RLMmediaItem in realmObjects {
            if dateMaker.dateFromString(RLMmediaItem.release_date)?.timeIntervalSinceDate(NSDate()) > 0 && RLMmediaItem.itemType == "movie" {
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
        cell.detailTextLabel?.text = self.upcommingMovies[indexPath.row].release_date
        return cell
    }
    
}
