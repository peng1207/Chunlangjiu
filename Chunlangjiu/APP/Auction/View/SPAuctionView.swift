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
        let view = SPCountdownView()
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    lazy var productView : SPProductContentView = {
        let view = SPProductContentView()
        return view
    }()
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = NSTextAlignment.right
        return label
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
        
        self.productView.productModel = self.productModel
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
      
        self.addSubview(self.countDownView)
        self.addSubview(self.numLabel)
        self.addSubview(self.productView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.countDownView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(12)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.equalTo(12)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-11)
            maker.top.equalTo(self).offset(11)
            maker.height.equalTo(15)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.productView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.equalTo(self.countDownView.snp.bottom).offset(2)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.right.equalTo(self).offset(0)
        }
      
    }
    deinit {
        
    }
}
