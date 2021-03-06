//
//  SPInvitationCodeView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/9.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPInvitationCodeView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var closeBtn : UIButton = {
        let btn = UIButton()
        return btn
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        label.text = "嗨！欢迎来到醇狼高端酒交易平台，您可以在下面的输入框填写您的邀请人（选填）："
        return label
    }()
    fileprivate lazy var inputTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.placeholder = "请填写邀请人的邀请码"
        textFiled.font = sp_getFontSize(size: 16)
        textFiled.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return textFiled
    }()
    fileprivate lazy var inputBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("填好了", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickInput), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var noBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("没有邀请人 不填啦", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_remove), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    class func sp_showView(){
        let view = SPInvitationCodeView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue).withAlphaComponent(0.3)
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo((appdelegate.window!))
            maker.bottom.equalTo((appdelegate.window?.snp.bottom)!).offset(0)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_addNotification()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.closeBtn)
        self.contentView.addSubview(self.inputBtn)
        self.contentView.addSubview(self.inputTextFiled)
        self.contentView.addSubview(self.noBtn)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(30)
            maker.right.equalTo(self).offset(-30)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.top.greaterThanOrEqualTo(self).offset(sp_getstatusBarHeight())
            maker.bottom.lessThanOrEqualTo(self).offset(-SP_TABBAR_HEIGHT)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.right.equalTo(self.contentView).offset(-20)
            maker.top.equalTo(self.contentView).offset(10)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
             maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
             maker.top.equalTo(self.closeBtn.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.inputTextFiled.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.equalTo(40)
        }
        self.noBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.inputTextFiled.snp.bottom).offset(20)
            maker.height.equalTo(40)
            maker.width.equalTo(self.inputBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.inputBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.noBtn.snp.right).offset(0)
            maker.top.height.equalTo(self.noBtn).offset(0)
            maker.right.equalTo(self.contentView).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
             maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.noBtn.snp.top).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        
    }
    deinit {
        sp_removeNotification()
    }
}
extension SPInvitationCodeView {
   @objc fileprivate func sp_remove(){
        sp_removeNotification()
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_clickInput(){
        if sp_getString(string: self.inputTextFiled.text).count == 0 {
            sp_showTextAlert(tips: "请输入邀请码")
            return
        }
        sp_sendRequest()
        sp_remove()
    }
    
}
extension SPInvitationCodeView {
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.inputTextFiled.text), forKey: "referrer")
        let requestModel = SPRequestModel()
        requestModel.parm = parm
        SPFansRequest.sp_getInputInvitationCode(requestModel: requestModel) { (code, msg, errorModel) in
            
        }
    }
}
extension SPInvitationCodeView {
    
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    fileprivate func sp_removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
   @objc fileprivate func sp_keyboardShow(obj:Notification){
         let height = sp_getKeyBoardheight(notification: obj)
        sp_dealContentLayout(height: height)
    }
   @objc fileprivate func sp_keyboardHidden(){
        sp_dealContentLayout(height: 0)
    }
    fileprivate func sp_dealContentLayout(height:CGFloat){
        self.contentView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(30)
            maker.right.equalTo(self).offset(-30)
            if height > 0 {
                maker.bottom.equalTo(self.snp.bottom).offset(-height)
            }else{
                maker.centerY.equalTo(self.snp.centerY).offset(0)
                maker.top.greaterThanOrEqualTo(self).offset(sp_getstatusBarHeight())
                maker.bottom.lessThanOrEqualTo(self).offset(-SP_TABBAR_HEIGHT)
            }
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    
}
