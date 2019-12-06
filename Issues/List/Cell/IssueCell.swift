//
//  IssueCell.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class IssueCell: UITableViewCell {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbHour: UILabel!
    @IBOutlet weak var lbDay: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func binData(entity: Issue) {
        self.lbName.text = entity.title
        self.lbAddress.text = entity.add
        self.lbHour.text = entity.time
        self.lbDay.text = entity.date
    }
}
