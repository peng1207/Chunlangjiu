//
//  SPAuthHomeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/13.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAuthHomeVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var headerView : SPAuthHeaderView = {
        let view = SPAuthHeaderView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var titleView : SPTextLabelView = {
        let view = SPTextLabelView()
        view.titleLabel.text = "申请认证"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var realNameView : SPAuthView = {
        let view = SPAuthView()
        view.titleLabel.text = "个人实名认证"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.imgView.image = UIImage(named: "public_realAuth")
        view.clickBlock = { [weak self]in
            self?.sp_clickReal()
        }
        return view
    }()
    fileprivate lazy var companyView : SPAuthView = {
        let view = SPAuthView()
        view.titleLabel.text = "企业实名认证"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.imgView.image = UIImage(named: "public_companyAuth")
        view.clickBlock = { [weak self] in
            self?.sp_clickCompany()
        }
        return view
    }()
    
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_authDiff")
        return view
    }()
    /// 企业认证状态
    private var companyAuth : SPCompanyAuth?{
        didSet{
            if sp_getString(string: companyAuth?.status) == SP_STATUS_FINISH {
                companyView.applyBtn.isEnabled = false
            }else{
                companyView.applyBtn.isEnabled = true
               
            }
        }
    }
    private var realNameAuth : SPRealNameAuth?{
        didSet{
            if sp_getString(string: realNameAuth?.status) == SP_STATUS_FINISH {
                realNameView.applyBtn.isEnabled = false
            }else{
                realNameView.applyBtn.isEnabled = true
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
        sp_showAnimation(view: self.view, title: nil)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_sendRealNameAuth()
        sp_sendCompanyAuthStatus()
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
    fileprivate func sp_setupData(){
        self.headerView.memberModel = SPAPPManager.instance().memberModel
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "实名认证"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerView)
        self.scrollView.addSubview(self.titleView)
        self.scrollView.addSubview(self.realNameView)
        self.scrollView.addSubview(self.companyView)
        self.scrollView.addSubview(self.imgView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView.snp.top).offset(6)
            maker.height.equalTo(90)
        }
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.headerView).offset(0)
            maker.top.equalTo(self.headerView.snp.bottom).offset(5)
            maker.height.equalTo(50)
        }
        self.realNameView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
            maker.height.equalTo(150)
            maker.width.equalTo(self.companyView.snp.width).offset(0)
        }
        self.companyView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.realNameView.snp.right).offset(0)
            maker.top.equalTo(self.realNameView.snp.top).offset(0)
            maker.right.equalTo(self.scrollView.snp.right).offset(0)
            maker.height.equalTo(self.realNameView.snp.height).offset(0)
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(18)
            maker.right.equalTo(self.scrollView.snp.right).offset(-18)
            maker.top.equalTo(self.realNameView.snp.bottom).offset(15)
            maker.height.equalTo(self.imgView.snp.width).multipliedBy(0.27)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPAuthHomeVC {
    fileprivate func sp_clickReal(){
        if sp_getString(string: self.realNameAuth?.status) ==  SP_STATUS_LOCKED{
              sp_showTextAlert(tips: "您的认证正在审核中，我们会尽快处理的")
        }else{
            if sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FAILING{
                sp_showTextAlert(tips: "您的认证被驳回，请重新提交资料审核")
            }
            let realVC = SPRealNameAuthenticationVC()
            self.navigationController?.pushViewController(realVC, animated: true)
        }
        
       
    }
    fileprivate func sp_clickCompany(){
        if sp_getString(string: self.companyAuth?.status) == SP_STATUS_LOCKED {
            sp_showTextAlert(tips: "您的认证正在审核中，我们会尽快处理的")
        }else{
            if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FAILING{
                 sp_showTextAlert(tips: "您的认证被驳回，请重新提交资料审核")
            }
            let companyVC = SPCompanyAuthenticationVC()
            self.navigationController?.pushViewController(companyVC, animated: true)
        }
    
    }
}
extension SPAuthHomeVC {
    fileprivate func sp_sendCompanyAuthStatus(){
        let request = SPRequestModel()
        SPAppRequest.sp_getCompanyAuthStatus(requestModel: request) { [weak self](code , model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.companyAuth = model
                
            }
        }
    }
    fileprivate func sp_sendRealNameAuth(){
        let request = SPRequestModel()
        SPAppRequest.sp_getRealNameAuth(requestModel: request) { [weak self](code , model , errorModel) in
             sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.realNameAuth = model
                
            }
        }
    }
}
