//
//  PCMediaSeasons.swift
//  Project Cinema
//
//  Created by Dino Praso on 3.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCMediaSeason: Mappable {
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
    }

}
