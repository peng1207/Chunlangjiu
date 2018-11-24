//
//  SPCityTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCityTableCell: UITableViewCell {
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
            maker.top.bottom.equalTo(self.contentView).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
