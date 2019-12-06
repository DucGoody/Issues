//
//  Issue.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

struct Issue: Mappable {
    
    var id:String!
    var title:String = ""
    var content:String = ""
    var add:String = ""
    var time:String = ""
    var date:String = ""
    var status:String = ""
    var media:[String] = []
    var processed: String = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        content <- map["content"]
        add <- map["add"]
        time <- map["time"]
        date <- map["date"]
        status <- map["status"]
        media <- map["media"]
        processed <- map["processed"]
    }
}
