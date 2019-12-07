//
//  MenuViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import Kingfisher

class MenuViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewControl: UIControl!
    
    var listItemMenu: [MenuEntity]!
    let avatarCell: String = "AvatarCell"
    let itemCell: String = "ItemMenuCell"
    var navigationControllerInput: UINavigationController?
    var userProfile: UserProfile!
    var imageAvatar: UIImage?
    var caching: Caching?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.caching = Caching.share
        self.userProfile = self.caching?.getUserProfile()?.userProfile
        
        self.isHiddenNavigation = true
        self.initListMenu()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = .clear
        self.tableView.register(UINib.init(nibName: avatarCell, bundle: nil), forCellReuseIdentifier: avatarCell)
        self.tableView.register(UINib.init(nibName: itemCell, bundle: nil), forCellReuseIdentifier: itemCell)
        
    }
    
    func initListMenu() {
        listItemMenu = [
            MenuEntity.init(imageName: "ic_report", name: "Báo sự cố"),
            MenuEntity.init(imageName: "ic_list", name: "Danh sách sự cố"),
            MenuEntity.init(imageName: "ic_person", name: "Hồ sơ"),
            MenuEntity.init(imageName: "ic_settings", name: "Cài đặt"),
            MenuEntity.init(imageName: "ic_logout", name: "Đăng xuất")
        ]
    }
    
    @IBAction func actionBackground(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItemMenu.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.getAvatarCell()
        } else {
            return self.getItemCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.gotoVC(vc: ReportIssuesViewController(), row: indexPath.row)
        case 2:
            self.gotoVC(vc: IssuesViewController(), row: indexPath.row)
        case 3:
            self.gotoVC(vc: ProfileViewController(), row: indexPath.row)
        case 4:
            self.gotoVC(vc: SettingsViewController(), row: indexPath.row)
        case 5:
            self.logOut()
        default:
            return
        }
    }
    
    func getIndex() -> Int {
        return caching?.getMenuItemIndex() ?? 1
    }
    
    func getItemCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: itemCell) as? ItemMenuCell {
            cell.setData(item: self.listItemMenu[indexPath.row - 1])
            cell.setSelectItem(isSelect: self.getIndex() == indexPath.row)
            return cell
        }
        return UITableViewCell()
    }
    
    func getAvatarCell() -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: avatarCell) as? AvatarCell {
            cell.ivAvatar.setImage(self.userProfile.avatar)
            cell.lbName.text = self.userProfile.name
            cell.lbPhone.text = self.userProfile.phone
            return cell
        }
        return UITableViewCell()
    }
    
    func gotoVC(vc: UIViewController, row: Int) {
        if getIndex() == row {
            self.dismiss(animated: false, completion: nil)
            return
        }
        caching?.saveMenuItemIndex(index: row)
        guard var viewControllers = self.navigationControllerInput?.viewControllers else { return }
        viewControllers.remove(at: viewControllers.count - 1)
        viewControllers.append(vc)
        self.navigationControllerInput?.setViewControllers(viewControllers, animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
    func logOut() {
        let alert = UIAlertController(title: "Đăng xuất", message: "Bạn có chắc chắn muốn đăng xuất?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Huỷ", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Đồng ý", style: .default, handler: { action in
            //xử lý logout
            let cache = Caching.share
            cache.clearToken()
            AppDelegate.share.startLogin()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class MenuEntity: NSObject {
    var imageName: String!
    var name: String!
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
}

extension UIImageView {
    
    func setImage(_ url: String) {
        let urlString = "\(ServiceController().domain)\(url)"
        if let url2 = URL(string: urlString){
            let placeholder = UIImage(named: "ic_default")
            self.kf.indicatorType = .activity
            self.kf.setImage(with: url2,placeholder: placeholder)
        }
    }
}
