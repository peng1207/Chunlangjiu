//
//  SPConfrimSectionHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfrimSectionHeadView:  UITableViewHeaderFooterView{
    fileprivate lazy var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.sp_cornerRadius(cornerRadius: 15)
        return imageView
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var shopModel : SPShopModel? {
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.logoImageView.sp_cache(string: self.shopModel?.shop_logo, plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: self.shopModel?.shop_name)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.logoImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            maker.width.height.equalTo(30)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImageView.snp.right).offset(14)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-12)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
