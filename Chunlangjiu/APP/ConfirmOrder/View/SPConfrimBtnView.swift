//
//  SPConfrimBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/7.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfrimBtnView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
       let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "实付金额"
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var btn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("去结算", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubitAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.btn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(12)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.btn.snp.left).offset(-12)
        }
        self.btn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(80)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPConfrimBtnView {
    @objc fileprivate func sp_clickSubitAction(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
}
