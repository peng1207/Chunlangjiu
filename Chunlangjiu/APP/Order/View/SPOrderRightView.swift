//
//  SPOrderRightView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/31.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderRightView:  UIView{
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
     lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
     lazy var btn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.isHidden = true
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 10)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        return btn
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
        self.addSubview(self.btn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.contentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.btn.snp.makeConstraints { (maker) in
            maker.height.equalTo(20)
            maker.right.equalTo(self.contentLabel.snp.left).offset(-10)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
}
