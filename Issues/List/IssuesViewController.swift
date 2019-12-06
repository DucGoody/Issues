//
//  IssuesViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class IssuesViewController: BaseViewController {
    @IBOutlet weak var sgmStatus: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    let issueCell = "IssueCell"
    var listInprocess:[Issue] = []
    var listCompleted:[Issue] = []
    var listNoProcess:[Issue] = []
    var listDataMain: [Issue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.getData(status: 0)
    }
    
    func initUI() {
        self.navigationItem.title = "Danh sách sự cố"
        let searchItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_search_white"), style: .plain, target: self, action: #selector(onSearch))
        let moreItem = UIBarButtonItem.init(image: UIImage.init(named: "ic_more_white"), style: .plain, target: self, action: #selector(onMore))
        self.navigationItem.rightBarButtonItems = [moreItem,searchItem]

        self.btnAdd.layer.cornerRadius = self.btnAdd.frame.size.width/2
        
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
        self.addShadow(view: btnAdd)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: issueCell, bundle: nil), forCellReuseIdentifier: issueCell)
        self.tableView.separatorColor = UIColor.clear
    }
    
    @IBAction func actionChangeSgm(_ sender: UISegmentedControl) {
        self.getData(status: sender.selectedSegmentIndex)
    }
    
    @objc func onSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func onMore() {
        
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        self.gotoAddVC()
    }
    
    func gotoAddVC() {
        let vc = ReportIssuesViewController()
        let caching = Caching.share
        caching.saveMenuItemIndex(index: 1)
        guard var viewControllers = self.navigationController?.viewControllers else { return }
        viewControllers.remove(at: viewControllers.count - 1)
        viewControllers.append(vc)
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
       //status: -1 lấy tất cả, 0 - chưa xử lý, 1 - đang xử lý, 2 - đã xử lý
    func getData(status: Int) {
        self.showLoading()
        if status == 0 {
            listDataMain = listNoProcess
        } else if status == 1 {
            listDataMain = listInprocess
        } else if status == 2 {
            listDataMain = listCompleted
        }
        
        if listDataMain.count > 0 {
            self.hideLoading()
            self.tableView.reloadData()
            return
        }
        
        self.callService(status: status)
    }
    
    func callService(status: Int) {
        ServiceController().getIssuesByKeyword(status: status, keyword: "") { (response) in
            
            self.tableView.reloadData()
            if response?.code == 403 {
                self.reLogin(status: status)
                return
            }
            self.hideLoading()
            
            if let data = response?.data {
                self.binData(status: status,data: data.result)
            } else {
                print("Có lỗi xảy ra. Vui lòng thử lại")
            }
        }
    }
    
    func reLogin(status: Int) {
        ServiceController().relogin { (isResult) in
            if isResult {
                self.callService(status: status)
            } else {
                print("Có lỗi xảy ra. Vui lòng thử lại")
                return
            }
        }
    }
    
    func binData(status: Int, data: [Issue]) {
        self.listDataMain = data
        if status == 0 {
            listNoProcess = listDataMain
        } else if status == 1 {
            listInprocess = listDataMain
        } else if status == 2 {
            listCompleted = listDataMain
        }
        
        self.tableView.reloadData()
    }
}

extension IssuesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: issueCell) as? IssueCell {
            let item = self.listDataMain[indexPath.row]
            cell.binData(entity: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataMain.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let _ = self.listDataMain[indexPath.row]
        
    }
}
