//
//  SPIndexDTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SPIndexDTableCell_Product_Width :  CGFloat =  140

class SPIndexDTableCell: UITableViewCell {
    lazy var productView : SPProductContentView = {
        return SPProductContentView()
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
        
    }
    var productModel : SPProductModel? {
        didSet{
            self.sp_setupData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.productView.productImageView.sp_cache(string: sp_getString(string: self.productModel?.imgsrc), plImage: sp_getDefaultImg())
        self.productView.titleLabel.attributedText = productModel?.sp_getTitleAtt()
        self.productView.salePriceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.productModel?.price))"
        self.productView.labelView.listArray = self.productModel?.sp_getLabel()
        self.productView.originPriceLabel.attributedText = self.productModel?.sp_getdefaultPrice()
        self.productView.tipsLabel.text = "\(sp_getString(string: self.productModel?.view_count))人关注 \(sp_getString(string: self.productModel?.rate_count))条评价"
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.productView)
        self.productView.titleLabel.numberOfLines = 2
        self.productView.shopCartBtn.isHidden = true
        
        self.productView.lineView.isHidden = false
        self.productView.salePriceLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(self.contentView).offset(0)
        }
        self.productView.productImageView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView).offset(10)
            maker.top.equalTo(self.productView.snp.top).offset(15)
            maker.width.equalTo(SPIndexDTableCell_Product_Width)
            maker.height.equalTo(self.productView.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.productView.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.productImageView.snp.right).offset(6)
            maker.top.equalTo(self.productView.snp.top).offset(15)
            maker.right.equalTo(self.productView.snp.right).offset(-29)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.productView.originPriceLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
//            maker.top.equalTo(self.productView.titleLabel.snp.bottom).offset(12)
            maker.bottom.equalTo(self.productView.salePriceLabel.snp.top).offset(-9)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.productView.titleLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.productView.salePriceLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
//            maker.top.equalTo(self.productView.originPriceLabel.snp.bottom).offset(9)
            maker.bottom.equalTo(self.productView.labelView.snp.top).offset(-10)
            maker.right.equalTo(self.productView.titleLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.productView.labelView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
//            maker.top.equalTo(self.productView.salePriceLabel.snp.bottom).offset(17)
            maker.bottom.equalTo(self.productView.tipsLabel.snp.top).offset(-10)
            maker.height.equalTo(16)
            maker.right.equalTo(self.productView.titleLabel.snp.right).offset(0)
        }
        self.productView.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
//            maker.bottom.equalTo(self.productView.productImageView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.productView.signImgView.snp.top).offset(-7)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.productView.titleLabel.snp.right).offset(0)
        }
     
    }
    deinit {
        
    }
}
