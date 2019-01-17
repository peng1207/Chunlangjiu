//
//  SPShopInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopInfoView:  UIView{
    fileprivate lazy var infoTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "店铺简介"
        return label
    }()
    lazy var infoLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var timeTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "开店时间"
        return label
    }()
    lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
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
        self.addSubview(self.infoTitleLabel)
        self.addSubview(self.infoLabel)
        self.addSubview(self.timeTitleLabel)
        self.addSubview(self.timeLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.infoTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.timeTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.infoTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self).offset(18)
        }
        self.infoLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.infoTitleLabel.snp.right).offset(20)
            maker.top.equalTo(self.infoTitleLabel).offset(0)
            maker.right.equalTo(self.snp.right).offset(-20)
            maker.height.greaterThanOrEqualTo(15)
        }
        self.timeTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.infoTitleLabel.snp.left).offset(0)
            maker.top.equalTo(self.infoLabel.snp.bottom).offset(25)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.infoLabel.snp.left).offset(0)
            maker.top.equalTo(self.timeTitleLabel.snp.top).offset(0)
            maker.right.equalTo(self.infoLabel.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-18)
        }
    }
    deinit {
        
    }
}
