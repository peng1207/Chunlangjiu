//
//  SPBaseNavVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit

class SPBaseNavVC: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.viewControllers.count > 0 {
            let backBtn = UIButton(type: .custom)
            backBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
            backBtn.setImage(UIImage(named: "public_back"), for: .normal)
            if viewController.responds(to: NSSelectorFromString("sp_clickBackAction")){
                backBtn.addTarget(viewController, action: NSSelectorFromString("sp_clickBackAction"), for: .touchUpInside)
            }else{
                backBtn.addTarget(self, action: #selector(sp_clickBackAction), for: .touchUpInside)
            }
            backBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            
            viewController.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backBtn)]
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        let viewArray = super.popToRootViewController(animated: animated)
        if let list = viewArray {
            for viewController in list {
                if let webVC : SPWebVC = viewController as? SPWebVC {
                    webVC.sp_remove()
                }
            }
        }
      return viewArray
    }
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if viewController is SPWebVC {
            if let webVC : SPWebVC = viewController as? SPWebVC {
                webVC.sp_remove()
            }
        }
        return super.popToViewController(viewController, animated: animated)
    }
    
    @objc fileprivate func sp_clickBackAction(){
        self.popViewController(animated: true)
    }
    /// UINavigationController
    override var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var childViewControllerForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}

extension UINavigationController{
    
    class func sp_initialize(){
        let navBar = UINavigationBar.appearance()
        navBar.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)), for: UIBarMetrics.default)
//        navBar.barTintColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
//        navBar.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        navBar.shadowImage = UIImage()
       
        navBar.titleTextAttributes = [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18), NSAttributedStringKey.foregroundColor:UIColor.white] as [NSAttributedStringKey : Any]
         
    }
    
}
