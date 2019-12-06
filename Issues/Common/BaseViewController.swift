//
//  BaseViewController.swift
//  Issues
//
//  Created by HoangVanDuc on 12/4/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    var isHiddenNavigation: Bool = false
    
    var topSafeArea: CGFloat = 0
    var bottomSafeArea: CGFloat = 0
    
    private var viewLoad: UIView!
    private var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNav()
        self.getHeightArea()
        self.initLoading()
    }
    
    private func getHeightArea() {
        if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
            topSafeArea = keyWindow?.safeAreaInsets.top ?? 0
            bottomSafeArea = keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    private func initNav() {
        self.navigationController?.navigationBar.barTintColor = self.hexStringToUIColor(hex: "916E25")
        let item2 = UIBarButtonItem.init(image: UIImage.init(named: "ic_menu2")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(actionMenu))
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItems = [item2]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(isHiddenNavigation, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func actionMenu() {
        let vc = MenuViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.navigationControllerInput = self.navigationController
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
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
    
    func addShadow(view: UIView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
    }
    
    func isNilOrEmptyString(_ text: String?) -> Bool {
        let text = text?.trimmingCharacters(in: CharacterSet.whitespaces)
        if let text = text {
            return !text.isEmpty && text.count > 0
        }
        return false
    }
    
    private func initLoading() {
        viewLoad = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .medium)
        
        self.view.addSubview(viewLoad)
        self.viewLoad.addSubview(indicator)
        
        self.addShadowBold(self.viewLoad)
        self.indicator.startAnimating()
        self.indicator.color = .white
        self.viewLoad.layer.cornerRadius = 8
        self.viewLoad.clipsToBounds = true
        
        self.viewLoad.snp.makeConstraints({ (view) in
            view.center.equalTo(self.view)
            view.height.equalTo(30)
            view.width.equalTo(30)
        })
        
        self.indicator.snp.makeConstraints { (indi) in
            indi.center.equalTo(self.viewLoad)
        }
        
        self.viewLoad.isHidden = true
    }
    
    func showLoading() {
        self.view.endEditing(true)
        self.viewLoad.isHidden = false
    }
    
    func hideLoading() {
        self.viewLoad.isHidden = true
    }
    
    func addShadowBold(_ yourView: UIView) {
        yourView.layer.masksToBounds = false
        yourView.layer.shadowColor = UIColor.gray.cgColor
        yourView.layer.shadowOpacity = 0.5
        yourView.layer.shadowOffset = CGSize(width: -1, height: 1)
        yourView.layer.shadowRadius = 5
        yourView.layer.shadowPath = UIBezierPath(rect: yourView.bounds).cgPath
        yourView.layer.shouldRasterize = true
        yourView.layer.rasterizationScale = UIScreen.main.scale
    }
}
