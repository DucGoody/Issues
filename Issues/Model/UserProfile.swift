//
//  UserProfile.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

class UserProfile: Mappable {
    var id: String = ""
    var name: String = ""
    var phone: String = ""
    var password:String = ""
    var avatar:String = ""
    var role:Int = -1
    var address:String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        phone <- map["phone"]
        password <- map["password"]
        avatar <- map["avatar"]
        name <- map["name"]
        role <- map["role"]
        address <- map["address"]
    }
}
