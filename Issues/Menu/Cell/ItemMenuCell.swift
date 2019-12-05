//
//  ItemMenuCell.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class ItemMenuCell: UITableViewCell {
    @IBOutlet weak var viewBounds: UIView!
    @IBOutlet weak var ivMenu: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.viewBounds.layer.cornerRadius = 5
        self.viewBounds.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setData(item: MenuEntity) {
        let image = UIImage.init(named: item.imageName)
        self.ivMenu.image = image
        self.lbName.text = item.name
    }
    
    func setSelectItem(isSelect: Bool) {
        self.lbName.textColor = isSelect ? self.hexStringToUIColor(hex: "916E25") : UIColor.black
        self.ivMenu.image = self.ivMenu.image?.withRenderingMode(.alwaysTemplate)
        self.ivMenu.tintColor = isSelect ? self.hexStringToUIColor(hex: "916E25") : UIColor.black
        self.viewBounds.backgroundColor = isSelect ? self.hexStringToUIColor(hex: "916E25").withAlphaComponent(0.3) : UIColor.white
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
