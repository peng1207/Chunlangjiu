//
//  SPFundsVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPFundsVC: SPBaseVC {
    fileprivate lazy var headerView : SPFundsHeadView = {
        let view = SPFundsHeadView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    
    fileprivate lazy var detBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("明细", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.addTarget(self, action: #selector(sp_clickDet), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var balanceVC : SPBalanceVC = {
        let vc = SPBalanceVC()
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var bondVC : SPBondVC = {
        let vc = SPBondVC()
        self.addChildViewController(vc)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        self.navigationItem.title = "资金管理"
        self.view.addSubview(self.headerView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.balanceVC.view)
        self.scrollView.addSubview(self.bondVC.view)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.detBtn)
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
        self.balanceVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(0)
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
        }
        self.bondVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.balanceVC.view.snp.right).offset(0)
            maker.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPFundsVC {
    @objc fileprivate func sp_clickDet(){
        let capitalVC = SPCapitalDetVC()
        self.navigationController?.pushViewController(capitalVC, animated: true)
    }
}
