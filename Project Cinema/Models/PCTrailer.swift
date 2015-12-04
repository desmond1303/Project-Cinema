//
//  PCTrailer.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCTrailer: Mappable {
    
    var name: String?
    var key: String?
    var size: Int?
    var site: String?
    var type: String?

    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.key <- map["key"]
        self.size <- map["size"]
        self.site <- map ["site"]
        self.type <- map["type"]
    }

}
