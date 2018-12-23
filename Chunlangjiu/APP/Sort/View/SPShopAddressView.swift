//
//  SPShopAddressView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopAddressView:  UIView{
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
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
        self.addSubview(self.addressLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(18)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(20)
            maker.top.equalTo(self.titleLabel.snp.top).offset(0)
            maker.right.equalTo(self).offset(-20)
            maker.height.greaterThanOrEqualTo(15)
            maker.bottom.equalTo(self.snp.bottom).offset(-18)
        }
    }
    deinit {
        
    }
}
