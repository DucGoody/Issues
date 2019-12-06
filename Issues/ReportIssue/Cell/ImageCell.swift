//
//  ImageCell.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var ivImgae: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    var onRemove: ((Int) -> Void)?
    var row: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ivImgae.layer.cornerRadius = 5
        self.ivImgae.clipsToBounds = true
        self.btnAdd.layer.cornerRadius = 5
        self.btnAdd.clipsToBounds = true
    }
    
    func binData(image: UIImage?, isAdd: Bool = false) {
        self.ivImgae.image = image
        self.btnAdd.isHidden = !isAdd
        self.ivImgae.isHidden = isAdd
        self.btnRemove.isHidden = isAdd
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        self.onRemove?(-1)
    }
    
    @IBAction func actionRemove(_ sender: Any) {
        self.onRemove?(row)
    }
}
