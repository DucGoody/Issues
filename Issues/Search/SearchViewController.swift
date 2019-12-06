//
//  SearchViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cstHeightStatusBar: NSLayoutConstraint!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var lbEmptyData: UILabel!
    
    let issueCell = "IssueCell"
    var listDataMain: [Issue] = []
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
    }
    
    func initUI() {
        self.isHiddenNavigation = true
        
        self.viewSearch.layer.cornerRadius = 5
        self.cstHeightStatusBar.constant = topSafeArea
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: issueCell, bundle: nil), forCellReuseIdentifier: issueCell)
        self.tableView.isHidden = true
        
    }
    
    @IBAction func actionChangeText(_ sender: UITextField) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if self.isNilOrEmptyString(sender.text) {
                self.searchData(text: sender.text ?? "")
            } else {
                return
            }
        })
    }
    
    func searchData(text: String) {
        self.showLoading()
        self.callService(text: text)
    }
    
    func callService(text: String) {
        ServiceController().getIssuesByKeyword(status: -1, keyword: text) { (response) in
            self.tableView.reloadData()
            if response?.code == 403 {
                self.reLogin(text: text)
                return
            }
             self.hideLoading()
            if let data = response?.data {
                self.listDataMain = data.result
                self.tableView.isHidden = (self.listDataMain.count <= 0)
                self.lbEmptyData.isHidden = (self.listDataMain.count > 0)
                self.tableView.reloadData()
            } else {
                print("Có lỗi xảy ra. Vui lòng thử lại")
            }
        }
    }
    
    func reLogin(text: String) {
        ServiceController().relogin { (isResult) in
            if isResult {
                self.callService(text: text)
            } else {
                print("Có lỗi xảy ra. Vui lòng thử lại")
                return
            }
        }
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDataMain.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: issueCell) as? IssueCell {
            let item = self.listDataMain[indexPath.row]
            cell.binData(entity: item)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
