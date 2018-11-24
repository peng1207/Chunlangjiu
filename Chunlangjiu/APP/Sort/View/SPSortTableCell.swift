//
//  SPSortTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/15.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPSortTableCell: UITableViewCell {
    
    lazy var titleView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        view.sp_cornerRadius(cornerRadius: 13.5)
        return view
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(5)
            maker.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(27)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleView.snp.left).offset(18)
            maker.right.equalTo(self.titleView.snp.right).offset(-18)
            maker.top.bottom.equalTo(self.titleView).offset(0)
        }
    }
    deinit {
        
    }
}
