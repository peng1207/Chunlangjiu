//
//  SPPwdLoginVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPPwdLoginVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var phoneTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        textFiled.sp_cornerRadius(cornerRadius: 22.5)
        textFiled.placeholder = "请输入您的账号"
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 44, height: textFiledHeight)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_phone")
        imageView.frame = CGRect(x: 21, y: 15, width: 11, height: 20)
        view.addSubview(imageView)
        textFiled.leftView = view
        textFiled.leftViewMode = UITextFieldViewMode.always
        textFiled.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return textFiled
    }()
    fileprivate lazy var codeTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        textFiled.placeholder = "请输入密码"
        textFiled.sp_cornerRadius(cornerRadius: 22.5)
        textFiled.isSecureTextEntry = true
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 44, height: textFiledHeight)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_code")
        imageView.frame = CGRect(x: 18, y: 14, width: 18, height: 20)
        leftView.addSubview(imageView)
        
        textFiled.leftView = leftView
        textFiled.leftViewMode = UITextFieldViewMode.always
        textFiled.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return textFiled
    }()
   
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitle("登录", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 22.5)
        btn.addTarget(self, action: #selector(sp_clickLoginAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var forgetPwdBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("忘记密码", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickForgetAction), for: UIControlEvents.touchUpInside)
          btn.titleLabel?.font = sp_getFontSize(size: 14)
        return btn
    }()
    
     fileprivate let textFiledHeight : CGFloat = 45
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "密码登录"
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
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.phoneTextFiled)
        self.scrollView.addSubview(self.codeTextFiled)
        self.scrollView.addSubview(self.forgetPwdBtn)
        self.scrollView.addSubview(self.loginBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                  maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.phoneTextFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(30)
            maker.width.equalTo(self.scrollView.snp.width).offset(-60)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(textFiledHeight)
            maker.top.equalTo(self.scrollView).offset(60)
        }
        self.codeTextFiled.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneTextFiled).offset(0)
            maker.top.equalTo(self.phoneTextFiled.snp.bottom).offset(20)
            maker.height.equalTo(textFiledHeight)
        }
        self.loginBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneTextFiled).offset(0)
            maker.top.equalTo(self.codeTextFiled.snp.bottom).offset(20)
            maker.height.equalTo(45)
        }
        self.forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.loginBtn).offset(-10)
            maker.top.equalTo(self.loginBtn.snp.bottom).offset(5)
            maker.height.equalTo(30)
            maker.width.greaterThanOrEqualTo(0)
              maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPPwdLoginVC{
    /// 登录
    @objc fileprivate func sp_clickLoginAction(){
        guard sp_getString(string: self.phoneTextFiled.text).count > 0 else{
            sp_showTextAlert(tips: "请输入您的账号")
            return
        }
        guard sp_getString(string: self.codeTextFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入密码")
            return
        }
        sp_hideKeyboard()
        sp_sendRequest()
    }
    /// 忘记密码
    @objc fileprivate func sp_clickForgetAction(){
        let forgetVC = SPForgetPWDVC()
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
}
// MARK: - request
extension SPPwdLoginVC{
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue("v2", forKey: "v")
        parm.updateValue(sp_getString(string: self.phoneTextFiled.text), forKey: "account")
        parm.updateValue(sp_getString(string: self.codeTextFiled.text), forKey: "password")
        parm.updateValue(sp_getString(string: SP_IDENTIFIERNUMBER), forKey: "deviceid")
        parm.updateValue(sp_getString(string: SPAPPManager.instance().clientId), forKey: "clientid")
        parm.updateValue("ios", forKey: "type")
        parm.updateValue("igexin", forKey: "plugin")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: "登录中...")
        SPAppRequest.sp_getPWDLogin(requestModel: self.requestModel) { [weak self](code, msg , errorModel) in
            if code == SP_Request_Code_Success {
                NotificationCenter.default.post(name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
                self?.navigationController?.popToRootViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "登录失败")
            }
            sp_hideAnimation(view: self?.view)
        }
    }
}
