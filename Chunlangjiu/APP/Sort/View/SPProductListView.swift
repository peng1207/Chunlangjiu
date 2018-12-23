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
    lazy var signImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    lazy var shopNameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
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
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
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
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 10)
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
    lazy var entShopBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("进店 >", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 11)
//        btn.addTarget(self, action: #selector(<#des#>), for: UIControlEvents.touchUpInside)
        return btn
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
        let haoP = "98%"
        self.salePriceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: productModel?.price))"
        self.tipsLabel.text = "\(sp_getString(string: self.productModel?.view_count))人关注 \(sp_getString(string: self.productModel?.rate_count))条评价 \(haoP)好评"
       
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
        self.addSubview(self.signImgView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.labelView)
        self.addSubview(self.salePriceLabel)
        
        self.addSubview(self.shopCartBtn)
        self.addSubview(self.tipsLabel)
        self.addSubview(self.maxPriceLabel)
        self.addSubview(self.shopNameLabel)
        self.addSubview(self.entShopBtn)
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
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(5)
            maker.top.equalTo(self).offset(10)
            maker.width.equalTo(130)
            maker.height.equalTo(self.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.right).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.productImageView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.shopCartBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(22)
            maker.height.equalTo(21)
            maker.right.equalTo(self).offset(-15)
            maker.bottom.equalTo(self).offset(-14)
        }
        self.signImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-6)
            maker.width.equalTo(60)
            maker.height.equalTo(15)
        }
        self.shopNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.signImgView.snp.right).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.signImgView.snp.centerY).offset(0)
            maker.right.equalTo(self.entShopBtn.snp.left).offset(-5)
        }
        self.entShopBtn.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.entShopBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-16)
            maker.centerY.equalTo(self.signImgView.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.shopCartBtn.snp.left).offset(-8)
            maker.bottom.equalTo(self.signImgView.snp.top).offset(-5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.salePriceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.salePriceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
//            maker.top.equalTo(self.originPriceLabel.snp.bottom).offset(5)
            maker.bottom.equalTo(self.tipsLabel.snp.top).offset(-10);
            maker.height.greaterThanOrEqualTo(0)
        }
        
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            maker.height.equalTo(15)
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
        let view = SPProductContentView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
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
        self.productView.layoutIfNeeded()
        self.productView.sp_setCornerRadius(corner: 5)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.height.equalTo(150)
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
       
        
    }
    deinit {
        
    }
}
import UIKit
import SnapKit
class SPProductListVCell: UICollectionViewCell {
    lazy var productView : SPProductContentView = {
        let view = SPProductContentView()
        view.titleLabel.numberOfLines = 1
        return view
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
        self.contentView.sp_setCornerRadius(corner: 5)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
        self.productView.productImageView.snp.remakeConstraints { (maker) in
            maker.left.right.top.equalTo(self.productView).offset(0)
            maker.height.equalTo(self.productView.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.productView.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.snp.left).offset(3)
            maker.top.equalTo(self.productView.productImageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.productView.snp.right).offset(-6)
        }
        self.productView.salePriceLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            //            maker.top.equalTo(self.originPriceLabel.snp.bottom).offset(5)
            maker.bottom.equalTo(self.productView.tipsLabel.snp.top).offset(-2);
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
