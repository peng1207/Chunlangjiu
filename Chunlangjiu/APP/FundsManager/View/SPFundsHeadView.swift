//
//  SPFundsHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPFundsHeadView:  UIView{
    fileprivate lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate lazy var balabceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("余额", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBalance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var bondBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("保证金", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBond), for: UIControlEvents.touchUpInside)
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
        self.addSubview(self.balabceBtn)
        self.addSubview(self.bondBtn)
        self.addSubview(self.lineView)
        sp_clickBalance()
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.balabceBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.bondBtn.snp.width).offset(0)
        }
        self.bondBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.balabceBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(sp_lineHeight)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.centerX.equalTo(self.balabceBtn.snp.centerX).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPFundsHeadView{
    @objc fileprivate func sp_clickBalance(){
        sp_setDefault()
        self.balabceBtn.isSelected = true
    }
    @objc fileprivate func sp_clickBond(){
        sp_setDefault()
        self.bondBtn.isSelected = true
    }
    fileprivate func sp_setDefault(){
        self.balabceBtn.isSelected = false
        self.bondBtn.isSelected = false
    }
}
