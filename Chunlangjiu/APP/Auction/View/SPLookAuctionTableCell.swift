//
//  SPLookAuctionTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/25.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPLookAuctionTableCell: UITableViewCell {
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "领先"
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPAuctionPrice?{
        didSet{
            sp_setupData()
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
        self.phoneLabel.text = sp_getString(string: self.model?.mobile)
        self.priceLabel.text = sp_getString(string: self.model?.price)
        self.timeLabel.text = sp_getString(string: self.model?.showTime)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.phoneLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.statusLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.phoneLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(19)
            maker.top.equalTo(self.contentView).offset(18)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.statusLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.statusLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.right).offset(10)
            maker.top.equalTo(self.phoneLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.priceLabel.snp.left).offset(-10)
        }
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-25)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.left).offset(0)
            maker.top.equalTo(self.phoneLabel.snp.bottom).offset(10)
            maker.right.lessThanOrEqualTo(self.priceLabel.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
