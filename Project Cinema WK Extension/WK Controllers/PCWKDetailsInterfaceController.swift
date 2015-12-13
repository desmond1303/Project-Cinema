//
//  PCWKDetailsInterfaceController.swift
//  Project Cinema
//
//  Created by Dino Praso on 12.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import WatchKit
import Foundation


class PCWKDetailsInterfaceController: WKInterfaceController {

    @IBOutlet var detailsTable: WKInterfaceTable!
    
    var mediaItem: [String: String]? {
        willSet {
            self.setTitle(newValue!["title"]!)
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.mediaItem = context as? [String: String]
        
        detailsTable.setNumberOfRows(1, withRowType: "overviewRow")
        
        //detailsTable.setRowTypes(["generalDetailsRow", "overviewRow"])
        
        let overviewCell = detailsTable.rowControllerAtIndex(0) as! PCWKDetailsOverviewRowController
        
        overviewCell.overviewLabel.setText(self.mediaItem!["overview"]!)
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
