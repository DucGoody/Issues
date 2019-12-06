//
//  ProfileViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var cstHeightTextView: NSLayoutConstraint!
    @IBOutlet weak var tvAddress: UITextView!
    
    var profile: UserProfile!
    let imagePicker = UIImagePickerController()
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Hồ sơ"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Cập nhật", style: .plain, target: self, action: #selector(onUpdate))
        
        self.getProfile()
        self.tvAddress.delegate = self
        self.imagePicker.delegate = self
        self.ivAvatar.layer.cornerRadius = 100
        self.ivAvatar.clipsToBounds = true
    }
    
    @objc func onUpdate() {
        if !self.isValidate() {return}
        self.showLoading()
        ServiceController().updateProfile(profile: profile) { (response) in
            if response?.code == 403 {
                self.reLogin(isUpdate: true)
                return
            }
            if let data = response?.data {
                self.updateUI(data: data)
            } else {
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
            }
        }
    }
    
    @IBAction func actionChangeAvatar(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .overCurrentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onChangeName(_ sender: UITextField) {
        self.profile.name = sender.text ?? ""
    }
    
    @IBAction func onChangePhone(_ sender: UITextField) {
        self.profile.phone = sender.text ?? ""
    }
    
    func getProfile() {
        if !self.isInternet() {return}
        self.showLoading()
        ServiceController().getProfile { (response) in
            if response?.code == 403 {
                self.reLogin()
                return
            }
            self.hideLoading()
            
            if let data = response?.data {
                self.updateAvatar(data)
                self.updateUI(data: data)
            } else {
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
            }
        }
    }
    
    func updateAvatar(_ data: UserProfile) {
        if !self.isInternet() {return}
        ServiceController().loadListOfImages(imageNames: [data.avatar]) { (images) in
            if let items = images, items.count > 0 {
                DispatchQueue.main.async {
                   self.ivAvatar.image = items[0]
                }
            } else {
                self.ivAvatar.image = UIImage.init(named: "ic_default")
            }
        }
    }
    
    func reLogin(isUpdate: Bool = false, isUpload: Bool = false) {
         if !self.isInternet() {return}
        ServiceController().relogin { (isResult) in
            if isResult {
                if !isUpdate {
                    if isUpload {
                        self.uploadAvatar()
                    } else {
                        self.getProfile()
                    }
                } else {
                    self.onUpdate()
                }
                
            } else {
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
                return
            }
        }
    }
    
    func isValidate() -> Bool {
        if self.isNilOrEmptyString(self.profile.name) ||
            self.isNilOrEmptyString(self.profile.phone) ||
            self.isNilOrEmptyString(self.profile.address) {
            self.showToast(message: "Vui lòng nhập đầy đủ thông tin", isSuccess: false)
        }
        return true
    }
    
    func updateUI(data: UserProfile) {
        self.profile = data
        self.tfName.text = data.name
        self.tfPhone.text = data.phone
        self.tvAddress.text = data.address
    }
    
    func uploadAvatar() {
        if !self.isInternet() {return}
        self.showLoading()
        ServiceController().upload(image: self.image, success: { (url) in
            self.hideLoading()
            self.profile.avatar = url
        }) { (str) in
            self.reLogin(isUpdate: false, isUpload: true)
            return
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = pickedImage
            self.ivAvatar.image = self.image
            self.uploadAvatar()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.profile.address = textView.text
    }
}
