//
//  Caching.swift
//  Issues
//
//  Created by HoangVanDuc on 12/5/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class Caching {
    static let share = Caching()
    
    let keyCheckLogin: String = "keyCheckLogin"
    let keyMenuItem: String = "keyMenuItem"
    
    func saveMenuItemIndex(index: Int) {
         UserDefaults.standard.set(index, forKey: keyMenuItem)
    }
    
    func getMenuItemIndex() -> Int {
        return UserDefaults.standard.integer(forKey: keyMenuItem)
    }
    
    func saveUserProfile(object: DataLogin) {
        let json = object.toJSON()
        UserDefaults.standard.set(json, forKey: keyCheckLogin)
    }
    
    func getUserProfile() -> DataLogin? {
        guard let json = UserDefaults.standard.dictionary(forKey: keyCheckLogin) else { return nil}
        return Mapper<DataLogin>().map(JSON: json)
    }
    
    func getToken() -> String {
        guard let json = UserDefaults.standard.dictionary(forKey: keyCheckLogin) else { return ""}
        let object = Mapper<DataLogin>().map(JSON: json)
        return object?.token ?? ""
    }
    
    func clearToken() {
        UserDefaults.standard.removeObject(forKey: "keyCheckLogin")
    }
}
