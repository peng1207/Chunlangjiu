//
//  SPShopProductCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopProductCollectCell: UICollectionViewCell {
    
    lazy var productView : SPProductContentView = {
        let view = SPProductContentView()
        view.signImgView.isHidden = true
        view.shopNameLabel.isHidden = true
        view.entShopBtn.isHidden = true
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
        self.contentView.addSubview(self.productView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
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
        self.productView.tipsLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.productView.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.productView.titleLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.productView.snp.bottom).offset(-6)
        }
    }
    deinit {
        
    }
}
