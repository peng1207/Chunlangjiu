//
//  SPLoginMainVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/13.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPLoginMainVC: SPBaseVC {
    fileprivate lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "login_logo")
        return view
    }()
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 25)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_login), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var registerBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        let att = NSMutableAttributedString(string: "注册")
        att.addAttributes([NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)], range: NSRange(location: 0, length: att.length))
        btn.setAttributedTitle(att, for: UIControlState.normal)
        
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.addTarget(self, action: #selector(sp_register), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var qqBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_qq"), for: UIControlState.normal)
        btn.isHidden = SPThridManager.sp_isInstallQQ() ? false : true
        btn.addTarget(self, action: #selector(sp_qqLogin), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var wxBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_wx"), for: UIControlState.normal)
        btn.isHidden = SPThridManager.sp_isInstallWX() ? false : true
        btn.addTarget(self, action: #selector(sp_wxLogin), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var sinaBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_sina"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_sinaLogin), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_leftBack"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
         UIApplication.shared.statusBarStyle = .default
        super.viewDidLoad()
        self.sp_setupUI()
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
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.logoImgView)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.qqBtn)
        self.view.addSubview(self.wxBtn)
        self.view.addSubview(self.sinaBtn)
        self.view.addSubview(self.registerBtn)
        self.view.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    override func sp_clickBackAction() {
        super.sp_clickBackAction()
        UIApplication.shared.statusBarStyle = .lightContent
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.logoImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(85)
            maker.height.equalTo(47)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
            maker.top.equalTo(sp_getstatusBarHeight() + 102)
        }
        self.loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(40)
            maker.right.equalTo(self.view).offset(-40)
            maker.height.equalTo(50)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
            maker.bottom.lessThanOrEqualTo(self.qqBtn.snp.top).offset(-20)
        }
        self.qqBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(41)
            maker.width.equalTo(39)
            maker.height.equalTo(27)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-50)
            }
        }
        self.wxBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(33)
            maker.height.equalTo(27)
            maker.centerY.equalTo(self.qqBtn.snp.centerY).offset(0)
            maker.right.equalTo(self.view.snp.centerX).offset(-28)
        }
        self.sinaBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(36)
            maker.height.equalTo(27)
            maker.centerY.equalTo(self.wxBtn.snp.centerY).offset(0)
            maker.left.equalTo(self.view.snp.centerX).offset(28)
        }
        self.registerBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view).offset(-41)
            maker.height.equalTo(30)
            maker.width.equalTo(50)
            maker.centerY.equalTo(self.sinaBtn.snp.centerY).offset(0)
            
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.top.equalTo(self.view).offset(sp_getstatusBarHeight() +  9)
        }
    }
    deinit {
        
    }
}
extension SPLoginMainVC {
    /// 跳到登录界面
    @objc fileprivate func sp_login(){
        let vc = SPLoginVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 微信登录
    @objc fileprivate func sp_wxLogin(){
      
        SPShareManager.sp_thridLogin(viewController: self, shareType: SP_SharePlatformType.wechateSession) { [weak self](model, error) in
            model?.platformType = .wechateSession
            self?.sp_dealThirdLoginComplete(model: model, error: error)
        }
    }
    /// qq登录
    @objc fileprivate func sp_qqLogin(){
        
        SPShareManager.sp_thridLogin(viewController: self, shareType: SP_SharePlatformType.qq) { [weak self](model, error) in
            model?.platformType = .qq
            self?.sp_dealThirdLoginComplete(model: model, error: error)
        }
    }
    /// 新浪登录
    @objc fileprivate func sp_sinaLogin(){
        
        SPShareManager.sp_thridLogin(viewController: self, shareType: SP_SharePlatformType.sina) { [weak self](model, error) in
            model?.platformType = .sina
            self?.sp_dealThirdLoginComplete(model: model, error: error )
        }
    }
    /// 注册
    @objc fileprivate func sp_register(){
        let vc = SPRegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 绑定
    fileprivate func sp_bind(model : SPThridLoginCompleteModel?){
        let vc = SPThirdBindVC()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /// 处理第三方登录之后回调
    ///
    /// - Parameters:
    ///   - model: 第三方数据
    ///   - error: 错误码
    fileprivate func sp_dealThirdLoginComplete(model : SPThridLoginCompleteModel?,error:Error?){
        if let m = model {
            sp_sendThirdLoginRequest(model: m)
        }else {
            
            sp_showTextAlert(tips: "第三方登录失败")
        }
    }
    
}
extension SPLoginMainVC {
    
    /// 发送第三方登录请求
    ///
    /// - Parameter model: 第三方数据
    fileprivate func sp_sendThirdLoginRequest(model : SPThridLoginCompleteModel){
          sp_showAnimation(view: self.view, title: nil)
        var parm = [String : Any]()
        if let dic = model.originalResponse as? [String : Any] {
            var json = [String : Any]()
            if model.platformType == SP_SharePlatformType.sina {
                for (key,value) in dic {
                    json.updateValue(sp_getString(string: value), forKey: key)
                }
            }else{
                json = dic
            }
             model.originalResponse = json
             parm.updateValue(sp_getString(string: sp_dicValueString(json)), forKey: "trust_params")
        }
       
        self.requestModel.parm = parm
        SPAppRequest.sp_getThirdLogin(requestModel: self.requestModel) { [weak self](code, binded,msg, errorModel) in
           
            if code == SP_Request_Code_Success {
                if binded == "1"{
                    // 已绑定
                    NotificationCenter.default.post(name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
                    sp_asyncAfter(time: 0.5, complete: {
                         SPAPPManager.sp_dealLoginPop()
                    })
                   
                }else{
                    sp_hideAnimation(view: self?.view)
                    // 没有绑定
                    self?.sp_bind(model: model)
                }
            }else {
                 sp_hideAnimation(view: self?.view)
                sp_showTextAlert(tips: msg.count > 0  ? msg : "登录失败")
            }
        }
    }
    
}
