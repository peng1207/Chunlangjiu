//
//  SPIndexIconCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexIconCollectCell: UICollectionViewCell {
    
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    var iconModel : SPIndexIconModel?{
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
        self.iconImageView.sp_cache(string: sp_getString(string: self.iconModel?.imagesrc), plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string:self.iconModel?.tag)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImageView.snp.makeConstraints { (maker) in
           maker.width.height.equalTo(40)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
            maker.top.equalTo(self.contentView.snp.top).offset(4)
           
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.iconImageView.snp.bottom).offset(2)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
