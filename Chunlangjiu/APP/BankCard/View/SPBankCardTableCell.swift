//
//  SPBankCardTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPBankCardTableCell: UITableViewCell {
    fileprivate lazy var cellView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    
    fileprivate lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 17.5)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var typeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.text = "储蓄卡"
        return label
    }()
    fileprivate lazy var cardLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: sp_isLargeScreen() ? 24 : 20)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    var model : SPBankCardModel? {
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
        self.nameLabel.text = sp_getString(string: self.model?.name)
        if sp_getString(string: self.model?.cardname).count > 0 {
            self.typeLabel.text = sp_getString(string: self.model?.cardname)
        }else{
            self.typeLabel.text = "储蓄卡"
        }
        if sp_getString(string: self.model?.abbreviation).count > 0 {
             self.logoImgView.image = UIImage(named: sp_getString(string: self.model?.abbreviation))
        }else{
            self.logoImgView.image = nil
        }
       
        
        self.cardLabel.text = sp_getString(string: self.model?.card).replaceBankCard()
        if self.logoImgView.image == nil {
            self.logoImgView.sp_cache(string: self.model?.logo, plImage: sp_getLogoImg())
        }
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.logoImgView)
        self.cellView.addSubview(self.nameLabel)
        self.cellView.addSubview(self.typeLabel)
        self.cellView.addSubview(self.cardLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(150)
        }
        self.logoImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cellView).offset(13)
            maker.top.equalTo(self.cellView).offset(33)
            maker.width.height.equalTo(35)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImgView.snp.right).offset(21)
            maker.right.equalTo(self.cellView.snp.right).offset(-13)
            maker.top.equalTo(self.logoImgView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.typeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.left).offset(0)
            maker.right.equalTo(self.nameLabel.snp.right).offset(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.cardLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeLabel.snp.left).offset(0)
            maker.right.equalTo(self.typeLabel.snp.right).offset(0)
            maker.top.equalTo(self.typeLabel.snp.bottom).offset(31)
            maker.height.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
