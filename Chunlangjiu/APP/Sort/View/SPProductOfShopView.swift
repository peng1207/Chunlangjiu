//
//  SPProductOfShopView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductOfShopView:  UIView{
    
    lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.sp_cornerRadius(cornerRadius: 20)
        return imageView
    }()
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        view.image = sp_getDefaultUserImg()
        return view
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    lazy var filletView : SPFilletView = {
        let view = SPFilletView()
        view.textLabel.text = "进店 >"
        view.textLabel.font = sp_getFontSize(size: 11)
        view.textLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return view
    }()
    var shopModel : SPShopModel?{
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
        self.iconImageView.sp_cache(string: self.shopModel?.shop_logo, plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: self.shopModel?.shop_name)
        self.contentLabel.text = "店铺简介:\(sp_getString(string: self.shopModel?.shop_descript))"
        if sp_getString(string: self.shopModel?.grade) == SP_GRADE_2 {
            self.typeImgView.image = sp_getPartnerImg()
        }else if sp_getString(string: self.shopModel?.grade) == SP_GRADE_1 {
            self.typeImgView.image = sp_getStartUserImg()
        }else{
            self.typeImgView.image = sp_getDefaultUserImg()
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.iconImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.typeImgView)
        self.addSubview(self.contentLabel)
        self.addSubview(self.filletView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(10)
            maker.width.equalTo(40)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView.snp.right).offset(8)
            maker.top.equalTo(self.iconImageView.snp.top).offset(0)
            maker.right.lessThanOrEqualTo(self.filletView.snp.left).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.typeImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(5)
            maker.width.equalTo(60)
            maker.height.equalTo(15)
            maker.centerY.equalTo(self.nameLabel.snp.centerY).offset(0)
            maker.right.lessThanOrEqualTo(self.filletView.snp.left).offset(-5)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.filletView.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.filletView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.height.equalTo(20)
            maker.width.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
