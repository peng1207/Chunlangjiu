//
//  SPFansListSectionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPFansListSectionView: UITableViewHeaderFooterView{
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.text = "粉丝名称"
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.text = "手机号码"
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.text = "注册时间"
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        var att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "累计佣金", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)]))
        att.append(NSAttributedString(string: "(\(sp_getString(string: SP_CHINE_MONEY)))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor:SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        label.attributedText = att
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.phoneLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.priceLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.phoneLabel.snp.width).offset(0)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.nameLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.nameLabel).offset(0)
            maker.width.equalTo(self.timeLabel.snp.width).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.phoneLabel).offset(0)
            maker.width.equalTo(self.priceLabel.snp.width).offset(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.timeLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.timeLabel).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(-5)
        }
    }
    deinit {
        
    }
}
