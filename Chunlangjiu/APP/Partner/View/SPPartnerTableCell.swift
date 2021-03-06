//
//  SPPartnerTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPPartnerComplete = (_ model : SPPartnerModel?)->Void
class SPPartnerTableCell: UITableViewCell {
    fileprivate lazy var cellView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var shopImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var labelView : SPLabelView = {
        let view = SPLabelView()
        view.borderColor = SPColorForHexString(hex: SP_HexColor.color_01b5da.rawValue)
        return view
    }()
    fileprivate lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 11)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_partner")
        return view
    }()
    
    fileprivate lazy var entBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("进店 >", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 11)
        btn.addTarget(self, action: #selector(sp_clickEnter), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickShopBlock : SPPartnerComplete?
    var model : SPPartnerModel?{
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.shopImgView.sp_cache(string: sp_getString(string: self.model?.shop_logo), plImage: sp_getLogoImg())
        self.nameLabel.text = sp_getString(string: self.model?.shopname)
        self.addressLabel.text = "地址:\(sp_getString(string: self.model?.shop_addr))"
        let att = NSMutableAttributedString(string: "该店家有", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 11),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)])
        att.append(NSAttributedString(string: "\(sp_getString(string: self.model?.num).count > 0 ? sp_getString(string: self.model?.num) : "0")", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font: sp_getFontSize(size: 12)]))
        
         att.append(NSAttributedString(string: "款商品正在销售", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.font: sp_getFontSize(size: 11)]))
        self.tipLabel.attributedText = att
        self.labelView.listArray = self.model?.sp_getLabel()
      
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.shopImgView)
        self.cellView.addSubview(self.nameLabel)
        self.cellView.addSubview(self.typeImgView)
        self.cellView.addSubview(self.addressLabel)
        self.cellView.addSubview(self.labelView)
        self.cellView.addSubview(self.tipLabel)
        self.cellView.addSubview(self.entBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(6)
            maker.right.equalTo(self.contentView.snp.right).offset(-6)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            maker.height.equalTo(110)
        }
        self.shopImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cellView).offset(10)
            maker.top.equalTo(self.cellView.snp.top).offset(16)
            maker.bottom.equalTo(self.cellView.snp.bottom).offset(-14)
            maker.width.equalTo(self.shopImgView.snp.height).offset(0)
        }
        self.nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopImgView.snp.right).offset(13)
            maker.top.equalTo(self.shopImgView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.typeImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(12)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.width.equalTo(60)
            maker.height.equalTo(15)
            maker.right.lessThanOrEqualTo(self.cellView.snp.right).offset(-15)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(14)
            maker.height.equalTo(15)
            maker.right.equalTo(self.cellView.snp.right).offset(-15)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.labelView.snp.left).offset(0)
            maker.right.equalTo(self.labelView.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.labelView.snp.bottom).offset(5)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.addressLabel.snp.left).offset(0)
            maker.right.equalTo(self.entBtn.snp.left).offset(-11)
            maker.top.equalTo(self.addressLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.entBtn.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.entBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.cellView.snp.right).offset(-15)
            maker.centerY.equalTo(self.tipLabel.snp.centerY).offset(0)
            maker.height.equalTo(11)
            maker.width.greaterThanOrEqualTo(0)
        }
        
    }
    deinit {
        
    }
}
extension SPPartnerTableCell {
    @objc fileprivate func sp_clickEnter(){
        guard let block = self.clickShopBlock else {
            return
        }
        block(self.model) 
    }
    
}
