//
//  SPBalanceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/25.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPBalanceComplete = (_ isSuccess:Bool,_ text : String?)->Void

class SPBalanceView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var msgLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var pwdTextField : SPTextFiled = {
        let textField = SPTextFiled()
        textField.placeholder = "请输入支付密码"
        textField.font = sp_getFontSize(size: 16)
        textField.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        textField.sp_cornerRadius(cornerRadius: 5)
        textField.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        textField.isSecureTextEntry = true
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        return textField
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消支付", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickCanceAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确认支付", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var clickBlock : SPBalanceComplete?
    fileprivate var titleHeight : Constraint!
    fileprivate var msgHeight : Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func sp_show(title:String?,msg:String?,complete:SPBalanceComplete?){
        let view = SPBalanceView()
        view.clickBlock = complete
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.5)
        view.sp_set(title: title, msg: msg)
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appdelegate.window!).offset(0)
        }
    }
    fileprivate func sp_set(title:String?,msg:String?){
        self.titleLabel.text = sp_getString(string: title)
        self.msgLabel.text = sp_getString(string: msg)
        self.titleHeight.update(offset: sp_getString(string: title).count >  0 ? 40 : 0)
        self.msgHeight.update(offset: sp_getString(string: msg).count > 0 ? 40 : 0 )
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.msgLabel)
        self.contentView.addSubview(self.pwdTextField)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(50)
            maker.right.equalTo(self).offset(-50)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(0)
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
          self.titleHeight = maker.height.equalTo(0).constraint
        }
        self.msgLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            self.msgHeight = maker.height.equalTo(0).constraint
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
        self.pwdTextField.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.msgLabel.snp.bottom).offset(12)
            maker.height.equalTo(40)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.pwdTextField.snp.bottom).offset(12)
            maker.width.equalTo(self.doneBtn.snp.width).offset(0)
            maker.height.equalTo(40)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(0)
            maker.top.equalTo(self.canceBtn.snp.top).offset(0)
            maker.height.equalTo(self.canceBtn.snp.height).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPBalanceView {
    @objc fileprivate func sp_clickCanceAction(){
        sp_dealComplete(isSuccess: false, text: nil)
        sp_remove()
    }
    @objc fileprivate func sp_clickDoneAction(){
        if sp_getString(string: self.pwdTextField.text).count > 0 {
            sp_dealComplete(isSuccess: true, text: self.pwdTextField.text)
            sp_remove()
        }else{
            sp_showTextAlert(tips: "请输入支付密码")
        }
    }
    fileprivate func sp_dealComplete(isSuccess : Bool, text : String?) {
        guard let block = self.clickBlock else {
            return
        }
        block(isSuccess,text)
    }
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
}
