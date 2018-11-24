//
//  SPAddressTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPAddressEditBlock = (_ model : SPAddressModel?) -> Void

class SPAddressTableCell: UITableViewCell {
    fileprivate lazy var nameLabel : UILabel = {
       let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.numberOfLines = 2 
        return label
    }()
    fileprivate lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "address_edit"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickEditAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "address_select_green"), for: UIControlState.normal)
        return btn
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var addressModel : SPAddressModel? {
        didSet{
            self.setupData()
        }
    }
    var select : Bool = false {
        didSet{
            self.sp_dealIsSelect()
        }
    }
    fileprivate var selectWConstraint : Constraint!
    fileprivate var selectLeftConstraint : Constraint!
    fileprivate var nameLeftConstraint : Constraint!
    var editBlock : SPAddressEditBlock?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置数据
    fileprivate func setupData(){
        self.nameLabel.text = sp_getString(string: addressModel?.name)
        self.phoneLabel.text = sp_getString(string: addressModel?.mobile)
        self.addressLabel.text = sp_getString(string: addressModel?.addrdetail)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.phoneLabel)
        self.contentView.addSubview(self.addressLabel)
        self.contentView.addSubview(self.selectBtn)
        self.contentView.addSubview(self.editBtn)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
           self.selectWConstraint = maker.width.equalTo(0).constraint
           self.selectLeftConstraint =  maker.left.equalTo(self.contentView).offset(0).constraint
        }
        self.nameLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.contentView).offset(12)
            self.nameLeftConstraint = maker.left.equalTo(self.selectBtn.snp.right).offset(12).constraint
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(8)
            maker.top.equalTo(self.nameLabel.snp.top).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.editBtn.snp.left).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(4)
            maker.right.equalTo(self.editBtn.snp.left).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.editBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-12)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(40)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPAddressTableCell {
    
    @objc fileprivate func sp_clickEditAction(){
        guard let block = self.editBlock else {
            return
        }
        block(self.addressModel)
    }
    fileprivate func sp_dealIsSelect(){
        self.selectLeftConstraint.update(offset: self.select ? 12 : 0)
        self.selectWConstraint.update(offset: self.select ? 50 : 0)
        self.nameLeftConstraint.update(offset: self.select ? 6 : 12)
    }
}
