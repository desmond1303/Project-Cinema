//
//  PCAccount.swift
//  Project Cinema
//
//  Created by Dino Praso on 22.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper
import RealmSwift

class PCAccount: Object, Mappable {
    
    dynamic var avatarHash: String = ""
    dynamic var accountId: Int = 0
    dynamic var name: String = ""
    dynamic var username: String = ""

    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        self.avatarHash <- map["avatar.gravatar.hash"]
        self.accountId <- map["id"]
        self.name <- map["name"]
        self.username <- map["username"]
    }
    
}