//
//  ReportIssuesViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class ReportIssuesViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tfInputAddress: UITextField!
    @IBOutlet weak var tfInputTitle: UITextField!
    @IBOutlet weak var lbHintDescription: UILabel!
    @IBOutlet weak var tvDecription: UITextView!
    @IBOutlet weak var cstHeightTvDescription: NSLayoutConstraint!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var lbStatus: UILabel!
    @IBOutlet weak var cstPaddingTopViewStatus: NSLayoutConstraint!
    
    let imageCell = "ImageCell"
    var listImage: [UIImage] = []
    let imagePicker = UIImagePickerController()
    var titleIssue: String = ""
    var address: String = ""
    var content: String = ""
    var media: [String] = []
    
    // Xem lại issue
    var issue: Issue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.isHiddenNavigation = false
        self.navigationItem.title = "Báo cáo sự cố"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Gửi", style: .plain, target: self, action: #selector(onSend))
        
        self.initCollectionView()
        
        self.imagePicker.delegate = self
        self.tfInputTitle.delegate = self
        self.tfInputAddress.delegate = self
        self.tfInputAddress.addTarget(self, action: #selector(onChangeAddress(textField:)), for: .editingChanged)
        self.tfInputTitle.addTarget(self, action: #selector(onChangeTitle(textField:)), for: .editingChanged)
        
        self.cstHeightTvDescription.constant = 36
        
        if let _ = self.issue {
            self.initIssueDetail()
        } else {
            self.viewStatus.isHidden = true
            self.cstPaddingTopViewStatus.constant = -20
        }
    }
    
    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: imageCell, bundle: nil), forCellWithReuseIdentifier: imageCell)
    }
    
    @objc func onSend() {
        self.createIssue()
    }
    
    func initIssueDetail() {
        self.tfInputTitle.text = self.issue?.title
        self.tfInputAddress.text = self.issue?.add
        self.tvDecription.text = self.issue?.content
        let status = StatusIssueEnum(rawValue: Int(self.issue?.status ?? "0") ?? 0)
        self.lbStatus.text = status?.text
        
        self.tvDecription.isEditable = false
        self.tfInputAddress.isEnabled = false
        self.tfInputTitle.isEnabled = false
        
        self.viewStatus.isHidden = false
        self.cstPaddingTopViewStatus.constant = 24
    }
    
    @objc func onChangeAddress(textField: UITextField) {
        self.address = textField.text ?? ""
    }
    
    @objc func onChangeTitle(textField: UITextField) {
        self.titleIssue = textField.text ?? ""
    }
    
    func uploadAvatar() {
        guard let item = self.listImage.last else { return }
        if !self.isInternet() {return}
        self.showLoading()
        
        ServiceController().upload(image: item, success: { (url) in
            self.hideLoading()
            self.media.append(url)
            self.collectionView.reloadData()
        }) { (str) in
            self.reLogin(isUpload: true)
            return
        }
    }
    
    func reLogin(isUpload: Bool = false) {
        if !self.isInternet() {return}
        ServiceController().relogin { (isResult) in
            if isResult {
                
                if isUpload {
                    self.uploadAvatar()
                } else {
                    self.createIssue()
                }
                
            } else {
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
                return
            }
        }
    }
    
    func createIssue() {
        if !self.isValidate() {return}
        
        self.showLoading()
        ServiceController().createIssue(address: self.address, title: self.titleIssue, content: self.content, media: media, status: StatusIssueEnum.noProcess.rawValue) { (response) in
            if response?.code == 403 {
                self.reLogin()
                return
            }
            self.hideLoading()
            
            if let _ = response?.data {
                self.resetUI()
                self.showToast(message: "Tạo thành công", isSuccess: true)
            } else {
                self.showToast(message: "Có lỗi xảy ra. Vui lòng thử lại", isSuccess: false)
            }
        }
    }
    
    func resetUI() {
        self.tfInputAddress.text = ""
        self.tfInputTitle.text = ""
        self.cstHeightTvDescription.constant = 36
        self.tvDecription.text = ""
        self.lbHintDescription.isHidden = false
        
        self.listImage = []
        self.titleIssue = ""
        self.address = ""
        self.content = ""
        self.media = []
    }
    
    func isValidate() -> Bool {
        if !self.isNilOrEmptyString(self.titleIssue) &&
            !self.isNilOrEmptyString(self.address) &&
            !self.isNilOrEmptyString(self.content) {
            self.showToast(message: "Vui lòng nhập đủ thông tin", isSuccess: false)
            return false
        }
        return true
    }
}

//  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ReportIssuesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.media.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath) as? ImageCell {
            if indexPath.row == self.media.count
            {
                cell.binData(isAdd: true)
            } else {
                cell.row = indexPath.row
                cell.binData()
                cell.ivImgae.setImage(self.media[indexPath.row])
            }
            cell.onRemove = { [unowned self] row in
                self.actionRemoveOrAdd(row)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.collectionView.frame.size.height, height: self.collectionView.frame.size.height)
    }
    
    func actionRemoveOrAdd(_ row: Int) {
        if row == -1 {//add
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            imagePicker.modalPresentationStyle = .overCurrentContext
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            self.listImage.remove(at: row)
            self.collectionView.reloadData()
        }
    }
}

//UITextFieldDelegate
extension ReportIssuesViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfInputAddress {
            self.tfInputTitle.becomeFirstResponder()
        } else if textField == self.tfInputTitle {
            self.tvDecription.becomeFirstResponder()
        }
        return true
    }
}

//UITextViewDelegate
extension ReportIssuesViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.content = textView.text
        self.lbHintDescription.isHidden = self.isNilOrEmptyString(textView.text)
        let line = textView.numberOfLines() - 1
        self.cstHeightTvDescription.constant = CGFloat((line <= 0) ? 36 : (36 + 16 * line))
    }
}

extension ReportIssuesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.listImage.append(pickedImage)
            self.uploadAvatar()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


//UITextView
extension UITextView{
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
}


enum StatusIssueEnum: Int {
    case all = -1
    case noProcess = 0
    case inProcess = 1
    case completed = 2
    
    var text: String {
        get {
            switch self {
            case .all:
                return "Tất cả"
            case .noProcess:
                return "Chưa xử lý"
            case .inProcess:
                return "Đang xử lý"
            case .completed:
                return "Đã xử lý"
            }
        }
    }
}
