//
//  SPOrderAddressView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderAddressView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .right
        label.text = "地址:"
        return label
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    var detaileModel : SPOrderDetaileModel?{
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
        self.nameLabel.text = sp_getString(string: detaileModel?.receiver_name)
        self.phoneLabel.text = sp_getString(string: detaileModel?.receiver_mobile)
        self.addressLabel.text = "\(sp_getString(string: detaileModel?.receiver_state))\(sp_getString(string: detaileModel?.receiver_city))\(sp_getString(string: detaileModel?.receiver_address))"
    
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.nameLabel)
        self.addSubview(self.phoneLabel)
        self.addSubview(self.addressLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(13)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.equalTo(57)
        }
        self.nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(67)
            maker.top.equalTo(self.snp.top).offset(13)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(8)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.right.equalTo(self.snp.right).offset(-8)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.snp.right).offset(-8)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-12)
        }
       
    }
    deinit {
        
    }
}
