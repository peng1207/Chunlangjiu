//
//  SPIndexSectionAHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexSectionAHeaderView:  UITableViewHeaderFooterView{
    var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
//        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 15)
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
         self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(self.contentView.snp.height).offset(0)
        }
    }
    deinit {
        
    }
}

