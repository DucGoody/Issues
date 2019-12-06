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
            "Authorization": token
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
    
    func relogin(completion: @escaping (_ isResult: Bool) -> Void) {
        let caching = Caching.share
        let profile = caching.getUserProfile()
        if let user = profile?.userProfile {
            let password = user.password
            self.login(phone: user.phone, password: user.password) { (response) in
                guard let entity = response?.data else {
                    completion(false)
                    return
                }
                entity.userProfile.password = password
                caching.saveUserProfile(object: entity)
                completion(true)
            }
        }
    }
    
    //status: -1 lấy tất cả, 0 - chưa xử lý, 1 - đang xử lý, 2 - đã xử lý
    func getIssuesByKeyword(status: Int, keyword: String, completion: @escaping (_ result: DataReponseListIssue?) -> Void) {
        let keywordFormat = keyword.trimmingCharacters(in: CharacterSet.whitespaces).folding(options: .diacriticInsensitive, locale: .current)
        guard let url2 = URL.init(string: "\(domain)/issues?status=\(status)&keyword=\(keywordFormat)") else {
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
    
    func updateProfile(profile: UserProfile,completion: @escaping (_ result: DataReponseProfile?) -> Void) {
        
        guard let url2 = URL.init(string: "\(domain)/update-profile") else {
            completion(nil)
            return
        }
        
        var dic = Dictionary<String, Any>.init()
        dic["name"] = profile.name
        dic["address"] = profile.address
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
    
    //status: -1 lấy tất cả, 0 - chưa xử lý, 1 - đang xử lý, 2 - đã xử lý
    func createIssue(address: String, title: String, content:
        String, media: [String], status: Int,completion: @escaping (_ result: DataReponseIssue?) -> Void) {
        
        guard let url2 = URL.init(string: "\(domain)/create-issue") else {
            completion(nil)
            return
        }
        
        var dic = Dictionary<String, Any>.init()
        dic["title"] = title
        dic["content"] = content
        dic["address"] = address
        dic["status"] = status
        
        var arrMedia: String = ""
        for (index,item) in media.enumerated() {
            if index == 0 {
                arrMedia.append("[")
            }
            arrMedia.append(item)
            
            if index == media.count - 1 {
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
    
    func upload(image: UIImage, success: @escaping (String)->(), failure: @escaping (String)->()){
        
        // tạo một hàm body request
        func createBody(boundary: String,
                        data: Data,
                        mimeType: MimeType,
                        filename: String) -> Data {
            let body = NSMutableData()
            
            let boundaryPrefix = "--\(boundary)\r\n"
            
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"fileData\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimeType.rawValue)\r\n\r\n")
            body.append(data)
            body.appendString("\r\n")
            body.appendString("--".appending(boundary.appending("--")))
            
            return body as Data
        }
        
        guard let url2 = URL.init(string: "\(domain)/upload-file") else {
                   return
               }
        
        // url
        var request  = URLRequest(url: url2)
        
        // method
        request.httpMethod = "POST"
        
        //
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // header
        request.allHTTPHeaderFields = getHeader()
        
        // truyền dữ liệu vào body
        request.httpBody = createBody(boundary: boundary,
                                      data: UIImageJPEGRepresentation(image, 0.2)!,
                                      mimeType: .image,
                                      filename: "quynhtao")
        
        // tạo một dataTask, với nhiệm vụ là gửi request, dữ liệu trả về là data, response và error
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            // SafeDispatch để gọi hàm trở lại foreground sau khi xử lý request
            DispatchQueue(label: "\(self.domain)/upload-file", qos: .background, attributes: .concurrent).async(execute: {
                if error == nil{
                    print("response \(response ?? URLResponse.init())")
                    do{
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                            print("json \(json)")
                            
                            // đọc dữ liệu từ json
                            if let code = json["code"] as? Int, let url = json["data"] as? String, code == 0, !url.isEmpty{
                                success(url)
                            }else{
                                failure(json["message"] as? String ?? "")
                            }
                            
                        }else{
                            failure("error")
                        }
                    }catch{
                        failure(error.localizedDescription)
                    }
                }else{
                    failure(error!.localizedDescription)
                }
            })
        })
        
        // gọi resume để chạy hàm dataTask
        dataTask.resume()
    }
    
    func loadListOfImages(imageNames: [String],images: @escaping([UIImage]?) -> Void)
       {
           // Send HTTP GET Request
           // Define server side script URL
           let scriptUrl = "http://swiftdeveloperblog.com/list-of-images/"
           
           // Add one parameter just to avoid caching
           let urlWithParams = scriptUrl + "?UUID=\(NSUUID().uuidString)"
           
           // Create NSURL Ibject
           let myUrl = URL(string: urlWithParams);
           
           // Creaste URL Request
           var request = URLRequest(url:myUrl!)
           
           // Set request HTTP method to GET. It could be POST as well
           request.httpMethod = "GET"
           
           
           // Excute HTTP Request
           let task = URLSession.shared.dataTask(with: request) {
               data, response, error in
               
               // Check for error
               if error != nil
               {
                   print("error=\(error)")
                   return
               }
               // Convert server json response to NSDictionary
               do {
                   if let convertedJsonIntoArray = try JSONSerialization.jsonObject(with: data!, options: []) as? NSArray {
                       
//                       self.images = convertedJsonIntoArray as [AnyObject]
                       
                       DispatchQueue.main.async {
//                           self.myCollectionView!.reloadData()
                       }
                       
                   }
               } catch let error as NSError {
                   print(error.localizedDescription)
               }
               
           }
           
           task.resume()
       }
}

enum MimeType: String{
    case image = "image/jpeg"
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
