//
//  InterfaceController.swift
//  Project Cinema WK Extension
//
//  Created by Dino Praso on 12.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var favortiesTable: WKInterfaceTable!
    
    var mediaItems = [[String: String]]() {
        didSet {
            favortiesTable.setNumberOfRows(self.mediaItems.count, withRowType: "WKFavoriteRow")
            var i = 0
            for item in self.mediaItems {
                let row = favortiesTable.rowControllerAtIndex(i++) as! PCWKFavortiesRowController
                row.mediaItem = item
            }
            i = 0
        }
    }
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        //
    }

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let context = context {
            self.mediaItems = context as! [[String: String]]
        }
    }
    
    override func didAppear() {
        super.didAppear()
        
        if WCSession.isSupported() {
            
            self.session = WCSession.defaultSession()
            session!.sendMessage(["request": "favorites"], replyHandler: { (response) -> Void in
                if let favorites = response["favorites"] as? [[String: String]] {
                    //self.mediaItems = favorites
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.mediaItems = favorites
                    })
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        if segueIdentifier == "showDetials" {
            return self.mediaItems[rowIndex]
        }
        return nil
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

extension InterfaceController: WCSessionDelegate {
    
}
