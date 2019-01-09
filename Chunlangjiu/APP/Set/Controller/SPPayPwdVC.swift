//
//  SPPayPwdVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/13.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPPayPwdVC: SPBaseVC {
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate lazy var codeViw : SPInputBtnView = {
        let view = SPInputBtnView()
        view.titleLabel.text = "验证码"
        view.textFiled.placeholder = "请输入验证码"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.clickBlock = { [weak self] in
            self?.sp_clickCode()
        }
        return view
    }()
    fileprivate lazy var pwdView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "密码"
        view.textFiled.placeholder = "请输入6～16字母加数字的密码"
        view.textFiled.isSecureTextEntry = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var confirmPwdView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "确认密码"
        view.textFiled.placeholder = "请输入6～16字母加数字的密码"
        view.textFiled.isSecureTextEntry = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提交", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.codeViw.sp_stopTime()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = "验证码将会发送到\(sp_getString(string: SPAPPManager.instance().memberModel?.login_account).replacePhone())手机上"
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "修改支付密码"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.codeViw)
        self.scrollView.addSubview(self.pwdView)
        self.scrollView.addSubview(self.confirmPwdView)
        self.view.addSubview(self.submitBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.submitBtn.snp.top).offset(-10)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view.snp.right).offset(-10)
            maker.height.equalTo(40)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.codeViw.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            maker.height.equalTo(40)
        }
        self.pwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.codeViw).offset(0)
            maker.top.equalTo(self.codeViw.snp.bottom).offset(10)
        }
        self.confirmPwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.pwdView).offset(0)
            maker.top.equalTo(self.pwdView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPayPwdVC {
    @objc fileprivate func sp_clickSubmit(){
        guard sp_getString(string: self.codeViw.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入验证码")
            return
        }
        guard sp_getString(string: self.pwdView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入支付密码")
            return
        }
        guard sp_getString(string: self.confirmPwdView.textFiled.text).count > 0 else{
            sp_showTextAlert(tips: "请输入确认支付密码")
            return
        }
        guard sp_getString(string: self.pwdView.textFiled.text) == sp_getString(string: self.confirmPwdView.textFiled.text) else {
            sp_showTextAlert(tips: "支付密码不一致")
            return
        }
        
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.pwdView.textFiled.text), forKey: "password")
        parm.updateValue(sp_getString(string: self.confirmPwdView.textFiled.text), forKey: "password_confirmation")
        parm.updateValue(sp_getString(string: self.codeViw.textFiled.text), forKey: "verifycode")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPSetRequest.sp_getModifyPayPwd(requestModel: requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                sp_showTextAlert(tips: "修改密码成功")
                self?.navigationController?.popViewController(animated: true)
            }else {
                sp_showTextAlert(tips: sp_getString(string: msg))
            }
        }
    }
    @objc fileprivate func sp_clickCode(){
        let parm = [String : Any]()
        let request = SPRequestModel()
        request.parm = parm
        SPSetRequest.sp_getSendCMS(requestModel: request) { [weak self](code, msg, errorModel) in
            if code == SP_Request_Code_Success {
                self?.codeViw.sp_startTime()
                sp_showTextAlert(tips: "验证码发送成功")
            }else{
                sp_showTextAlert(tips: sp_getString(string: msg))
            }
        }
    }
    
}
