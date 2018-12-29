//
//  SPRechargeHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPRechargeHeaderView:  UIView{
    fileprivate lazy var priceView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "金额"
        view.textFiled.placeholder = "单笔金额不高于50000"
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var titleView : SPTextLabelView = {
        let view = SPTextLabelView()
        view.titleLabel.text = "支付方式"
         view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var lineView : UIView = {
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
        self.addSubview(self.priceView)
        self.addSubview(self.titleView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(10)
            maker.height.equalTo(50)
        }
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(10)
            maker.height.equalTo(50)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
