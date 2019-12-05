//
//  ProfileViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hồ sơ"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cập nhật", style: .plain, target: self, action: #selector(onUpdate))
    }
    
    @objc func onUpdate() {
        
    }
}
