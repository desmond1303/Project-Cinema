//
//  PCPerson.swift
//  Project Cinema
//
//  Created by Dino Praso on 8.1.16.
//  Copyright © 2016 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class PCPerson: Object, Mappable {
    
    dynamic var id: Int = 0
    dynamic var biography: String = ""
    dynamic var birthday: String = ""
    dynamic var deathday: String = ""
    dynamic var homepage: String = ""
    dynamic var name: String = ""
    dynamic var placeOfBirth: String = ""
    dynamic var profilePath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCPerson) {
        self.init()
        
        self.id = object.id
        self.biography = object.biography
        self.birthday = object.birthday
        self.deathday = object.deathday
        self.homepage = object.homepage
        self.name = object.name
        self.placeOfBirth = object.placeOfBirth
        self.profilePath = object.profilePath
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.biography <- map["biography"]
        self.birthday <- map["birthday"]
        self.deathday <- map["deathday"]
        self.homepage <- map["homepage"]
        self.name <- map["name"]
        self.placeOfBirth <- map["place_of_birth"]
        self.profilePath <- map["profile_path"]
    }


}

class PCPersonTaggedImage: Object, Mappable {
    
    dynamic var id: Int = 0
    dynamic var filePath: String = ""
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    convenience init(object: PCPersonTaggedImage) {
        self.init()
        
        self.id = object.id
        self.filePath = object.filePath
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.filePath <- map["file_path"]
    }

    
}
