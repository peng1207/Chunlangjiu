//
//  SPMineHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineHeaderView:  UICollectionReusableView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        return view
    }()
    fileprivate lazy var entBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(" 进入卖家中心 >>", for: UIControlState.normal)
        btn.setTitle(" 进入买家中心 >>", for: UIControlState.selected)
        btn.setImage(UIImage(named: "public_company"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_people"), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_00a1fe.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_00a1fe.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickEnter), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickIcon))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var authImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_unAuth")
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAuth))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var noLoginBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("登录", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 15)
        btn.addTarget(self, action: #selector(sp_clickLogin), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickIdent : SPBtnClickBlock?
    var clickLogin : SPBtnClickBlock?
    var clickIcon : SPBtnClickBlock?
    var clickAuth : SPBtnClickBlock?
    var memberModel : SPMemberModel?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     /// 赋值
    func sp_setupData(){
        self.entBtn.isSelected = SPAPPManager.sp_isBusiness() ? true : false
        self.titleLabel.text = SPAPPManager.sp_isBusiness() ? "卖家中心" : "买家中心"
        self.logoImgView.sp_cache(string: sp_getString(string: self.memberModel?.head_portrait), plImage: sp_getLogoImg())
        if SPAPPManager.sp_isBusiness() {
            self.nameLabel.text = sp_getString(string: self.memberModel?.shop_name)
            if sp_getString(string: self.nameLabel.text).count <= 0 {
                self.nameLabel.text = sp_getString(string: self.memberModel?.company_name)
                if sp_getString(string: self.nameLabel.text).count <= 0 {
                    self.nameLabel.text = sp_getString(string: self.memberModel?.name)
                    if sp_getString(string: self.nameLabel.text).count <= 0{
                          self.nameLabel.text = "设置店铺名称"
                    }
                }
            }
        }else{
            self.nameLabel.text =  sp_getString(string: self.memberModel?.username)
            if sp_getString(string: self.nameLabel.text).count <= 0 {
                   self.nameLabel.text = sp_getString(string: memberModel?.login_account)
            }
        }
        
       
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       self.addSubview(self.contentView)
        self.addSubview(self.entBtn)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.logoImgView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.authImgView)
        self.contentView.addSubview(self.noLoginBtn)
        self.sp_addConstraint()
     
//        self.logoImgView.sp_setCornerRadius(corner: 25)
        self.logoImgView.sp_cornerRadius(cornerRadius: 25)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(-18)
        }
        self.entBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.height.equalTo(35)
            maker.bottom.equalTo(self).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(sp_getstatusBarHeight())
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(SP_NAVGIT_HEIGHT)
        }
        self.logoImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(30)
            maker.width.height.equalTo(50)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(22)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImgView.snp.right).offset(23)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(27)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.contentView).offset(-11)
        }
        self.authImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.width.equalTo(50)
            maker.height.equalTo(15)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(17)
        }
        self.noLoginBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(80)
            maker.height.equalTo(30)
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.centerY.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}


extension SPMineHeaderView {
    @objc fileprivate func sp_clickEnter(){
        guard let block = self.clickIdent else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickLogin(){
        guard let block = self.clickLogin else {
            return
        }
        block()
    }
    func sp_checkLogin(){
        let isLogin = SPAPPManager.sp_isLogin(isPush: false)
        self.noLoginBtn.isHidden = isLogin
        self.logoImgView.isHidden = !isLogin
        self.titleLabel.isHidden = !isLogin
        self.nameLabel.isHidden = !isLogin
        self.authImgView.isHidden = !isLogin
    }
    func sp_isAuth(isAuth :Bool) {
        if isAuth {
              self.authImgView.image = UIImage(named: "public_haveAuth")
        }else{
            self.authImgView.image = UIImage(named: "public_unAuth")
        }
        
    }
    @objc fileprivate func sp_clickIcon(){
        guard let block = self.clickIcon else {
            return
        }
        block()
    }
    @objc fileprivate func sp_clickAuth(){
        guard let block = self.clickAuth else {
            return
        }
        block()
    }
}
