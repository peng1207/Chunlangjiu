//
//  SPCommissionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/1.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCommissionView:  UIView{
    
    fileprivate lazy var pCommissionView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "平台佣金"
        return view
    }()
    fileprivate lazy var sPayView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "商家实收"
        view.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var  commissionHeight : Constraint!
    fileprivate var payHeight : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.pCommissionView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.detaileModel?.commission))"
        self.sPayView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.detaileModel?.shop_payment))"
        if sp_getString(string: self.detaileModel?.commission).count > 0 {
            self.commissionHeight.update(offset: 40)
        }else{
            self.commissionHeight.update(offset: 0)
        }
        if sp_getString(string: self.detaileModel?.shop_payment).count > 0 {
            self.payHeight.update(offset: 40)
        }else{
            self.payHeight.update(offset: 0)
        }
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.pCommissionView)
        self.addSubview(self.sPayView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.pCommissionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(0)
           self.commissionHeight =  maker.height.equalTo(0).constraint
        }
        self.sPayView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.pCommissionView).offset(0)
            maker.top.equalTo(self.pCommissionView.snp.bottom).offset(0)
          self.payHeight = maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
