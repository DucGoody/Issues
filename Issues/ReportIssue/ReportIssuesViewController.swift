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
    
    let imageCell = "ImageCell"
    var listImage: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.isHiddenNavigation = false
        self.navigationItem.title = "Báo cáo sự cố"
        
        self.initCollectionView()
        
        self.tfInputTitle.delegate = self
        self.tfInputAddress.delegate = self
        self.tfInputAddress.addTarget(self, action: #selector(onChangeAddress(textField:)), for: .editingChanged)
        self.tfInputTitle.addTarget(self, action: #selector(onChangeTitle(textField:)), for: .editingChanged)
        
        self.cstHeightTvDescription.constant = 36
    }
    
    func initCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: imageCell, bundle: nil), forCellWithReuseIdentifier: imageCell)
    }
    
    @objc func onChangeAddress(textField: UITextField) {
        
    }
    
    @objc func onChangeTitle(textField: UITextField) {
        
    }
}

//  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ReportIssuesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImage.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath) as? ImageCell {
            if indexPath.row == listImage.count
            {
                cell.binData(image: nil, isAdd: true)
            } else {
                cell.row = indexPath.row
                cell.binData(image: listImage[indexPath.row])
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
            
        } else {
            
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
        self.lbHintDescription.isHidden = !(textView.text.count <= 0 && textView.text.isEmpty)
        let line = textView.numberOfLines() - 1
        self.cstHeightTvDescription.constant = CGFloat((line <= 0) ? 36 : (36 + 16 * line))
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
