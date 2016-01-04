//
//  PCQueryResponse.swift
//  Project Cinema
//
//  Created by Dino Praso on 4.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCQueryResponse: Mappable {
    
    var page: Int?
    var results: [PCMediaItem]?
    var total_results: Int?
    var total_pages: Int?
    
    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        self.page <- map["page"]
        self.results <- map["results"]
        self.total_results <- map["total_results"]
        self.total_pages <- map["total_pages"]
    }

}
