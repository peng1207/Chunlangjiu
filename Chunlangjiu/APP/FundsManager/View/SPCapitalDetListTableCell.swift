//
//  SPCapitalDetListTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCapitalDetListTableCell: UITableViewCell {
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    var model : SPCapitalDetModel? {
        didSet{
           self.sp_setupData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: self.model?.message)
        self.priceLabel.text = sp_getString(string: self.model?.fee)
        self.timeLabel.text = sp_getString(string: self.model?.time)
        if sp_getString(string: self.model?.type) != "add" {
            self.priceLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        }else{
            self.priceLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.timeLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView.snp.right).offset(-21)
            maker.top.equalTo(self.contentView).offset(16)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(18)
            maker.centerY.equalTo(self.priceLabel.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
//            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.priceLabel.snp.left).offset(-10);
        }
       
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.right.equalTo(self.priceLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
