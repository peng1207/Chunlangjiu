//
//  SPOrderRefundView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/31.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderRefundView:  UIView{
    
    fileprivate lazy var applyView : SPOrderContentView = {
        return sp_createView(title: "申请时间：")
    }()
    fileprivate lazy var returnGoodsView : SPOrderContentView = {
       return sp_createView(title: "退货时间：")
    }()
    fileprivate lazy var refundView : SPOrderContentView = {
        return sp_createView(title: "退款时间：")
    }()
    private func sp_createView(title:String)-> SPOrderContentView{
        let view = SPOrderContentView()
        view.titleLabel.text = title
        view.isHidden = true
        return view
    }
    fileprivate var applyTop  : Constraint!
    fileprivate var returnTop : Constraint!
    fileprivate var refunfTop : Constraint!
    fileprivate var bottomConstraint : Constraint!
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.applyView)
        self.addSubview(self.returnGoodsView)
        self.addSubview(self.refundView)
        self.sp_addConstraint()
    }
    /// 赋值
    fileprivate func sp_setupData(){
        var isShow = false
        if let isAS = self.detaileModel?.sp_isAfterSales(), isAS == true {
            self.applyView.contentLabel.text = sp_getString(string: self.detaileModel?.created_time)
            if sp_getString(string: self.detaileModel?.created_time).count > 0  {
                isShow = true
                self.applyView.isHidden = false
            }else{
                self.applyView.isHidden = true
            }
        }
        
        
        self.applyTop.update(offset: isShow ? 14 : 0)
        self.bottomConstraint.update(offset: isShow ? -16 : 0)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.applyView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.applyTop = maker.top.equalTo(self).offset(0).constraint
        }
        self.returnGoodsView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.refunfTop = maker.top.equalTo(self.applyView.snp.bottom).offset(0).constraint
        }
        self.refundView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.refunfTop = maker.top.equalTo(self.returnGoodsView.snp.bottom).offset(0).constraint
            self.bottomConstraint = maker.bottom.equalTo(self.snp.bottom).offset(0).constraint
        }
    }
    deinit {
        
    }
}
