//
//  SPShopCartHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPShopCartHeaderSelectBlock = (_ shopModel : SPShopModel?,_ isSelect : Bool)-> Void
class SPShopCartHeadView:  UITableViewHeaderFooterView{
    
    lazy var selectBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_default"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickSelectAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.sp_cornerRadius(cornerRadius: 20)
        return imageView
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    var shopModel : SPShopModel?{
        didSet{
            sp_setupData()
        }
    }
    var selectBlock : SPShopCartHeaderSelectBlock?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: shopModel?.shop_name)
        self.logoImageView.sp_cache(string: sp_getString(string: shopModel?.shop_logo), plImage: sp_getLogoImg())
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       self.contentView.addSubview(self.selectBtn)
        self.contentView.addSubview(self.logoImageView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.width.height.equalTo(14)
        }
        self.logoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.selectBtn.snp.right).offset(12)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.width.height.equalTo(40)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImageView.snp.right).offset(14)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView).offset(-12)
        }
    }
    deinit {
        
    }
}
extension SPShopCartHeadView {
    @objc fileprivate func sp_clickSelectAction(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        guard let block = self.selectBlock else {
            return
        }
        block(self.shopModel,self.selectBtn.isSelected)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        
        let point = touch.location(in:self)     //获取当前点击位置
        sp_log(message: "\(point)")
        if point.x < self.logoImageView.frame.origin.x {
            sp_clickSelectAction()
        }else{
            super.touchesBegan(touches, with: event)
        }
    }
}
