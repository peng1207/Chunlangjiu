//
//  SPWinertScoreTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryScoreTableCell: UITableViewCell {
    
    fileprivate lazy var yearLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var rpLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var wsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
         label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var jrLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPWinderGrade?{
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
        self.yearLabel.text = sp_getString(string: self.model?.year)
        self.rpLabel.text = sp_getString(string: self.model?.rp)
        self.wsLabel.text = sp_getString(string: self.model?.ws)
        self.jrLabel.text = sp_getString(string: self.model?.jr)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.yearLabel)
        self.contentView.addSubview(self.iconImageView)
        self.contentView.addSubview(self.rpLabel)
        self.contentView.addSubview(self.wsLabel)
        self.contentView.addSubview(self.jrLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.yearLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.yearLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(17)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0);
        }
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.yearLabel.snp.right).offset(15)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            maker.width.equalTo(0)
            maker.height.equalTo(0)
        }
        self.rpLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView.snp.right).offset(10)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.wsLabel.snp.width).offset(0)
        }
        self.wsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.rpLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.equalTo(self.jrLabel.snp.width).offset(0)
        }
        self.jrLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.wsLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
