//
//  SPAddressFlexView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/18.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAddressFlexView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    lazy var textView : SPTextView = {
        let view = SPTextView()
        view.textView.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return view
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
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
        self.addSubview(self.titleLabel)
        self.addSubview(self.textView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.top.equalTo(self.snp.top).offset(15)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.textView.snp.left).offset(-9)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(110)
            maker.top.equalTo(self.titleLabel.snp.top).offset(-5)
            maker.height.greaterThanOrEqualTo(15)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.bottom.equalTo(self.snp.bottom).offset(-15)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.textView.snp.bottom).offset(15)
            maker.height.equalTo(sp_lineHeight)
        }
        
    }
    deinit {
        
    }
}
