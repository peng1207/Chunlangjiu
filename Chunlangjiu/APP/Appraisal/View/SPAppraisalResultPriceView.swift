//
//  SPAppraisalResultPriceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAppraisalResultPriceView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_d5a359.rawValue)
        label.textAlignment = .left
        label.text = "名酒评估定价"
        return label
    }()
    fileprivate lazy var symbolLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 36)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_d5a359.rawValue)
        label.textAlignment = .left
        label.text = SP_CHINE_MONEY
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 50)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_d5a359.rawValue)
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
        self.addSubview(self.symbolLabel)
        self.addSubview(self.priceLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(17)
            maker.right.equalTo(self).offset(-17)
            maker.top.equalTo(self).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.symbolLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.symbolLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(29)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.symbolLabel.snp.right).offset(9)
            maker.bottom.equalTo(self.symbolLabel.snp.bottom).offset(2)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.titleLabel.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
