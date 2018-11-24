//
//  SPConfirmAddressView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfrimAddressView:  UIView{
    fileprivate lazy var addressView : SPConfirmAddressContentView = {
       return SPConfirmAddressContentView()
    }()
    fileprivate lazy var noDataBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("  填写收货地址", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setImage(UIImage(named: "public_add_gray"), for: UIControlState.normal)
        btn.isHidden = true
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(sp_clickAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var addressModel : SPAddressModel? {
        didSet{
            self.setupData()
        }
    }
    var clickBlock : SPBtnClickBlock?
    
    fileprivate func setupData(){
        var isHave = false
        if let model = addressModel {
            self.addressView.isHidden = false
            self.noDataBtn.isHidden = true
            self.addressView.addressModel = model
            isHave = true
        }else{
            self.addressView.isHidden = true
            self.noDataBtn.isHidden = false
            isHave = false
        }
        self.addressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.snp.top).offset(12)
            maker.height.greaterThanOrEqualTo(0).priority(ConstraintPriority.high)
            if isHave {
                 maker.bottom.equalTo(self.snp.bottom).offset(-12)
            }
        }
        self.noDataBtn.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.addressView.snp.top).offset(0)
            maker.height.equalTo(60)
            if !isHave {
                 maker.bottom.equalTo(self.snp.bottom).offset(-12)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAction))
        self.addGestureRecognizer(tap)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func sp_clickAction(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.addressView)
        self.addSubview(self.noDataBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.addressView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.snp.top).offset(12)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-12)
        }
        self.noDataBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.addressView.snp.top).offset(0)
            maker.height.equalTo(60)
            maker.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
    deinit {
        
    }
}
fileprivate class SPConfirmAddressContentView:  UIView{
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
    lazy var nextImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_rightBack")
        return imageView
    }()
    var addressModel : SPAddressModel? {
        didSet{
            self.setupData()
        }
    }
    fileprivate func setupData(){
        if let model = addressModel{
            self.phoneLabel.text = sp_getString(string: model.mobile)
            self.nameLabel.text = sp_getString(string: model.name)
            self.addressLabel.text = sp_getString(string: model.addrdetail).count > 0 ? sp_getString(string: model.addrdetail) : "\(sp_getString(string: model.area))\(sp_getString(string: model.addr))"
            
        }else{
            self.phoneLabel.text = ""
            self.nameLabel.text = ""
            self.addressLabel.text = ""
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
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.nameLabel)
        self.addSubview(self.phoneLabel)
        self.addSubview(self.addressLabel)
        self.addSubview(self.nextImageView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.top.equalTo(self.snp.top).offset(12)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(8)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.right.equalTo(self.nextImageView.snp.left).offset(-8)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.right.equalTo(self.nextImageView.snp.left).offset(-8)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-12)
        }
        self.nextImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.right.equalTo(self).offset(-12)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
