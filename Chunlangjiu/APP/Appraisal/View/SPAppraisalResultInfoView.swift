//
//  SPAppraisalResultInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalResultInfoView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "鉴定报告"
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "来自醇狼APP"
        return label
    }()
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_app_logo")
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 8)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.image = sp_getDefaultImg()
        view.sp_cornerRadius(cornerRadius: 17)
        return view
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 8)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        label.text = "鉴别结果根据用户提供的信息得出"
        return label
    }()
    var model : SPAppraisalProductModel?{
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
        self.iconImgView.sp_cache(string: sp_getString(string: self.model?.authenticate_img), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: self.model?.authenticate_name)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.imgView)
        self.addSubview(self.contentLabel)
        self.addSubview(self.iconImgView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.tipsLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(15)
            maker.right.equalTo(self).offset(-15)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self).offset(35)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            maker.centerX.equalTo(self.snp.centerX).offset(5)
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(19)
            maker.height.equalTo(10)
            maker.right.equalTo(self.contentLabel.snp.left).offset(-8)
            maker.centerY.equalTo(self.contentLabel.snp.centerY).offset(0)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(34)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(8)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(6)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(14)
        }
    }
    deinit {
        
    }
}
