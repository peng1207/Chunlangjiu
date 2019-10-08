//
//  SPRegisterVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPRegisterVC: SPBaseVC {
   
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        
        return view
    }()
    fileprivate lazy var logoImageView : UIImageView = {
        let imageView = UIImageView()
       imageView.image = UIImage(named: "login_logo")
        return imageView
    }()
    fileprivate lazy var phoneTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
//        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
         textFiled.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        textFiled.sp_cornerRadius(cornerRadius: 22.5)
        textFiled.placeholder = "请输入您的手机号码"
        textFiled.keyboardType = UIKeyboardType.numberPad
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 44, height: textFiledHeight)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_phone")
        imageView.frame = CGRect(x: 21, y: 15, width: 16, height: 15)
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
//        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
         textFiled.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        textFiled.placeholder = "请输入验证码"
        textFiled.font = sp_getFontSize(size: 14)
        textFiled.sp_cornerRadius(cornerRadius: 22.5)
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 44, height: textFiledHeight)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_code")
        imageView.frame = CGRect(x: 18, y: 14, width: 14, height: 15)
        leftView.addSubview(imageView)
        
        textFiled.leftView = leftView
        textFiled.leftViewMode = UITextFieldViewMode.always
        let rigthView = UIView()
        rigthView.frame = CGRect(x: 0, y: 0, width: 110, height: textFiledHeight)
        rigthView.addSubview(self.sendCodeBtn)
        textFiled.rightView = rigthView
        textFiled.rightViewMode = UITextFieldViewMode.always
        textFiled.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return textFiled
    }()
    fileprivate lazy var sendCodeBtn : UIButton = {
        let btn = UIButton()
 
        btn.frame = CGRect(x: 10, y: 9, width: 90, height: 27)
        let att = NSMutableAttributedString(string: "获取验证码")
        att.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)], range: NSRange(location: 0, length: att.length))
        btn.setAttributedTitle(att, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSendCodeAction), for: UIControlEvents.touchUpInside)
        return btn
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
   
    fileprivate lazy var agreementBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "注册即表示同意", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.underlineColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)]))
         att.append(NSAttributedString(string: "用户协议", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.underlineColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        btn.setAttributedTitle(att, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_agreement), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_leftBack"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    override var preferredStatusBarStyle: UIStatusBarStyle{
           return .default
    }
    fileprivate let textFiledHeight : CGFloat = 45
    fileprivate var timer : Timer?
    fileprivate var timeOut : Int = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        sp_stopTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.phoneTextFiled)
        self.scrollView.addSubview(self.codeTextFiled)
        self.scrollView.addSubview(self.loginBtn)
        
        self.view.addSubview(self.agreementBtn)
        self.view.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.agreementBtn.snp.top).offset(-10)
        }
        self.logoImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(85)
            maker.height.equalTo(47)
            maker.top.equalTo(self.scrollView.snp.top).offset(sp_getstatusBarHeight() + 102)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.phoneTextFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(30)
            maker.width.equalTo(self.scrollView.snp.width).offset(-60)
            maker.height.equalTo(self.textFiledHeight)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.logoImageView.snp.bottom).offset(73)
        }
        self.codeTextFiled.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneTextFiled).offset(0)
            maker.height.equalTo(self.phoneTextFiled.snp.height).offset(0)
            maker.top.equalTo(self.phoneTextFiled.snp.bottom).offset(20)
        }
        self.loginBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.phoneTextFiled).offset(0)
            maker.height.equalTo(45)
            maker.top.equalTo(self.codeTextFiled.snp.bottom).offset(20)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-30)
        }
        self.agreementBtn.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-50)
            }
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.top.equalTo(self.view).offset(sp_getstatusBarHeight() +  9)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPRegisterVC {
    ///  发送验证码
    @objc fileprivate func sp_clickSendCodeAction(){
        if self.phoneTextFiled.text?.count == 0 {
            sp_showTextAlert(tips: "请输入手机号码")
            return
        }
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: self.phoneTextFiled.text), forKey: "mobile")
        request.parm = parm
        sp_showAnimation(view: self.view, title: "发送验证码")
        self.sendCodeBtn.isEnabled = false
        SPAppRequest.sp_getSendSms(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: msg)
            if code == SP_Request_Code_Success {
                self?.sp_startTimer()
                self?.codeTextFiled.becomeFirstResponder()
            }else{
                self?.sendCodeBtn.isEnabled = true
            }
        }
        
    }
    /// 登录
    @objc fileprivate func sp_clickLoginAction(){
        if sp_getString(string: self.phoneTextFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入手机号")
            return
        }
        if sp_getString(string: self.codeTextFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入验证码")
            return
        }
        var parm = [String :Any]()
        parm.updateValue("v2", forKey: "v")
        parm.updateValue(sp_getString(string: self.phoneTextFiled.text), forKey: "account")
        parm.updateValue(sp_getString(string: self.codeTextFiled.text), forKey: "verifycode")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: "登录中...")
        SPAppRequest.sp_getLogin(requestModel: requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                NotificationCenter.default.post(name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
                 SPAPPManager.sp_dealLoginPop()
//                self?.navigationController?.popViewController(animated: true)
            }else{
                sp_showTextAlert(tips: msg.count > 0 ? msg : "登录失败")
            }
        }
    }
    @objc fileprivate func sp_clickPwdlogin(){
        let loginVC = SPPwdLoginVC()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    /// 开始定时器
    fileprivate func sp_startTimer(){
        if let _ = self.timer {
            return
        }
        self.timeOut = 60
        self.timer = Timer(timeInterval: 1, target: self, selector: #selector(sp_timeRun), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
        
    }
    /// 定时器执行中
    @objc fileprivate func sp_timeRun(){
        self.timeOut = self.timeOut - 1
        if self.timeOut <= 0 {
            self.sp_stopTimer()
        }else{
            let att = NSMutableAttributedString(string: "\(self.timeOut)s")
            att.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)], range: NSRange(location: 0, length: att.length))
            self.sendCodeBtn.setAttributedTitle(att, for: UIControlState.normal)
        }
    }
    /// 停止定时器
    fileprivate func sp_stopTimer(){
        if let t = self.timer {
            if t.isValid {
                t.invalidate()
            }
            self.timer = nil
            let att = NSMutableAttributedString(string: "重新发送")
            att.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)], range: NSRange(location: 0, length: att.length))
            self.sendCodeBtn.setAttributedTitle(att, for: UIControlState.normal)
            self.sendCodeBtn.isEnabled = true
        }
        
    }
    @objc fileprivate func sp_agreement(){
        let webVC = SPWebVC()
        webVC.url = URL(string: SP_GET_USER_WEB_URL)
        webVC.title = "醇狼APP用户协议"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
}
extension SPRegisterVC {
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyBoardWillHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc private func sp_keyBoardWillShow(obj : Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
        }
    }
    @objc private func sp_keyBoardWillHidden(){
        self.scrollView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.agreementBtn.snp.top).offset(-10)
        }
    }
}
