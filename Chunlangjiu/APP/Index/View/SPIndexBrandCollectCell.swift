//
//  SPIndexBrandCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexBrandCollectCell: UICollectionViewCell {
    
    fileprivate lazy var brandImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
    
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 12)
    
        return label
    }()
    var brandModel : SPBrandModel?{
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
    fileprivate func sp_setupData(){
        self.brandImageView.sp_cache(string: sp_getString(string: self.brandModel?.image), plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string: self.brandModel?.brandname)
        self.contentLabel.text = sp_getString(string: self.brandModel?.linkinfo)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.brandImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.brandImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.brandImageView.snp.width).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.brandImageView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(1)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
