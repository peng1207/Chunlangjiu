//
//  SPSortMultistageTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPSortMultistageCollectCell: UICollectionViewCell {
    fileprivate lazy var sortImageView : UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.yellow
        return imageView
    }()
    fileprivate lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.textAlignment = NSTextAlignment.center
        
        return label
    }()
    var lv3Model : SPSortLv3Model? {
        didSet{
            sp_setupData()
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
        self.titleLabel.text = sp_getString(string: lv3Model?.cat_name)
        self.sortImageView .sp_cache(string: lv3Model?.cat_logo, plImage: sp_getDefaultImg())
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.sortImageView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.sortImageView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.sortImageView.snp.width).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(20)
            maker.top.equalTo(self.sortImageView.snp.bottom).offset(8)
        }
    }
    
    deinit {
        
    }
}

import UIKit
import SnapKit
class SPSortMultistageCollectHeadView: UICollectionReusableView {
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = sp_getFontSize(size: 18)
        return label
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
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        self.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(11)
            maker.right.equalTo(self.snp.right).offset(-11)
            maker.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
