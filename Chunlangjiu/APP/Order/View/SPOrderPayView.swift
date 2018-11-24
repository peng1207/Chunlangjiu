//
//  SPOrderPayView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderPayView:  UIView{
    fileprivate lazy var payView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "支付方式："
        return view
    }()
    fileprivate lazy var payTimeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "支付时间："
        return view
    }()
    fileprivate lazy var depositView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "支付定金："
        view.isHidden = true
        return view
    }()
    fileprivate lazy var surplusView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "支付余款："
        view.isHidden = true
        return view
    }()
    fileprivate lazy var deliverTimeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "发货时间："
        return view
    }()
    fileprivate lazy var finishTimeView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.titleLabel.text = "完成时间："
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var payTopConstraint : Constraint!
    fileprivate var timeTopConstraint : Constraint!
    fileprivate var depositTop : Constraint!
    fileprivate var surplusTop : Constraint!
    fileprivate var deliverTopConstraint : Constraint!
    fileprivate var finishTopConstraint : Constraint!
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
    /// 赋值
    fileprivate func sp_setupData(){
        var isShow = false
        if let isAS = self.detaileModel?.sp_isAfterSales(),isAS == true{
            self.payTopConstraint.update(offset: 0)
            self.payTimeView.isHidden = true
            self.timeTopConstraint.update(offset: 0)
            self.payTimeView.isHidden = true
            self.deliverTopConstraint.update(offset: 0)
            self.deliverTimeView.contentLabel.text = ""
            self.deliverTimeView.isHidden = true
            self.finishTimeView.contentLabel.text = ""
            self.finishTopConstraint.update(offset: 0)
            self.finishTimeView.isHidden = true
        }else{
            self.payView.contentLabel.text = sp_getString(string: detaileModel?.pay_name)
            self.payTimeView.contentLabel.text = sp_getString(string: detaileModel?.pay_time)
            
            if sp_getString(string: self.detaileModel?.type) == SP_AUCTION {
                self.payTimeView.titleLabel.text = "支付定金："
            }else{
                self.payTimeView.titleLabel.text = "支付时间："
            }
            
            
            
            if sp_getString(string: detaileModel?.pay_name).count > 0 {
                self.payTopConstraint.update(offset: 15)
                self.payView.isHidden = false
            }else{
                self.payTopConstraint.update(offset: 0)
                self.payView.isHidden = true
                self.payView.contentLabel.text = ""
            }
            if sp_getString(string: detaileModel?.pay_time).count > 0 {
                self.timeTopConstraint.update(offset: 8)
                self.payTimeView.isHidden = false
            }else{
                self.timeTopConstraint.update(offset: 0)
                self.payTimeView.isHidden = true
                self.payTimeView.contentLabel.text = ""
            }
            if sp_getString(string: self.detaileModel?.consign_time).count > 0 {
                self.deliverTimeView.isHidden = false
                self.deliverTopConstraint.update(offset: 8)
                self.deliverTimeView.contentLabel.text = sp_getString(string: detaileModel?.consign_time)
            }else{
                self.deliverTopConstraint.update(offset: 0)
                self.deliverTimeView.contentLabel.text = ""
                self.deliverTimeView.isHidden = true
            }
            
            if sp_getString(string: self.detaileModel?.end_time).count > 0 {
                self.finishTimeView.contentLabel.text = sp_getString(string: detaileModel?.end_time)
                self.finishTopConstraint.update(offset: 8)
                self.finishTimeView.isHidden = false
            }else{
                self.finishTimeView.contentLabel.text = ""
                self.finishTopConstraint.update(offset: 0)
                self.finishTimeView.isHidden = true
            }
            
            if !self.payView.isHidden || !self.payTimeView.isHidden || !self.deliverTimeView.isHidden || !self.finishTimeView.isHidden {
                isShow = true
            }
        }
        
       
        self.lineView.isHidden = !isShow
        self.bottomConstraint.update(offset: (  isShow ? -16 : 0))
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.lineView)
        self.addSubview(self.payView)
        self.addSubview(self.payTimeView)
        self.addSubview(self.depositView)
        self.addSubview(self.surplusView)
        self.addSubview(self.deliverTimeView)
        self.addSubview(self.finishTimeView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.payView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.payTopConstraint = maker.top.equalTo(self).offset(16).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.payTimeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.timeTopConstraint = maker.top.equalTo(self.payView.snp.bottom).offset(8).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.depositView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.depositTop = maker.top.equalTo(self.payTimeView.snp.bottom).offset(0).constraint
        }
        self.surplusView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.surplusTop = maker.top.equalTo(self.depositView.snp.bottom).offset(0).constraint
        }
        self.deliverTimeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.deliverTopConstraint = maker.top.equalTo(self.surplusView.snp.bottom).offset(8).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.finishTimeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.finishTopConstraint = maker.top.equalTo(self.deliverTimeView.snp.bottom).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
           self.bottomConstraint = maker.bottom.equalTo(self.snp.bottom).offset(0).constraint
        }
    }
    deinit {
        
    }
}
