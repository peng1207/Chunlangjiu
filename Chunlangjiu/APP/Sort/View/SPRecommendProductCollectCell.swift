//
//  SPRecommendProductCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPRecommendProductCollectCell: UICollectionViewCell {
    
    lazy var productImageView : UIImageView = {
        return UIImageView()
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_c11f2f.rawValue)
        return label
    }()
    lazy var auctionImageView : UIImageView = {
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
        self.productImageView.sp_cache(string: self.productModel?.image_default_id, plImage: sp_getDefaultImg())
        self.nameLabel.text = sp_getString(string: self.productModel?.title)
        if let auction = self.productModel?.isAuction , auction == true {
            self.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.productModel?.auction_starting_price))"
        }else{
            self.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.productModel?.price))"
        }
        
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.priceLabel)
        self.productImageView.addSubview(self.auctionImageView)
        self.sp_addConstraint()
        self.contentView.sp_setCornerRadius(corner: 5)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.productImageView.snp.width).offset(SP_PRODUCT_SCALE)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.productImageView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(-14)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.auctionImageView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.productImageView).offset(0)
            maker.width.height.equalTo(30)
        }
    }
    deinit {
        
    }
}
