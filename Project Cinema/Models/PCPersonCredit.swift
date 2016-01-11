//
//  PCPersonCredit.swift
//  Project Cinema
//
//  Created by Dino Praso on 11.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCPersonCredit: Mappable {
    
    var adult: Bool?
    var character: String?
    var creditId: String?
    var id: Int?
    var originalTitle: String?
    var posterPath: String?
    var releaseDate: String?
    var title: String?
    var name: String?

    required init?(_ map: Map){
    }
    
    func mapping(map: Map) {
        self.adult <- map["adult"]
        self.character <- map["character"]
        self.creditId <- map["credit_id"]
        self.id <- map["id"]
        self.originalTitle <- map["original_title"]
        self.posterPath <- map["poster_path"]
        self.releaseDate <- map["release_date"]
        self.title <- map["title"]
        self.name <- map["name"]
    }

}
