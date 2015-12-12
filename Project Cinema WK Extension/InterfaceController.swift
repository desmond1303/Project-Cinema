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
        ["title": "Ant-Man", "year": "2015", "voteAverage": "8.7", "itemType": "movie", "overview": "Lorem Ipsum Dolor ist Amet"],
        ["title": "Avengers", "year": "2014", "voteAverage": "7.9", "itemType": "movie", "overview": "Lorem Ipsum Dolor ist Amet"],
        ["title": "Marvels: Agents of S.H.I.E.L.D.", "year": "2013 - 2016", "voteAverage": "9.6", "itemType": "tv", "overview": "Lorem Ipsum Dolor ist Amet"],
        ["title": "Avengers 2", "year": "2015", "voteAverage": "9.6", "itemType": "movie", "overview": "Lorem Ipsum Dolor ist Amet"],
        ["title": "Civil War", "year": "2016", "voteAverage": "9.9", "itemType": "movie", "overview": "Lorem Ipsum Dolor ist Amet"],
        ["title": "Iron Man", "year": "2008", "voteAverage": "8.8", "itemType": "movie", "overview": "Lorem Ipsum Dolor ist Amet"],
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
