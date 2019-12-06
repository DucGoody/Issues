//
//  RegisterViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfComfirmPassword: UITextField!
    var caching: Caching?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenNavigation = true
        self.btnRegister.layer.cornerRadius = 5
        self.caching = Caching.share
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionRegister(_ sender: Any) {
        self.showLoading()
        self.register()
    }
    
    func register() {
        if self.valiidate() {
            ServiceController().register(name: self.tfName.text ?? "",
                                         phone: self.tfPhone.text ?? "",
                                         password: self.tfPassword.text ?? "") { (data) in
                                            self.hideLoading()
                                            if data?.code == 0 {
                                                if let data = data?.data {
                                                    self.doLogin(data: data)
                                                }
                                            } else {
                                                print("Có lỗi xảy ra. Vui lòng thử lại!")
                                            }
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
        let name = self.tfName.text
        let phone = self.tfPhone.text
        let password = self.tfPassword.text
        let confirmPassword = self.tfComfirmPassword.text
        
        if self.isNilOrEmptyString(name) &&
            self.isNilOrEmptyString(phone) &&
        self.isNilOrEmptyString(password) &&
        self.isNilOrEmptyString(confirmPassword) {
            if let password = password,
                let confirmPassword = confirmPassword,
                !password.elementsEqual(confirmPassword) {
                print("Xác nhận mật khẩu sai. Vui lòng nhập lại")
                return false
            }
        } else {
            print("Vui lòng nhập đầy đủ thông tin")
            return false
        }
        return true
    }
}
