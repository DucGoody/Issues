//
//  DataReponseIssue.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

class DataReponseIssue: Mappable {
    var responseTime: String = ""
    var code: Int = -1
    var message: String = ""
    var data: Issue!
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        responseTime <- map["responseTime"]
        message <- map["message"]
        code <- map["code"]
        data <- map["data"]
    }
}
