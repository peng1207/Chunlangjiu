//
//  SPProductListView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SP_PRODUCT_H_WIDTH :  CGFloat = 140
typealias SPAddProductComplete = (_ model : SPProductModel?)->Void
class SPProductContentView:  UIView{
    lazy var productImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    lazy var salePriceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_c11f2f.rawValue)
        return label
    }()
    lazy var originPriceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()

    lazy var shopCartBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_shopcart"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickShopCartAction), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    lazy var tipsLabel :UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 12)
        return label
    }()
    lazy var maxPriceLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)
        label.font = sp_getFontSize(size: 12)
        label.isHidden = true
        return label
    }()
    lazy var labelView : SPLabelView = {
        let view = SPLabelView()
        return view
    }()
    lazy var auctionImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_auction")
        imageView.isHidden = true
        return imageView
    }()
    lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.isHidden = true
        return view
    }()
    var productModel : SPProductModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var addComplete : SPAddProductComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.sp_setupUI()
      
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.productImageView.sp_cache(string: productModel?.image_default_id, plImage: sp_getDefaultImg())
        
        self.titleLabel.attributedText = productModel?.sp_getTitleAtt()
        
        self.salePriceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: productModel?.price))"
        self.tipsLabel.text = "\(sp_getString(string: self.productModel?.view_count))人关注 \(sp_getString(string: self.productModel?.rate_count))条评价"
        self.originPriceLabel.attributedText = self.productModel?.sp_getdefaultPrice()
        self.maxPriceLabel.attributedText = self.productModel?.sp_getMaxPrice()
        if let isAuction = self.productModel?.isAuction, isAuction == true {
            self.maxPriceLabel.isHidden = false
            self.salePriceLabel.isHidden = true
            self.auctionImageView.isHidden = false
        }else{
            self.maxPriceLabel.isHidden = true
            self.salePriceLabel.isHidden = false
            self.auctionImageView.isHidden = true
        }
        self.labelView.listArray = self.productModel?.sp_getLabel()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.productImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.labelView)
        self.addSubview(self.salePriceLabel)
        self.addSubview(self.originPriceLabel)
        self.addSubview(self.shopCartBtn)
        self.addSubview(self.tipsLabel)
        self.addSubview(self.maxPriceLabel)
        self.addSubview(self.auctionImageView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.auctionImageView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.productImageView).offset(0)
            maker.width.equalTo(35)
            maker.height.equalTo(37)
        }
      
        self.shopCartBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(22)
            maker.height.equalTo(21)
            maker.right.equalTo(self).offset(-15)
            maker.bottom.equalTo(self).offset(-14)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.shopCartBtn.snp.left).offset(-8)
            maker.bottom.equalTo(self.snp.bottom).offset(-13)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
//            maker.top.equalTo(self.titleLabel.snp.bottom).offset(6)
            maker.bottom.equalTo(self.tipsLabel.snp.top).offset(-6)
            maker.height.equalTo(16)
        }
       
        self.originPriceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.originPriceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.salePriceLabel.snp.left).offset(0)
//            maker.top.equalTo(self.labelView.snp.bottom).offset(6)
            maker.bottom.equalTo(self.salePriceLabel.snp.top).offset(-5);
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.titleLabel.snp.right).offset(0)
        }
        
        self.salePriceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.salePriceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
//            maker.top.equalTo(self.originPriceLabel.snp.bottom).offset(5)
            maker.bottom.equalTo(self.labelView.snp.top).offset(-5);
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.bottom.equalTo(self.snp.bottom).offset(-sp_lineHeight)
            maker.height.equalTo(sp_lineHeight)
        }
        
        self.maxPriceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.salePriceLabel.snp.top).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPProductContentView {
    
    @objc fileprivate func sp_clickShopCartAction(){
        guard let block = self.addComplete else {
            return
        }
        block(self.productModel)
    }
}
import UIKit
import SnapKit
class SPProductListHCell: UICollectionViewCell {
    lazy var productView : SPProductContentView = {
        return SPProductContentView()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        self.contentView.addSubview(self.productView)
        
        self.productView.lineView.isHidden = false
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.productView.productImageView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.snp.left).offset(0)
            maker.top.equalTo(self.productView.snp.top).offset(15)
            maker.width.equalTo(SP_PRODUCT_H_WIDTH)
        maker.height.equalTo(self.productView.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.productView.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.productImageView.snp.right).offset(3)
            maker.top.equalTo(self.productView.productImageView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.productView.snp.right).offset(-10)
        }
        self.productView.shopCartBtn.snp.remakeConstraints { (maker) in
            maker.right.equalTo(self.productView.snp.right).offset(0)
            maker.width.height.equalTo(21)
            maker.bottom.equalTo(self.productView.snp.bottom).offset(-11)
        }
        self.productView.tipsLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.productView.shopCartBtn.snp.right).offset(-4)
            maker.bottom.equalTo(self.productView.snp.bottom).offset(-11)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.productView.labelView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.productView.titleLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.productView.tipsLabel.snp.top).offset(-6)
            maker.height.equalTo(15)
        }
        
    }
    deinit {
        
    }
}
import UIKit
import SnapKit
class SPProductListVCell: UICollectionViewCell {
    lazy var productView : SPProductContentView = {
        return SPProductContentView()
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        self.contentView.addSubview(self.productView)
       
        self.productView.lineView.isHidden = true
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.productView.productImageView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.snp.left).offset(19)
            maker.right.equalTo(self.productView.snp.right).offset(-19)
            maker.top.equalTo(self.productView.snp.top).offset(5)
            maker.height.equalTo(self.productView.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.productView.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.snp.left).offset(10)
            maker.top.equalTo(self.productView.productImageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.productView.snp.right).offset(-10)
        }
        
    }
    deinit {
        
    }
}
