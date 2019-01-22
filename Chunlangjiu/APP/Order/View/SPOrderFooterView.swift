//
//  SPOrderFooterView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderFooterView:  UIView{
    
    fileprivate var codeView : SPOrderBaseView = {
        let view = SPOrderBaseView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate var payView : SPOrderPayView = {
        let view = SPOrderPayView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate var refundView : SPOrderRefundView = {
        let view = SPOrderRefundView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    fileprivate var addressView : SPOrderAddressView = {
        let view = SPOrderAddressView()
        view.backgroundColor = UIColor.white
        return view
    }()
     var priceView : SPOrderPriceView = {
        let view = SPOrderPriceView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var logicView : SPOrderLogicView = {
        let view = SPOrderLogicView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var commissionView : SPCommissionView = {
        let view = SPCommissionView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var refundTop : Constraint!
    fileprivate var payTop : Constraint!
    fileprivate var commissionTop : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.codeView.detaileModel = self.detaileModel
        self.payView.detaileModel = self.detaileModel
        self.addressView.detaileModel = self.detaileModel
        self.priceView.detaileModel = self.detaileModel
        self.refundView.detaileModel = self.detaileModel
        self.logicView.logicModel = self.detaileModel?.logi
         var isRefund = false
        if let isAS = self.detaileModel?.sp_isAfterSales(), isAS == true {
            self.payView.isHidden = true
            self.refundView.isHidden = false
            isRefund = true
            self.addressView.isHidden = true
            self.payTop.update(offset: 0)
        }else{
            self.refundView.isHidden = true
            self.payView.isHidden = false
            self.addressView.isHidden = false
            self.payTop.update(offset: 10)
        }
        var isLogic = false
        if self.detaileModel?.logi != nil {
            isLogic = true
        }
       
        self.logicView.isHidden = isLogic ? false : true
        self.logicView.snp.remakeConstraints { (maker ) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.addressView.snp.bottom).offset(isLogic ? 10 : 0)
            if isLogic {
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.height.equalTo(0)
            }
        }
        self.addressView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.refundView.snp.bottom).offset(isRefund ? 0 : 10)
            if isRefund {
                maker.height.equalTo(0)
            }else{
                maker.height.greaterThanOrEqualTo(0)
            }
        }
        self.refundTop.update(offset: isRefund ? 10 : 0)
        self.commissionView.detaileModel = self.detaileModel
        if sp_getString(string: self.detaileModel?.commission).count > 0  || sp_getString(string: self.detaileModel?.shop_payment).count > 0  {
            self.commissionTop.update(offset: 10)
        }else{
            self.commissionTop.update(offset: 0)
        }
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.codeView)
        self.addSubview(self.payView)
        self.addSubview(self.refundView)
        self.addSubview(self.addressView)
        self.addSubview(self.logicView)
        self.addSubview(self.priceView)
        self.addSubview(self.commissionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.payView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.payTop = maker.top.equalTo(self.codeView.snp.bottom).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.refundView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.refundTop = maker.top.equalTo(self.payView.snp.bottom).offset(0).constraint
        }
        self.addressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.refundView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.logicView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.addressView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.logicView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            
        }
        self.commissionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.commissionTop = maker.top.equalTo(self.priceView.snp.bottom).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
//            maker.height.equalTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
