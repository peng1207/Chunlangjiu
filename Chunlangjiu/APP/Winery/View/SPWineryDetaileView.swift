//
//  SPWineryDetaileView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryDetaileView:  UIView{
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    fileprivate lazy var titleLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var logoImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var detaileLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
     lazy var collectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_collect_gray"), for: UIControlState.normal)
        btn.isHidden = true
        return btn
    }()
     lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_share_gray"), for: UIControlState.normal)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var detaileModel : SPWinerDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
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
        self.logoImageView.sp_cache(string: sp_getString(string: detaileModel?.img), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: detaileModel?.name)
        self.detaileLabel.text = sp_getString(string: detaileModel?.intro)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.titleLineView)
        self.addSubview(self.logoImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.detaileLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.collectBtn)
        self.addSubview(self.shareBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(-10)
            maker.height.equalTo(44)
        }
        self.titleLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLineView.snp.bottom).offset(15)
            maker.width.equalTo(130)
            maker.height.equalTo(self.logoImageView.snp.width).offset(0)
            maker.bottom.equalTo(self).offset(-15)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImageView.snp.right).offset(10)
            maker.top.equalTo(self.logoImageView.snp.top).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.detaileLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
        self.shareBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(14)
            maker.right.equalTo(self.snp.right).offset(-26)
            maker.bottom.equalTo(self.logoImageView.snp.bottom).offset(0)
        }
        self.collectBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.shareBtn.snp.left).offset(-26)
            maker.bottom.equalTo(self.shareBtn.snp.bottom).offset(0)
            maker.width.equalTo(16)
            maker.height.equalTo(13)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLineView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.logoImageView.snp.bottom).offset(15)
        }
    }
    deinit {
        
    }
}
