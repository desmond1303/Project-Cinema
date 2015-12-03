//
//  PCMediaReview.swift
//  Project Cinema
//
//  Created by Dino Praso on 3.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCMediaReview: Mappable {
    
    var id: Int?
    var author: String?
    var content: String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.author <- map["author"]
        self.content <- map["content"]
    }

}
