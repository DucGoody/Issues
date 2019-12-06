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
    
    let domain = "http://45.118.145.149:8100"
    
    func getHeader() -> HTTPHeaders {
        let token = Caching.share.getToken()
        return [
            "Accept": "application/json",
            "token": token
        ]
    }
    
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
    
    func login(phone: String,password : String, completion: @escaping (_ result: DataReponseLogin?) -> Void) {
        
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
            
            let object = Mapper<DataReponseLogin>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    //status: -1 lấy tất cả, 0 - chưa xử lý, 1 - đang xử lý, 2 - đã xử lý
    func getIssuesByKeyword(status: Int, keyword: String, completion: @escaping (_ result: DataReponseListIssue?) -> Void) {
        guard let url2 = URL.init(string: "\(domain)/issues?status=\(status)&keyword=\(keyword)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseListIssue>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    //Chi tiết issue
    func getDetailIssue(id: String, completion: @escaping (_ result: DataReponseIssue?) -> Void) {
        guard let url2 = URL.init(string: "\(domain)/issues/\(id)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseIssue>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    func getProfile(completion: @escaping (_ result: DataReponseProfile?) -> Void) {
        guard let url2 = URL.init(string: "\(domain)/profile") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseProfile>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    func updateProfile(profile: Profile,completion: @escaping (_ result: DataReponseProfile?) -> Void) {
        guard let url2 = URL.init(string: "\(domain)/update-profile") else {
            completion(nil)
            return
        }
        
        var dic = Dictionary<String, Any>.init()
        dic["name"] = profile.name
        dic["address"] = profile.add
        dic["phone"] = profile.phone
        dic["avatar"] = profile.avatar
        
        Alamofire.request(url2, method: .put, parameters: dic, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
            
            guard response.result.isSuccess,
                let data = response.data,
                let json = try? JSON(data: data).object,
                let jsonItem = json as? [String : Any]
                else {
                    completion(nil)
                    return
            }
            
            let object = Mapper<DataReponseProfile>().map(JSON: jsonItem)
            completion(object)
        }
    }
    
    func createIssue(entity: Issue,completion: @escaping (_ result: DataReponseIssue?) -> Void) {
         guard let url2 = URL.init(string: "\(domain)/create-issue") else {
             completion(nil)
             return
         }
         
         var dic = Dictionary<String, Any>.init()
         dic["title"] = entity.title
         dic["content"] = entity.content
        dic["address"] = entity.add
         dic["status"] = entity.status
        
        var arrMedia: String = ""
        for (index,item) in entity.media.enumerated() {
            if index == 0 {
                arrMedia.append("[")
            }
            arrMedia.append(item)
            
            if index == entity.media.count - 1 {
                arrMedia.append("]")
            }
        }
        dic["media"] = arrMedia
         
         Alamofire.request(url2, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: self.getHeader()).responseJSON { (response) in
             
             guard response.result.isSuccess,
                 let data = response.data,
                 let json = try? JSON(data: data).object,
                 let jsonItem = json as? [String : Any]
                 else {
                     completion(nil)
                     return
             }
             
             let object = Mapper<DataReponseIssue>().map(JSON: jsonItem)
             completion(object)
         }
     }
    
    func uploadImage(entity: UIImage,completion: @escaping (_ result: DataReponseString?, _ isProcess: Bool) -> Void) {
        guard let url2 = URL.init(string: "\(domain)/upload-file") else {
            completion(nil, false)
            return
        }
        let imgData = UIImageJPEGRepresentation(entity, 0.2)!
        let name = "\(self.generateBoundaryString()).jpg"
        
        Alamofire.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "fileset",fileName: name, mimeType: "image/jpg")
//                for (key, value) in parameters {
//                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                    } //Optional for extra parameters
            },
        to:url2)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    completion(nil, true)
                })

                upload.responseJSON { response in
                     guard response.result.isSuccess,
                         let data = response.data,
                         let json = try? JSON(data: data).object,
                         let jsonItem = json as? [String : Any]
                         else {
                             completion(nil,false)
                             return
                     }
                    let object = Mapper<DataReponseString>().map(JSON: jsonItem)
                    completion(object, false)
                    
                }

            case .failure(let encodingError):
                print(encodingError)
                completion(nil, false)
            }
        }
    }
    
    func generateBoundaryString() -> String {
        return "hoangvanduc-\(NSUUID().uuidString)"
    }
}
