//
//  PCRequestToken.swift
//  Project Cinema
//
//  Created by Dino Praso on 21.12.15.
//  Copyright © 2015 Dino Praso. All rights reserved.
//

import UIKit
import ObjectMapper
import AlamofireObjectMapper

class PCRequestToken: Mappable {
    
    var expires_at: String?
    var request_token: String?
    var success: Bool?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        self.expires_at <- map["expires_at"]
        self.request_token <- map["request_token"]
        self.request_token <- map["session_id"]
        self.success <- map["success"]
    }

}
