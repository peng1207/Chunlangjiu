//
//  SPReviewProductVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPReviewProductVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var btnView : SPShopProductBtnView = {
        let view = SPShopProductBtnView()
        view.titleArray = ["审核中","审核驳回"]
        view.clickBlock = { [weak self] in
            self?.sp_setScrollViewOffset()
        }
        return view
    }()
    
    fileprivate lazy var pendingVC : SPShopProductVC = {
        let vc = SPShopProductVC()
        vc.type = SP_Product_Type.review_pending
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var refuseVC : SPShopProductVC = {
        let vc = SPShopProductVC()
        vc.type = SP_Product_Type.revice_refuse
        self.addChildViewController(vc)
        return vc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         sp_setScrollViewOffset()
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
        self.navigationItem.title = "审核商品"
        self.view.addSubview(self.btnView)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.pendingVC.view)
        self.scrollView.addSubview(self.refuseVC.view)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.equalTo(50)
        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.btnView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.pendingVC.view.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.refuseVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.pendingVC.view.snp.right).offset(0)
            maker.top.width.height.equalTo(self.pendingVC.view).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPReviewProductVC {
    
    fileprivate func sp_setScrollViewOffset(){
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.size.width * CGFloat(self.btnView.sp_getSelectIndex()), y: 0), animated: true)
    }
    
    
}
