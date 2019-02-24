//
//  SPCapitalDetDetTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCapitalDetDetTableCell: UITableViewCell {
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
    }
    var model : SPCapitalDetDetModel? {
        didSet{
            sp_setupData()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: model?.title)
        self.contentLabel.text = sp_getString(string: model?.content)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(31)
            maker.top.equalTo(self.contentView).offset(15)
            maker.height.equalTo(20)
            maker.width.greaterThanOrEqualTo(0)
        }
        
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(18)
            maker.right.equalTo(self.contentView).offset(-11)
            maker.top.equalTo(self.contentView.snp.top).offset(15)
            maker.height.greaterThanOrEqualTo(20)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(15)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
