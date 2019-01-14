//
//  SPFansListTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPFansListTableCell: UITableViewCell {
    
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPFansListModel? {
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.nameLabel.text = sp_getString(string: self.model?.name)
        self.phoneLabel.text = sp_getString(string: self.model?.mobile)
        self.timeLabel.text = sp_getString(string: self.model?.time)
        self.priceLabel.text = sp_getString(string: self.model?.commission)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.phoneLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.lineView)
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
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
