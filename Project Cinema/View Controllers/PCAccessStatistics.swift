//
//  PCAccessStatistics.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import RealmSwift

class PCAccessStatistics: Object {
    
    dynamic var date = ""
    dynamic var movieCount = 0
    dynamic var tvCount = 0
    
    override static func primaryKey() -> String? {
        return "date"
    }

}
