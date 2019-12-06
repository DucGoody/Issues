//
//  Profile.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

class Profile: Mappable {
    var id: String = ""
    var name: String = ""
    var add: String = ""
    var phone: String = ""
    var avatar: String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        add <- map["add"]
        phone <- map["phone"]
        avatar <- map["avatar"]
    }
}
