//
//  PCWKFavortiesRowController.swift
//  Project Cinema
//
//  Created by Dino Praso on 12.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import WatchKit

class PCWKFavortiesRowController: NSObject {

    @IBOutlet private var colorIndicator: WKInterfaceSeparator!
    @IBOutlet private var mediaItemTitle: WKInterfaceLabel!
    @IBOutlet private var mediaItemYear: WKInterfaceLabel!
    @IBOutlet private var mediaItemVoteAverage: WKInterfaceLabel!
    
    var mediaItem: [String: String]? {
        willSet {
            if let values = newValue {
                self.mediaItemTitle.setText(values["title"]!)
                self.mediaItemYear.setText(values["year"]!)
                self.mediaItemVoteAverage.setText(values["voteAverage"]!)
                
                switch values["itemType"]! {
                case "movie":
                    self.colorIndicator.setColor(UIColor.redColor())
                case "tv":
                    self.colorIndicator.setColor(UIColor.blueColor())
                default: break
                }
            }
        }
    }
    
}
