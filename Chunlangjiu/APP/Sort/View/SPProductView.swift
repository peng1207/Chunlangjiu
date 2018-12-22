//
//  SPProductView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductView:  UIView{
    
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return label
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.numberOfLines = 0
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var specLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    lazy var labelView : SPLabelView = {
        return SPLabelView()
    }()
    lazy var countDownView : SPCountdownView = {
        let view = SPCountdownView()
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        view.isHidden = true
        return view
    }()
    lazy var lookDetaile : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("查看竞拍出价", for: UIControlState.normal)
        btn.setTitle("保密出价", for: UIControlState.disabled)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 8)
        btn.isHidden = true
        return btn
    }()
    
    lazy var typeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.text = "竞拍方式:"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    
    var productModel : SPProductModel?{
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var timeTop : Constraint!
    fileprivate var timeHeight : Constraint!
    fileprivate var lookDetTop : Constraint!
    fileprivate var typeTop : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.priceLabel)
        self.addSubview(self.nameLabel)
        self.addSubview(self.specLabel)
        self.addSubview(self.labelView)
        self.addSubview(self.countDownView)
        self.addSubview(self.lookDetaile)
        self.addSubview(self.typeLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.priceLabel.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.specLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(16)
            maker.top.equalTo(self.specLabel.snp.bottom).offset(5)
//            maker.bottom.equalTo(self.snp.bottom).offset(-8)
        }
        self.countDownView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            self.timeTop =  maker.top.equalTo(self.labelView.snp.bottom).offset(5).constraint
            maker.width.greaterThanOrEqualTo(0)
            self.timeHeight = maker.height.equalTo(12).constraint
 
        }
        self.lookDetaile.snp.makeConstraints { (maker) in
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-10)
           self.lookDetTop = maker.top.equalTo(self.countDownView.snp.bottom).offset(8).constraint
            maker.height.equalTo(15)
            maker.width.greaterThanOrEqualTo(60)
            maker.left.equalTo(self.typeLabel.snp.right).offset(10)
        }
        self.typeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
           self.typeTop = maker.top.equalTo(self.countDownView.snp.bottom).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-8)
        }
    }
    deinit {
        sp_log(message: "销毁对象 ")
    }
}
extension SPProductView {
    /// 赋值
    fileprivate func sp_setupData(){
          let priceAtt = NSMutableAttributedString()
        priceAtt.append(NSAttributedString(string: "\(SP_CHINE_MONEY)", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14)]))
        if let isAuction = self.productModel?.isAuction, isAuction == true {
          priceAtt.append(NSAttributedString(string: sp_getString(string: self.productModel?.auction_starting_price), attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 18)]))
        }else{
             priceAtt.append(NSAttributedString(string: sp_getString(string: self.productModel?.price), attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 18)]))
        }
        self.priceLabel.attributedText = priceAtt
      
        self.nameLabel.attributedText = productModel?.sp_getTitleAtt()
        self.specLabel.text = sp_getString(string: productModel?.sub_title)
        self.labelView.listArray = self.productModel?.sp_getLabel()
        if let model = self.productModel,model.isAuction{
            self.countDownView.isHidden = false
            self.lookDetaile.isHidden = false
            self.typeLabel.isHidden = false
            var isMing = false
             let auction_status : Bool? = Bool(sp_getString(string: self.productModel?.auction_status))
            if let status = auction_status , status == true {
                isMing = true
            }
            let dAtt = NSMutableAttributedString()
            let titleAtt = NSAttributedString(string: "竞拍方式:", attributes: [NSAttributedStringKey.font:sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
            dAtt.append(titleAtt)
            let detaileAtt = NSAttributedString(string: isMing ? "明拍" : "暗拍", attributes: [NSAttributedStringKey.font:sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)])
            dAtt.append(detaileAtt)
            self.typeLabel.attributedText = dAtt
            self.lookDetaile.isEnabled = isMing ? true : false
            if isMing {
                if sp_getString(string: self.productModel?.max_price).count > 0 {
                      self.lookDetaile .setTitle("  查看竞拍出价(\(sp_getString(string: self.productModel?.max_price)))  ", for: UIControlState.normal)
                }else{
                      self.lookDetaile .setTitle("查看竞拍出价", for: UIControlState.normal)
                }
            }
            if let second = self.productModel?.second {
                let date : (day:String,hour : String,minue : String,second : String) = sp_change(second: second)
                self.countDownView.dayLabel.text = sp_getString(string: date.day)
                self.countDownView.hourLabel.text = sp_getString(string: date.hour)
                self.countDownView.minueLabel.text = sp_getString(string: date.minue)
                self.countDownView.secondLabel.text = sp_getString(string: date.second)
            }
            self.timeTop.update(offset: 5)
            self.timeHeight.update(offset: 12)
            self.lookDetTop.update(offset: 8)
            self.typeTop.update(offset: 10)
        }else{
            self.countDownView.isHidden = true
            self.lookDetaile.isHidden = true
            self.typeLabel.isHidden = true
            self.timeHeight.update(offset: 0)
            self.timeTop.update(offset: 0)
            self.lookDetTop.update(offset: 0)
            self.typeTop.update(offset: 0)
        }
        
    }
}
