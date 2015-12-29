//
//  AppDelegate.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift
import WatchConnectivity
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }

    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        let rootViewController = self.window?.rootViewController as! UITabBarController
        let rootNavController = rootViewController.viewControllers?.first as! UINavigationController
        let mainViewController = rootNavController.viewControllers.first as! PCFeedTableViewController
        mainViewController.restoreUserActivityState(userActivity)
        
        return true
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        Fabric.with([Crashlytics.self])

        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.atlantbh.Project-Cinema-Private")!
        let realmPath = directory.path!.stringByAppendingString("/db.realm")
        Realm.Configuration.defaultConfiguration.path = realmPath
        
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
        }
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
        let rootViewController = self.window?.rootViewController as! UITabBarController
        let rootNavController = rootViewController.viewControllers?.first as! UINavigationController
        let mainViewController = rootNavController.viewControllers.first as! PCFeedTableViewController
        
        let itemType = url.host
        let itemId = url.pathComponents![1]
        
        mainViewController.showDetailsForMediaItem(itemId, type: itemType!)
        
        return true
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let realm = try! Realm()
        let dateMaker = NSDateFormatter()
        dateMaker.dateFormat = "yyyy-MM-dd"
        let todayString = dateMaker.stringFromDate(NSDate())
        let todaysStatObject = realm.objects(PCAccessStatistics).filter("date = '\(todayString)'")
        if todaysStatObject.count == 0 {
            try! realm.write {
                let newToday = PCAccessStatistics()
                newToday.date = todayString
                newToday.movieCount = 0
                newToday.tvCount = 0
                realm.add(newToday)
            }
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: WCSessionDelegate {
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let request = message["request"] as? String {
            
            let realm = try! Realm()
            var favorites = [[String: String]]()
            
            if request == "favorites" {
                let favs = realm.objects(PCMediaItem).sorted("title")
                for fav in favs {
                    let date = fav.itemType == "movie" ? fav.release_date.componentsSeparatedByString("-").first! : "From \(fav.first_air_date.componentsSeparatedByString("-").first!)"
                    favorites.append(["title": fav.title, "year": date, "voteAverage": String(fav.voteAverage), "itemType": fav.itemType, "overview": fav.overview])
                }
            }
            
            replyHandler(["favorites": favorites])
            
        }
    }
    
}

