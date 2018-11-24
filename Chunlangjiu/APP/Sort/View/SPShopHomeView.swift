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
        imageView.sp_cornerRadius(cornerRadius: 22.5)
        return imageView
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate lazy var pullBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_pulldown_gray"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_takeup"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickPullAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var phoneTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "联系方式："
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var infoTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "卖家简介："
        return label
    }()
    fileprivate lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        return view
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
        self.contentLabel.text = sp_getString(string: shopModel?.shop_descript)
        self.phoneLabel.text = sp_getString(string: shopModel?.mobile)
        self.infoLabel.text = sp_getString(string: shopModel?.shop_descript)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.shopIconImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.pullBtn)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.phoneTitleLabel)
        self.contentView.addSubview(self.phoneLabel)
        self.contentView.addSubview(self.infoTitleLabel)
        self.contentView.addSubview(self.infoLabel)
        self.addSubview(self.bottomView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shopIconImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(45)
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(12)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopIconImageView.snp.right).offset(10)
            maker.top.equalTo(self.snp.top).offset(15)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.pullBtn.snp.left).offset(-8)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(8)
        }
        self.pullBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.width.equalTo(18)
            maker.height.equalTo(10)
            maker.centerY.equalTo(self.shopIconImageView.snp.centerY).offset(0)
        }
        sp_updatePullLayout()
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.contentView.snp.top).offset(0)
        }
        self.phoneTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(14)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneTitleLabel.snp.right).offset(0)
            maker.top.equalTo(self.phoneTitleLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
        }
        self.infoTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.infoTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneTitleLabel.snp.left).offset(0)
            maker.top.equalTo(self.phoneTitleLabel.snp.bottom).offset(15)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
         
        }
        self.infoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.infoTitleLabel.snp.right).offset(0)
            maker.top.equalTo(self.infoTitleLabel.snp.top).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.height.greaterThanOrEqualTo(self.infoTitleLabel.snp.height).offset(0)
            maker.bottom.equalTo(self.contentView).offset(-15)
        }
        self.bottomView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.equalTo(self.contentView.snp.bottom).offset(0)
            maker.height.equalTo(10)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPShopHomeView {
    @objc fileprivate func sp_clickPullAction(){
        self.pullBtn.isSelected = !self.pullBtn.isSelected
        self.contentView.isHidden = !self.pullBtn.isSelected
       sp_updatePullLayout()
    }
    /// 更新pull按钮的约束
    fileprivate func sp_updatePullLayout(){
        self.contentView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.equalTo(self.shopIconImageView.snp.bottom).offset(15)
            if self.pullBtn.isSelected {
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.height.equalTo(0)
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        
        let point = touch.location(in:self)     //获取当前点击位置
        if point.x > self.pullBtn.frame.origin.x  - 10 , point.y < self.pullBtn.frame.size.height + self.pullBtn.frame.origin.y + 20{
            self.sp_clickPullAction()
        }else{
            super.touchesBegan(touches, with: event)
        }
    }
}

