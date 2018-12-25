//
//  SPOrderHomeVC.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/24.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

class SPOrderHomeVC: SPBaseVC {
    
    fileprivate lazy var headerView : SPOrderHomeHeadView = {
        let view = SPOrderHomeHeadView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] (v ,index) in
            self?.sp_dealClick(index: index)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate var orderVC : SPOrderVC!
    fileprivate var auctionOrderVC : SPOrderVC!
    var orderType : SPOrderType = .defaultType
    var orderState : SPOrderStatus = .all
     fileprivate var isFristCome : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFristCome == false {
            self.sp_dealClick(index: self.headerView.sp_getWhich())
        }
        self.isFristCome = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "订单管理"
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.scrollView)
        self.orderVC = SPOrderVC()
        self.orderVC.orderType = self.orderType
        self.orderVC.orderState = self.orderState
        self.auctionOrderVC = SPOrderVC()
        self.auctionOrderVC.orderType = .auctionType
        self.auctionOrderVC.orderState = .all
        self.addChildViewController(self.orderVC)
        self.addChildViewController(self.auctionOrderVC)
        self.scrollView.addSubview(self.orderVC.view)
        self.scrollView.addSubview(self.auctionOrderVC.view)
        self.sp_addConstraint()
    }
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.equalTo(50)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.headerView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.orderVC.view.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.auctionOrderVC.view.snp.makeConstraints { (maker) in
            
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
            maker.left.equalTo(self.orderVC.view.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPOrderHomeVC {
    
    fileprivate func sp_dealClick(index : Int){
        
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * CGFloat(index), y: 0), animated: true)
    }
    
}
