//
//  PCMediaItemCast.swift
//  Project Cinema
//
//  Created by Dino Praso on 23.11.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class PCMediaItemCast: Mappable {
    
    dynamic var actorId: Int = 0
    dynamic var name: String = ""
    dynamic var character: String = ""
    dynamic var profilePath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.actorId <- map["id"]
        self.name <- map["name"]
        self.character <- map["character"]
        self.profilePath <- map["profile_path"]
        
    }

}
