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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
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
    }
    
    @IBAction func actionChangeSgm(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    @objc func onSearch() {
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func onMore() {
        
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        
    }
}

extension IssuesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: issueCell) as? IssueCell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
