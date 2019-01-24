//
//  SPCapitalDetVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCapitalDetVC: SPBaseVC {
    
    fileprivate lazy var headerView : SPCapitalDetHeadView = {
        let view = SPCapitalDetHeadView()
        view.backgroundColor = UIColor.white
        view.clickBlock = { [weak self] (index) in
            self?.sp_dealHeader(index: index)
        }
        return view
    }()
    fileprivate lazy var recordVC : SPCapitalDetList = {
        let vc = SPCapitalDetList()
        vc.type = SP_FUNDS_BILL_TYPE_DEFAULT
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var rechargeVC : SPCapitalDetList = {
        let vc = SPCapitalDetList()
        vc.type = SP_FUNDS_BILL_TYPE_RECHARGE
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var cashVC : SPCapitalDetList = {
        let vc = SPCapitalDetList()
        vc.type = SP_FUNDS_BILL_TYPE_CASH
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_dealHeader(index: self.headerView.sp_getIndex())
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
        self.navigationItem.title = "资金明细"
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.recordVC.view)
        self.scrollView.addSubview(self.rechargeVC.view)
        self.scrollView.addSubview(self.cashVC.view)
        self.sp_addConstraint()
    }
    /// 处理有没数据
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
        self.recordVC.view.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(self.scrollView.snp.height).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.rechargeVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordVC.view.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.recordVC.view).offset(0)
        }
        self.cashVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.rechargeVC.view.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.rechargeVC.view).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPCapitalDetVC {
    fileprivate func sp_dealHeader(index : Int){
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * CGFloat(index), y: 0), animated: true)
    }
}
