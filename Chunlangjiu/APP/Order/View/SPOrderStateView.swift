//
//  SPOrderStateView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import UIKit
import SnapKit
class SPOrderStateView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    fileprivate lazy var stateTitle : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "订单状态："
        return label
    }()
    fileprivate lazy var stateLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.preferredMaxLayoutWidth =  sp_getScreenWidth()
        return label
    }()
    fileprivate  lazy var countDownView : SPCountdownView = {
        let view = SPCountdownView()
        view.titleLabel.text = "剩余支付时间"
        return view
    }()
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var topConstraint: Constraint!
    fileprivate var bottomConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        
        self.stateLabel.text = sp_getString(string: detaileModel?.status_desc)
        if sp_isShow(reason: detaileModel?.status) {
            self.stateLabel.text = "\(sp_getString(string: self.stateLabel.text))"
        }
        if sp_getString(string: self.stateLabel.text).count > 0 {
            self.stateTitle.isHidden = false
//            self.topConstraint.update(offset: 10)
//            self.bottomConstraint.update(offset: -10)
        }else{
            self.stateTitle.isHidden = true
//            self.topConstraint.update(offset: 0)
//            self.bottomConstraint.update(offset:0)
        }
        if sp_getString(string: detaileModel?.status) == SP_WAIT_BUYER_PAY ||  (sp_getString(string: detaileModel?.status) == SP_AUCTION_0 && sp_getString(string: detaileModel?.type) == SP_AUCTION ) || (sp_getString(string: detaileModel?.status) == SP_AUCTION_1 && sp_getString(string: detaileModel?.type) == SP_AUCTION) {
            
            if sp_getString(string: detaileModel?.type) == SP_AUCTION{
                self.countDownView.titleLabel.text = "剩余竞拍时间"
            }else{
                self.countDownView.titleLabel.text = "剩余支付时间"
            }
            
            if let second = self.detaileModel?.second {
                if second <= 0 {
                    self.countDownView.isHidden = true
                }else{
                    let date : (day:String,hour : String,minue : String,second : String) = sp_change(second: second)
                    self.countDownView.dayLabel.text = sp_getString(string: date.day)
                    self.countDownView.hourLabel.text = sp_getString(string: date.hour)
                    self.countDownView.minueLabel.text = sp_getString(string: date.minue)
                    self.countDownView.secondLabel.text = sp_getString(string: date.second)
                    self.countDownView.isHidden = false
                }
            }else{
                  self.countDownView.isHidden = true
            }
            
           
        }else{
            self.countDownView.isHidden = true
        }
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.stateTitle)
        self.contentView.addSubview(self.stateLabel)
        self.contentView.addSubview(self.countDownView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self).offset(0)
        }
        self.stateTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.stateTitle.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.top.equalTo(self.contentView).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.stateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.stateTitle.snp.right).offset(0)
            self.topConstraint = maker.top.equalTo(self.snp.top).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.countDownView.snp.right).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            self.bottomConstraint = maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10).constraint
        }
        self.countDownView.snp.makeConstraints { (maker) in
            maker.height.equalTo(18)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView).offset(-8)
            maker.width.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
