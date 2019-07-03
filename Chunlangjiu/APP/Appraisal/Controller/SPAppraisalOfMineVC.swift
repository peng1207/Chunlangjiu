//
//  SPAppraisalOfMineVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 我的鉴定

import Foundation
import SnapKit
class SPAppraisalOfMineVC: SPBaseVC {
 
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var unidentifiedVC : SPAppraisalProductVC = {
        let vc = SPAppraisalProductVC()
        vc.addHeader = true
        vc.status = SPAPPraisalProductStatus_False
        vc.user_status = "0"
        vc.scrollBlock = { [weak self] (scrollView) in
            self?.sp_didScroll(scrollView: scrollView)
        }
        vc.btnView.clickBlock = { [weak self] (index) in
            self?.sp_dealClick(index: index)
        }
        vc.countComplete = { [weak self](true_count,false_count)in
            self?.sp_dealCount(true_count: true_count, false_count: false_count)
        }
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate lazy var identifiedVC : SPAppraisalProductVC = {
        let vc = SPAppraisalProductVC()
        vc.addHeader = true
        vc.status = SPAPPraisalProductStatus_True
        vc.user_status = "0"
        vc.scrollBlock = { [weak self] (scrollView) in
            self?.sp_didScroll(scrollView: scrollView)
        }
        vc.btnView.clickBlock = { [weak self] (index) in
            self?.sp_dealClick(index: index)
        }
        vc.countComplete = { [weak self](true_count,false_count)in
            self?.sp_dealCount(true_count: true_count, false_count: false_count)
        }
        self.addChildViewController(vc)
        return vc
    }()
    fileprivate var headerTop : Constraint!
    fileprivate var top : CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         sp_dealClick(index: self.unidentifiedVC.btnView.sp_getSelect())
          sp_sendInfoRequest()
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
        self.navigationItem.title = "鉴定师"
 
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.unidentifiedVC.view)
        self.scrollView.addSubview(self.identifiedVC.view)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
 
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
//            maker.top.equalTo(self.headerView.snp.bottom).offset(0)
            maker.top.equalTo(self.view.snp.top).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.unidentifiedVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(0)
            maker.top.equalTo(self.scrollView).offset(0)
            maker.width.height.equalTo(self.scrollView).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.identifiedVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.unidentifiedVC.view.snp.right).offset(0)
            maker.top.height.width.equalTo(self.unidentifiedVC.view).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAppraisalOfMineVC {
    
    fileprivate func sp_clickEditInfo(){
        let vc = SPAppraisalEditInfoVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_dealClick(index :Int){
        self.scrollView.setContentOffset(CGPoint(x: CGFloat(index)  * self.scrollView.frame.size.width, y: 0), animated: false)
        self.unidentifiedVC.btnView.sp_dealSelect(index: index)
        self.identifiedVC.btnView.sp_dealSelect(index: index)
    }
    fileprivate func sp_didScroll(scrollView : UIScrollView){
//        let point = scrollView.panGestureRecognizer.translation(in: self.view)
//        if point.y > 0  {
//            sp_log(message: "------往上滚动")
//        }else{
//            sp_log(message: "------往下滚动")
//        }
    }
    /// 处理scrollview 向上滚动
    ///
    /// - Parameter scrollView: 当前scrollView
    fileprivate func sp_dealUpward(scrollView : UIScrollView) {
        if scrollView.contentSize.height <= scrollView.frame.size.height {
            return
        }
        if scrollView.frame.size.height == self.view.frame.size.height {
            return
        }
    }
    /// 处理scrollView 向下滚动
    ///
    /// - Parameter scrollView: 当前scrollView
    fileprivate func sp_dealDown(scrollView : UIScrollView) {
        if self.top == 0 {
            return
        }
    }
    fileprivate func sp_dealHeaderTop(){
        self.headerTop.update(offset: self.top)
    }
   fileprivate func sp_dealCount(true_count: String ,false_count : String){
        sp_dealCount(true_count: true_count, false_count: false_count, btnView: self.identifiedVC.btnView)
         sp_dealCount(true_count: true_count, false_count: false_count, btnView: self.unidentifiedVC.btnView)
    }
    private func sp_dealCount(true_count: String ,false_count : String,btnView : SPAppraisalBtnView){
        btnView.unidentifiedBtn.setTitle("待鉴定\n(\(sp_getString(string: false_count)))", for: UIControlState.normal)
        btnView.identifiedBtBtn.setTitle("已鉴定\n(\(sp_getString(string: true_count)))", for: UIControlState.normal)
    }
}


extension SPAppraisalOfMineVC {
    
    
    fileprivate  func sp_sendInfoRequest(){
        sp_showAnimation(view: self.view, title: nil)
        let parm = [String : Any]()
        self.requestModel.parm = parm
        SPAppraisalRequest.sp_getShopAppraisalInfo(requestModel: self.requestModel) { [weak self](code, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.unidentifiedVC.infoModel = model
                self?.identifiedVC.infoModel = model
            }else{
                
            }
        }
    }
    
}
