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
        return textFiled
    }()
    fileprivate lazy var inputBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("填好了", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        return btn
    }()
    fileprivate lazy var noBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("没有邀请人，不填啦", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
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
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(30)
            maker.right.equalTo(self).offset(-30)
            maker.top.greaterThanOrEqualTo(self).offset(sp_getstatusBarHeight())
            maker.bottom.lessThanOrEqualTo(self).offset(-SP_TABBAR_HEIGHT)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.closeBtn.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 30, height: 30))
            maker.right.equalTo(self.contentView).offset(-20)
            maker.top.equalTo(self.contentView).offset(10)
        }
    }
    deinit {
        
    }
}
