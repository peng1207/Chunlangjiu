//
//  SPAuctionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAuctionView:  UIView{
    lazy var countDownView : SPCountdownView = {
        return SPCountdownView()
    }()
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    lazy var startLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    lazy var maxLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    lazy var labelView : SPLabelView = {
        return SPLabelView()
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    lazy var productImageView : UIImageView = {
        return UIImageView()
    }()
    var productModel : SPProductModel?{
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
        self.productImageView.sp_cache(string: sp_getString(string: self.productModel?.image_default_id), plImage: sp_getDefaultImg())
        if let second = self.productModel?.second {
            let date : (day : String,hour : String,minue : String,second : String) = sp_change(second: second)
            self.countDownView.dayLabel.text = sp_getString(string: date.day)
            self.countDownView.hourLabel.text = sp_getString(string: date.hour)
            self.countDownView.minueLabel.text = sp_getString(string: date.minue)
            self.countDownView.secondLabel.text = sp_getString(string: date.second)
        }
        let numAtt = NSMutableAttributedString()
        let numTitleAtt = NSAttributedString(string: "出价人数", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
        numAtt.append(numTitleAtt)
        let numNumAtt =  NSAttributedString(string: sp_getString(string: self.productModel?.auction_number), attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)])
        numAtt.append(numNumAtt)
        
        self.numLabel.attributedText = numAtt
        self.titleLabel.attributedText = productModel?.sp_getTitleAtt()
        
//        let startAtt = NSMutableAttributedString()
//        let startTitleAtt = NSAttributedString(string: "起拍价:", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
//
//        startAtt.append(startTitleAtt)
//        let startPriceAtt = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string:self.productModel?.auction_starting_price))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.strikethroughColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue),NSAttributedStringKey.strikethroughStyle :  NSUnderlineStyle.styleSingle.rawValue])
//        startAtt.append(startPriceAtt)
        self.startLabel.attributedText = self.productModel?.sp_getdefaultPrice()
        self.maxLabel.attributedText = self.productModel?.sp_getMaxPrice()
        self.labelView.listArray = self.productModel?.sp_getLabel()
    
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.productImageView)
        self.addSubview(self.countDownView)
        self.addSubview(self.numLabel)
        self.addSubview(self.titleLabel)
        self.addSubview(self.startLabel)
        self.addSubview(self.maxLabel)
        self.addSubview(self.labelView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.countDownView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.right).offset(5)
            maker.top.equalTo(self.snp.top).offset(18)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.equalTo(18)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.startLabel.snp.right).offset(8)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.height.equalTo(self.countDownView.snp.height).offset(0)
            maker.top.equalTo(self.startLabel.snp.top).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.countDownView.snp.left).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.countDownView.snp.bottom).offset(7)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.startLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.maxLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.maxLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.maxLabel.snp.top).offset(-5)
        }
        self.maxLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.labelView.snp.top).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
       
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
            maker.height.equalTo(16)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
