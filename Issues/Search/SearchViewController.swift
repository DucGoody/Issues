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
    
    let issueCell = "IssueCell"
    
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
        
    }
    
    @IBAction func actionChangeText(_ sender: UITextField) {
        
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: issueCell) as? IssueCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
