//
//  DataLogin.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

class DataLogin: Mappable {
    var token: String = ""
    var userType: Int = 0
    var userProfile: UserProfile!
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        userType <- map["userType"]
        userProfile <- map["userProfile"]
    }
}
