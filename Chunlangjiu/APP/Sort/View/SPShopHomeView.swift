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
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.image = sp_getDefaultUserImg()
        return view
    }()
    lazy var authLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.text = "  个人认证  "
        label.sp_cornerRadius(cornerRadius: 7.5)
        label.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_189cdd.rawValue), width: sp_lineHeight)
        return label
    }()
    fileprivate lazy var appraisalBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_appraisal_white"), for: UIControlState.normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickAppraisal), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var shopModel : SPShopModel?{
        didSet{
           sp_setupData()
        }
    }
    var appraisalBlock : SPBtnClickBlock?
    fileprivate var btnWidth : Constraint!
    fileprivate var btnRight : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sp_appraisal(isHidden:Bool){
        self.appraisalBtn.isHidden = isHidden
        if isHidden {
            self.btnRight.update(offset: -5)
            self.btnWidth.update(offset: 0)
        }else{
            self.btnWidth.update(offset: 61)
            self.btnRight.update(offset: -24)
        }
    }
    
    /// 赋值
    fileprivate func sp_setupData(){
        self.shopIconImageView.sp_cache(string: sp_getString(string: shopModel?.shop_logo), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: shopModel?.shop_name)
        if sp_getString(string: self.shopModel?.authentication).count > 0  {
            self.authLabel.text = "  \(sp_getString(string: self.shopModel?.authentication))  "
        }else{
            self.authLabel.text = "  个人认证  "
        }
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
        self.addSubview(self.shopIconImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.typeImgView)
        self.addSubview(self.authLabel)
        self.addSubview(self.appraisalBtn)
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
            maker.height.greaterThanOrEqualTo(15)
            //            maker.width.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.appraisalBtn.snp.left).offset(-5)
        }
        self.typeImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(14)
            maker.width.equalTo(60)
            maker.height.equalTo(15)
        }
        self.authLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeImgView.snp.right).offset(6)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.typeImgView.snp.top).offset(0)
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-10)
        }
        self.appraisalBtn.snp.makeConstraints { (maker) in
            btnWidth = maker.width.equalTo(0).constraint
            maker.height.equalTo(61)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            btnRight = maker.right.equalTo(self.snp.right).offset(-5).constraint
        }
       
    }
    deinit {
        
    }
}
// MARK: - action
extension SPShopHomeView {
    @objc fileprivate func sp_clickAppraisal(){
        guard let block = self.appraisalBlock else {
            return
        }
        block()
    }
}

