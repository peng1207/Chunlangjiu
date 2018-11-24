//
//  SPProductEvaluationListTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPClickEvaluatComplete = (_ mode :SPOrderItemModel? )-> Void
class SPProductEvaluationListTableCell: UITableViewCell {
    
    fileprivate lazy var productImageView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var specLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate lazy var button : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("评价", for: UIControlState.normal)
        btn.setTitle("已好评", for: UIControlState.disabled)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(self, action: #selector(sp_dealComplete), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPClickEvaluatComplete?
    var itemModel : SPOrderItemModel?{
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
    @objc fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block(self.itemModel)
    }
    /// 赋值
    fileprivate func sp_setupData(){
    self.productImageView.sp_cache(string: sp_getString(string:self.itemModel?.pic_path), plImage: sp_getDefaultImg())
        self.nameLabel.text = sp_getString(string: self.itemModel?.title)
        self.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.itemModel?.price))"
        self.specLabel.text = sp_getString(string: self.itemModel?.spec_nature_info)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.productImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.specLabel)
        self.contentView.addSubview(self.button)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(9)
            maker.width.equalTo(60)
            maker.height.equalTo(self.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
            maker.centerY.equalTo(self.contentView).offset(0)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(13)
            maker.left.equalTo(self.productImageView.snp.right).offset(6)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.contentView).offset(-12)
        }
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(7)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.specLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.priceLabel.snp.right).offset(14)
            maker.centerY.equalTo(self.priceLabel.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
        }
        self.button.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-12)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-9)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.equalTo(60)
        }
    }
    deinit {
        
    }
}
