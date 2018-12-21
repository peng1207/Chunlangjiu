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
    fileprivate lazy var oldPwdView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.titleLabel.text = "原密码"
        view.textFiled.placeholder = "请输入原密码"
        view.sp_updateTitleLeft(left: 13)
        view.textFiled.isSecureTextEntry = true
        return view
    }()
    fileprivate lazy var newPwdView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.titleLabel.text = "新密码"
        view.textFiled.placeholder = "请输入新密码"
        view.sp_updateTitleLeft(left: 13)
        view.textFiled.isSecureTextEntry = true
        return view
    }()
    fileprivate lazy var confirmPwdView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.titleLabel.text = "确认新密码"
        view.textFiled.placeholder = "请输入确认新密码"
        view.sp_updateTitleLeft(left: 13)
        view.lineView.isHidden = true
        view.textFiled.isSecureTextEntry = true
        return view
    }()
    
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton()
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitle("完成", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
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
        self.navigationItem.title = "修改登录密码"
      
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.oldPwdView)
        self.scrollView.addSubview(self.newPwdView)
        self.scrollView.addSubview(self.confirmPwdView)
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
        self.oldPwdView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.height.equalTo(50)
        }
        self.newPwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.oldPwdView).offset(0)
            maker.top.equalTo(self.oldPwdView.snp.bottom).offset(0)
        }
        self.confirmPwdView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.newPwdView).offset(0)
            maker.top.equalTo(self.newPwdView.snp.bottom).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.confirmPwdView.snp.bottom).offset(100)
            maker.height.equalTo(45)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-20)
        }
    }
    deinit {
        
    }
}
extension SPLoginPwdVC {
    @objc fileprivate func sp_clickDoneAction(){
        guard sp_getString(string: self.oldPwdView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入原密码")
            return
        }
        guard sp_getString(string: self.newPwdView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入新密码")
            return
        }
        guard sp_getString(string: self.confirmPwdView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入确认新密码")
            return
        }
        guard sp_getString(string: self.newPwdView.textFiled.text) == sp_getString(string: self.confirmPwdView.textFiled.text) else {
            sp_showTextAlert(tips: "输入新密码与确认密码不一致")
            return
        }
    }
   
    
}
