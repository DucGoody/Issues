//
//  ServiceController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

class ServiceController {
    let headers: HTTPHeaders = [
      "Accept": "application/json",
    ]
    let domain = "http://45.118.145.149:8100"
    
    func register(name: String, phone: String,password : String, completion: @escaping (_ result: DataReponseLogin?) -> Void) {
        
        guard let url2 = URL.init(string: "\(domain)/register") else {
             completion(nil)
            return
        }
        
        var dic = Dictionary<String, Any>.init()
        dic["name"] = name
        dic["phone"] = phone
        dic["password"] = password
        
        Alamofire.request(url2, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any] else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseLogin>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    func login(phone: String,password : String, completion: @escaping (_ result: DataReponseObject<DataLogin>?) -> Void) {
        
        guard let url2 = URL.init(string: "\(domain)/login") else {
             completion(nil)
            return
        }
        
        var dic = Dictionary<String, Any>.init()
        dic["phone"] = phone
        dic["password"] = password
        
        Alamofire.request(url2, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseObject<DataLogin>>().map(JSON: jsonItem)
            completion(object)
        }
    }
}
