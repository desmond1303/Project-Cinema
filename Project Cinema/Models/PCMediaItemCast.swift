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

class PCMediaItemCrew: Object, Mappable {
    dynamic var department: String = ""
    dynamic var job: String = ""
    dynamic var name: String = ""
    dynamic var crewId:Int = 0
    dynamic var profilePath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.department <- map["department"]
        self.job <- map["job"]
        self.name <- map["name"]
        self.crewId <- map["id"]
        self.profilePath <- map["profile_path"]
        
    }
}

class PCMediaItemCast: Object, Mappable {
    
    dynamic var actorId: Int = 0
    dynamic var creditId: Int = 0
    dynamic var name: String = ""
    dynamic var character: String = ""
    dynamic var profilePath: String = ""
    
    //dynamic var crew = [PCMediaItemCrew]()
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.actorId <- map["id"]
        self.creditId <- map["credit_id"]
        self.name <- map["name"]
        self.character <- map["character"]
        self.profilePath <- map["profile_path"]
        
    }

}
