//
//  SPConfrimTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SPConfrimTableCell_Product_Width : CGFloat = 70

class SPConfrimTableCell: UITableViewCell {
    fileprivate lazy var productImageView : UIImageView = {
       return UIImageView()
    }()
    fileprivate lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
       let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var sepecLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var productModel : SPProductModel?{
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
    fileprivate func sp_setupData(){
        self.productImageView.sp_cache(string: self.productModel?.image_default_id, plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string: self.productModel?.title)
      
        self.sepecLabel.text = sp_getString(string: self.productModel?.unit)
        if let isAuction = productModel?.isAuction ,isAuction == true {
            self.numLabel.text = "x1"
            self.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.productModel?.auction_starting_price))"
        }else{
             self.numLabel.text = "x\(sp_getString(string: self.productModel?.quantity))"
             self.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.productModel?.showCartPrice))"
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.sepecLabel)
        self.contentView.addSubview(self.numLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.top.equalTo(self.contentView).offset(0)
            maker.width.equalTo(SPConfrimTableCell_Product_Width)
            maker.height.equalTo(self.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.right).offset(5)
            maker.top.equalTo(self.contentView).offset(12)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.contentView).offset(-10)
        }
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.sepecLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.priceLabel.snp.right).offset(4)
            maker.centerY.equalTo(self.priceLabel.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.numLabel.snp.left).offset(-8)
        }
        self.numLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.numLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(-11)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.left).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.right.equalTo(self.numLabel.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
