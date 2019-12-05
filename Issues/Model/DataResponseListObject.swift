//
//  DataResponseListObject.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

struct DataResponseListObject<T>: Mappable {
    var responseTime: String = ""
    var code: Int = 0
    var message: String = ""
    var data: [T] = []
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        responseTime <- map["responseTime"]
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}
