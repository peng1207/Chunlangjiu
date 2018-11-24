//
//  SPShopCartBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPShopCartBtnComplete = (_ isSelect : Bool) -> Void

class SPShopCartBtnView:  UIView{
    
    lazy  var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_default"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red"), for: UIControlState.selected)
        btn.setTitle("  全选", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSelectAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "全选"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    lazy var btn : UIButton = {
       let btn = UIButton()
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("去结算", for: UIControlState.normal)
        btn.setTitle("删除", for: UIControlState.selected)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(clickBtnAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPBtnClickBlock?
    var selectBlock : SPShopCartBtnComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.selectBtn)
        self.addSubview(self.titleLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.btn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectBtn.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.height.equalTo(14)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
//        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
//        self.titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(self.selectBtn.snp.right).offset(8)
//            make.top.bottom.equalTo(self).offset(0)
//            make.width.greaterThanOrEqualTo(0)
//        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.selectBtn.snp.right).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.btn.snp.left).offset(-20)
        }
        self.btn.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(80)
        }
    }
    deinit {
        
    }
}
extension SPShopCartBtnView{
    
    @objc fileprivate func clickBtnAction () {
        if let block = self.clickBlock {
            block()
        }
    }
    @objc fileprivate func sp_clickSelectAction(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
        guard let block = self.selectBlock else {
            return
        }
        block(self.selectBtn.isSelected)
        
    }
}
