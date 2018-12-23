//
//  SPShopHomeView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class  SPShopHomeView:  UIView{
    
    fileprivate lazy var shopIconImageView : UIImageView = {
        let imageView =  UIImageView()
        return imageView
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var authLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.text = " 个人认证 "
        label.sp_cornerRadius(cornerRadius: 7.5)
        label.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_189cdd.rawValue), width: sp_lineHeight)
        return label
    }()
    
    var shopModel : SPShopModel?{
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
        self.shopIconImageView.sp_cache(string: sp_getString(string: shopModel?.shop_logo), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: shopModel?.shop_name)
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.shopIconImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.typeImgView)
        self.addSubview(self.authLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shopIconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(60)
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(19)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopIconImageView.snp.right).offset(20)
            maker.top.equalTo(self).offset(29)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.typeImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(9)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.width.equalTo(60)
            maker.height.equalTo(15)
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-10)
        }
        self.authLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(14)
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-10)
        }
       
    }
    deinit {
        
    }
}
// MARK: - action
extension SPShopHomeView {
    
}

