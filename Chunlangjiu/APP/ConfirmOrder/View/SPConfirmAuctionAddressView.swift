//
//  SPConfirmAuctionAddressView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/25.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfirmAuctionAddressView:  UIView{
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var nextImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_rightBack")
        return view
    }()
    fileprivate lazy var nameTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        label.text = "收货人"
        return label
    }()
    fileprivate lazy var addressTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        label.text = "收货地址"
        return label
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
            self.sp_setupData()
        }
    }
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
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
    /// 赋值
    fileprivate func sp_setupData(){
        if let model = self.addressModel {
            sp_showAddress(isShow: true)
            self.nameLabel.text = sp_getString(string: model.name)
            self.phoneLabel.text = sp_getString(string: model.mobile)
            self.addressLabel.text = sp_getString(string: model.addrdetail).count > 0 ? sp_getString(string: model.addrdetail) : "\(sp_getString(string: model.area))\(sp_getString(string: model.addr))"
        }else{
            sp_showAddress(isShow: false)
        }
       
    }
    fileprivate func sp_showAddress(isShow : Bool){
        self.noDataBtn.isHidden = isShow
        self.nameLabel.isHidden = !isShow
        self.phoneLabel.isHidden = !isShow
        self.nextImgView.isHidden = !isShow
        self.addressLabel.isHidden = !isShow
        self.addressTitleLabel.isHidden = !isShow
        self.nameTitleLabel.isHidden = !isShow
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.nameTitleLabel)
        self.addSubview(self.nameLabel)
        self.addSubview(self.phoneLabel)
        self.addSubview(self.addressTitleLabel)
        self.addSubview(self.addressLabel)
        self.addSubview(self.nextImgView)
        self.addSubview(self.noDataBtn)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAction))
        self.addGestureRecognizer(tap)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.nameTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.addressTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.nameTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.top.equalTo(self).offset(13)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-26)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self).offset(16)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameTitleLabel.snp.right).offset(35)
            maker.top.equalTo(self).offset(16)
            maker.right.equalTo(self.phoneLabel.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.nextImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-12)
            maker.width.equalTo(7)
            maker.height.equalTo(13)
            maker.top.equalTo(self.snp.top).offset(40)
        }
        self.addressTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameTitleLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameTitleLabel.snp.bottom).offset(26)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel).offset(0)
            maker.top.equalTo(self.addressTitleLabel.snp.top).offset(3)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.snp.right).offset(-26)
            maker.bottom.equalTo(self.snp.bottom).offset(-25)
        }
        self.noDataBtn.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(self).offset(0)
            maker.height.equalTo(92)
        }
       
    }
    deinit {
        
    }
}
