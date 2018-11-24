//
//  SPCountdownView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/7.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 倒计时view
import Foundation
import UIKit
import SnapKit
class SPCountdownView:  UIView{
    let SP_LABEL_MIN_WIDTH  = 20
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "距离结束："
        return label
    }()
    lazy var dayLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    
     lazy var hourLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
     lazy var minueLabel : UILabel = {
        let label = UILabel()
        label.textColor =  SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = self.hourLabel.font
        label.textAlignment = NSTextAlignment.center
        return label
    }()
     lazy var secondLabel : UILabel = {
        let label = UILabel()
        label.textColor =  SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = self.hourLabel.font
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    lazy var dayPointLabel : UILabel = {
        let label = UILabel()
        label.text = "天"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 10)
        return label
    }()
    fileprivate lazy var hourPointLabel : UILabel = {
        let label = UILabel()
        label.text = "时"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 10)
        return label
    }()
    fileprivate lazy var minuPointLabel : UILabel = {
        let label = UILabel()
        label.text = "分"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 10)
        return label
    }()
    fileprivate lazy var secondPointLabel : UILabel = {
        let label = UILabel()
        label.text = "秒"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 10)
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
        self.addSubview(self.dayLabel)
        self.addSubview(self.dayPointLabel)
        self.addSubview(self.hourLabel)
        self.addSubview(self.hourPointLabel)
        self.addSubview(self.minueLabel)
        self.addSubview(self.minuPointLabel)
        self.addSubview(self.secondLabel)
        self.addSubview(self.secondPointLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.dayLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.dayLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(self.titleLabel.snp.right).offset(0)
            maker.width.greaterThanOrEqualTo(SP_LABEL_MIN_WIDTH)
        }
        self.dayPointLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.dayPointLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.dayLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.dayLabel).offset(-1)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.hourLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.hourLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(self.dayPointLabel.snp.right).offset(0)
            maker.width.greaterThanOrEqualTo(SP_LABEL_MIN_WIDTH)
        }
        self.hourPointLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.hourPointLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.hourLabel.snp.right).offset(0)
            maker.bottom.equalTo(self.dayPointLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.minueLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.minueLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.hourPointLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self.hourLabel).offset(0)
            maker.width.greaterThanOrEqualTo(SP_LABEL_MIN_WIDTH)
        }
        self.minuPointLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.minuPointLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.minueLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self.hourPointLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.secondLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.secondLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.minuPointLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self.minueLabel).offset(0)
            maker.width.greaterThanOrEqualTo(SP_LABEL_MIN_WIDTH)
//            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.secondPointLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.secondPointLabel.snp.makeConstraints { (maker ) in
            maker.left.equalTo(self.secondLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self.minuPointLabel).offset(0)
            maker.width.greaterThanOrEqualTo(0)
           maker.right.equalTo(self.snp.right).offset(0)
        }
    }
    deinit {
        
    }
}
