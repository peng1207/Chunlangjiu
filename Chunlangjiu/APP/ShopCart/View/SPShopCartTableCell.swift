//
//  SPShopCartTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SP_SHOPCART_PRODUCT_WIDTH :  CGFloat = 80
typealias SPShopCartDeleteComplete = (_ model : SPProductModel?)->  Void
typealias SPShopCartSelectComplete = (_ model : SPProductModel?,_ isSelect : Bool) -> Void
typealias SPShopCartNumComplete = (_ model : SPProductModel?,_ num : String) -> Void
class SPShopCartTableCell: UITableViewCell {
    lazy var productImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_default"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickSelectAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    lazy var sepecLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    lazy var numView : SPNumView = {
        let num = SPNumView()
        num.numBlock = { [weak self](type, numText) in
            self?.sp_dealNumComplete(num: numText)
        }
        return num
    }()
    lazy var deleteBtn : UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(named: "address_delete"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDeleteAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var productModel : SPProductModel?{
        didSet{
            sp_setupData()
        }
    }
    var deleteBlock : SPShopCartDeleteComplete?
    var selectBlock : SPShopCartSelectComplete?
    var numBlock : SPShopCartNumComplete?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
        self.sp_setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.productImageView.sp_cache(string: self.productModel?.image_default_id, plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string: self.productModel?.title)
        self.priceLabel.text = "¥\(sp_getString(string: self.productModel?.showCartPrice))"
        self.sepecLabel.text =  sp_getString(string: self.productModel?.unit)
        self.numView.numLabel.text = sp_getString(string: self.productModel?.quantity)
        self.selectBtn.isSelected = self.productModel?.is_checked == 0 ? false : true
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.selectBtn)
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.sepecLabel)
        self.contentView.addSubview(self.numView)
        self.contentView.addSubview(self.deleteBtn)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(14)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            maker.left.equalTo(self.contentView.snp.left).offset(10)
        }
        self.productImageView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView.snp.top).offset(5)
            maker.left.equalTo(self.selectBtn.snp.right).offset(5)
            maker.width.equalTo(SP_SHOPCART_PRODUCT_WIDTH)
            maker.height.equalTo(self.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.productImageView.snp.top).offset(0)
            maker.left.equalTo(self.productImageView.snp.right).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-16)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(4)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.sepecLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-15)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.numView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(-10)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.equalTo(30)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.numView.snp.right).offset(0)
            maker.height.equalTo(25)
            maker.width.equalTo(23)
            maker.bottom.equalTo(self.numView.snp.bottom).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.selectBtn.snp.left).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPShopCartTableCell {
    @objc fileprivate func sp_clickSelectAction(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        guard let block = self.selectBlock else {
            return
        }
        block(self.productModel,self.selectBtn.isSelected)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        
        let point = touch.location(in:self)     //获取当前点击位置
        sp_log(message: "\(point)")
        if point.x < self.productImageView.frame.origin.x {
            sp_clickSelectAction()
        }else{
              super.touchesBegan(touches, with: event)
        }
    }
    /// 点击删除按钮
    @objc fileprivate func sp_clickDeleteAction(){
        guard let block = self.deleteBlock else {
            return
        }
        block(self.productModel)
    }
    fileprivate func sp_dealNumComplete(num : String){
        guard let block  = self.numBlock else {
            return
        }
        block(self.productModel,num)
    }
    
    
}
