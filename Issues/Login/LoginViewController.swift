//
//  LoginViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    var caching: Caching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenNavigation = true
        self.btnLogin.layer.cornerRadius = 5
        self.caching = Caching.share
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        let vc = RegisterViewController()
//        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.showLoading()
        self.login()
    }
    
    func login() {
        if self.valiidate() {
            ServiceController().login(phone: self.tfPhone.text ?? "", password: self.tfPassword.text ?? "") { (data) in
                self.hideLoading()
                guard let data = data?.data else {
                    print("Lỗi đăng nhập. Vui lòng kiểm tra lại!")
                    return
                }
                self.doLogin(data: data)
            }
        } else {
            self.hideLoading()
        }
    }
    
    func doLogin(data: DataLogin) {
        caching?.saveUserProfile(object: data)
        
        let vc = ReportIssuesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func valiidate() -> Bool {
        let phone = self.tfPhone.text
        let password = self.tfPassword.text
        
        if !self.isNilOrEmptyString(phone) ||
            !self.isNilOrEmptyString(password) {
            print("Vui lòng nhập đầy đủ thông tin")
            return false
        }
        return true
    }
}

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
