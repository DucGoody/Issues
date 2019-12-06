//
//  AvatarCell.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class AvatarCell: UITableViewCell {
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.ivAvatar.layer.cornerRadius = self.ivAvatar.frame.size.width/2
        
        let caching = Caching.share
        let profile = caching.getUserProfile()?.userProfile
        self.lbName.text = profile?.name
        self.lbPhone.text = profile?.phone
    }
}
