//
//  InterfaceController.swift
//  Project Cinema WK Extension
//
//  Created by Dino Praso on 12.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    
    @IBOutlet var favortiesTable: WKInterfaceTable!
    
    let mediaItems = [
        ["title": "Ant-Man", "year": "2015", "voteAverage": "8.7", "itemType": "movie"],
        ["title": "Avengers", "year": "2014", "voteAverage": "7.9", "itemType": "movie"],
        ["title": "Marvels: Agents of S.H.I.E.L.D.", "year": "2013 - 2016", "voteAverage": "9.6", "itemType": "tv"],
        ["title": "Avengers 2", "year": "2015", "voteAverage": "9.6", "itemType": "movie"],
        ["title": "Civil War", "year": "2016", "voteAverage": "9.9", "itemType": "movie"],
        ["title": "Iron Man", "year": "2008", "voteAverage": "8.8", "itemType": "movie"],
    ]

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        favortiesTable.setNumberOfRows(self.mediaItems.count, withRowType: "WKFavoriteRow")
        var i = 0
        for item in self.mediaItems {
            let row = favortiesTable.rowControllerAtIndex(i++) as! PCWKFavortiesRowController
            row.mediaItem = item
        }
        i = 0
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
