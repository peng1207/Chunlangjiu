//
//  SPCapitalDetHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCapitalDetHeadView:  UIView{
  
    fileprivate lazy var recordBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("销售记录", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickRecord), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var rechargeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("充值 ", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickRecharge), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var cashBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提现", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickCash), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
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
        self.addSubview(self.recordBtn)
        self.addSubview(self.rechargeBtn)
        self.addSubview(self.cashBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.recordBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.rechargeBtn.snp.width).offset(0)
        }
        self.rechargeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.recordBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.recordBtn).offset(0)
            maker.width.equalTo(self.cashBtn.snp.width).offset(0)
        }
        self.cashBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.rechargeBtn.snp.right).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.bottom.equalTo(self.rechargeBtn).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPCapitalDetHeadView {
    @objc fileprivate func sp_clickRecord(){
        sp_setBtnDefault()
        self.recordBtn.isSelected = true
    }
    @objc fileprivate func sp_clickRecharge(){
        sp_setBtnDefault()
        self.rechargeBtn.isSelected = true
    }
    @objc fileprivate func sp_clickCash(){
        sp_setBtnDefault()
        self.cashBtn.isSelected = true
    }
    fileprivate func sp_setBtnDefault(){
        self.rechargeBtn.isSelected = false
        self.recordBtn.isSelected = false
        self.cashBtn.isSelected = false
    }
    
}
