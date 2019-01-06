//
//  SPOrderContentView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderContentView:  UIView{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.contentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
