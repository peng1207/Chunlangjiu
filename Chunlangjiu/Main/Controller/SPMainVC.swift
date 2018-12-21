//
//  SPMainVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit

class SPMainVC: UITabBarController {
    
    fileprivate lazy var mainTabbarView : SPTabbarView = {
        let view = SPTabbarView()
        view.frame = self.tabBar.bounds
        view.clickComplete = { [weak self](index : Int) in
            self?.sp_dealClickAction(index: index)
        }
        return view
    }()

    fileprivate var isFrist : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setTabBarLocationWithLevel(fontLevel: 0)
        self.sp_setupTabBarView()
        self.sp_setupVC()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sp_removeTabbarButton()
        self.selectedViewController?.beginAppearanceTransition(true, animated: animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sp_removeTabbarButton()
        sp_log(message: "self.tabBar.frame is \(self.tabBar.frame)")
        if self.isFrist {
            var frame = self.tabBar.frame
            frame.size.height = frame.size.height - SP_TABBAR_DEFAULT_HEIGHT + SP_TABBAR_HEIGHT
            frame.origin.y = frame.origin.y - (SP_TABBAR_HEIGHT - SP_TABBAR_DEFAULT_HEIGHT)
            self.tabBar.frame = frame
        }
       self.isFrist = false
    }
    fileprivate func sp_removeTabbarButton(){
        tabBar.subviews.forEach { (subView) in
            if subView is UIControl {
                subView.removeFromSuperview()
            }
        }
        self.mainTabbarView.sp_setAllBtnEdgeInsets()
    }
    
    /// 创建自定义tabbarview
    private func sp_setupTabBarView(){
        self.tabBar.addSubview(self.mainTabbarView)
        self.tabBar.backgroundImage = UIImage.sp_getImageWithColor(color: UIColor.white)
        self.tabBar.shadowImage = UIImage.sp_getImageWithColor(color: UIColor.clear)
        self.mainTabbarView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.tabBar).offset(0)
            maker.height.equalTo(SP_TABBAR_HEIGHT)
        }
    }
    
    private func sp_setTabBarLocationWithLevel(fontLevel : Int) {
        self.tabBar.setNeedsLayout()
        self.tabBar.layoutSubviews()
        
     }
    
    private func sp_setupVC(){

        UINavigationController.sp_initialize()
        
        let indexVC =  SPIndexVC()
        let indexNavVC = SPBaseNavVC(rootViewController: indexVC)
        self.addChildViewController(indexNavVC)
    
        let sortVC = SPSortVC()
        let sortNavVC = SPBaseNavVC(rootViewController: sortVC)
        self.addChildViewController(sortNavVC)
        if SP_ISSHOW_AUCTION {
            let auctionVC = SPAuctionVC()
            let auctionNavVC = SPBaseNavVC(rootViewController: auctionVC)
            self.addChildViewController(auctionNavVC)
        }
        
        let shopcartVC = SPShopCartVC()
        let shopcartNavVC = SPBaseNavVC(rootViewController: shopcartVC)
        self.addChildViewController(shopcartNavVC)
        
        let mineVC = SPMineVC()
        let mineNavVC = SPBaseNavVC(rootViewController: mineVC)
        self.addChildViewController(mineNavVC)
      
    }
}
// MARK: - action
extension SPMainVC {
    fileprivate func sp_dealClickAction(index:Int){
        self.selectedIndex = index
    }
}
