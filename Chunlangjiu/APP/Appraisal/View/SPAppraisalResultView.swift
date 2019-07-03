//
//  SPAppraisalResultView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/24.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalResultView:  UIView{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
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
            maker.left.equalTo(self).offset(17)
            maker.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(17)
            maker.top.equalTo(self.titleLabel.snp.top).offset(1)
            maker.height.greaterThanOrEqualTo(self.titleLabel.snp.height).offset(0)
            maker.right.equalTo(self.snp.right).offset(-17)
            maker.bottom.equalTo(self.snp.bottom).offset(-1)
        }
    }
    deinit {
        
    }
}
