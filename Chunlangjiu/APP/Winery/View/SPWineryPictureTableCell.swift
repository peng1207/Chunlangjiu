//
//  SPWineryPictureTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryPictureTableCell: UITableViewCell {
    
    lazy var iconImageView : UIImageView = {
        return UIImageView()
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
        self.contentView.addSubview(self.iconImageView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.contentView).offset(8)
            maker.height.equalTo(self.iconImageView.snp.width).offset(0.56)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
