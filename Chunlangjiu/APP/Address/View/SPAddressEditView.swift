//
//  SPAddressEditView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/18.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAddressEditView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 15)
        return label
    }()
    lazy var textFiled : SPTextFiled = {
        let text = SPTextFiled()
        text.font = sp_getFontSize(size: 14)
        text.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        text.clearButtonMode = .whileEditing
        return text
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var titleLeftConstraint : Constraint!
    fileprivate var contentLeftConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_updateTitleLeft(left : CGFloat){
        self.titleLeftConstraint.update(offset: left)
        self.contentLeftConstraint.update(offset: left + 100)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.textFiled)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
           self.titleLeftConstraint = maker.left.equalTo(self).offset(10).constraint
            maker.right.equalTo(self.textFiled.snp.left).offset(-9)
            maker.top.bottom.equalTo(self).offset(0)
        }
        self.textFiled.snp.makeConstraints { (maker) in
           self.contentLeftConstraint = maker.left.equalTo(self.snp.left).offset(110).constraint
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
