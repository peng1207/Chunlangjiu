//
//  SPLoginPwdVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/13.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPLoginPwdVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var codeTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        textFiled.placeholder = "请输入验证码"
        textFiled.sp_cornerRadius(cornerRadius: 22.5)
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 44, height: textFiledHeight)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_code")
        imageView.frame = CGRect(x: 18, y: 14, width: 18, height: 20)
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
        btn.sp_cornerRadius(cornerRadius: 13.5)
        btn.frame = CGRect(x: 10, y: 9, width: 90, height: 27)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        btn.setTitle("获取验证码", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSendCodeAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var pwdextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_dddddd.rawValue), width: sp_lineHeight)
        textFiled.placeholder = "请输入密码"
        textFiled.font = sp_getFontSize(size: 14)
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
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitle("完成", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 22.5)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
     fileprivate let textFiledHeight : CGFloat = 45
    fileprivate var timer : Timer?
    fileprivate var timeOut : Int = 60
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
        sp_stopTimer()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.codeTextFiled)
        self.scrollView.addSubview(self.pwdextFiled)
        self.scrollView.addSubview(self.doneBtn)
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
                // Fallback on earlier versions
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.codeTextFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(30)
            maker.width.equalTo(self.scrollView.snp.width).offset(-60)
            maker.height.equalTo(self.textFiledHeight)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView).offset(60)
        }
        self.pwdextFiled.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.codeTextFiled).offset(0)
            maker.top.equalTo(self.codeTextFiled.snp.bottom).offset(20)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.codeTextFiled).offset(0)
            maker.top.equalTo(self.pwdextFiled.snp.bottom).offset(20)
            maker.height.equalTo(45)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
        }
    }
    deinit {
        
    }
}
extension SPLoginPwdVC {
    @objc fileprivate func sp_clickDoneAction(){
        guard sp_getString(string: self.codeTextFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入验证码")
            return
        }
        guard sp_getString(string: self.pwdextFiled.text).count >= 6 else {
            sp_showTextAlert(tips: "请输入密码,至少6位")
            return
        }
    }
    @objc fileprivate func sp_clickSendCodeAction(){
        
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
            self.sendCodeBtn.setTitle("\(self.timeOut)s", for: UIControlState.normal)
        }
    }
    /// 停止定时器
    fileprivate func sp_stopTimer(){
        if let t = self.timer {
            if t.isValid {
                t.invalidate()
            }
            self.timer = nil
        }
        self.sendCodeBtn.setTitle("重新发送", for: UIControlState.normal)
        self.sendCodeBtn.isEnabled = true
    }
}
