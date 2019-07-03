//
//  SPAppraisalBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/24.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPAppraisalBtnView:  UIView{
     lazy var unidentifiedBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("待鉴定\n(00)", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_unidentified), for: UIControlEvents.touchUpInside)
        btn.tag = 0
        btn.isSelected = true
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
     lazy var identifiedBtBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("已鉴定\n(00)", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_identified), for: UIControlEvents.touchUpInside)
        btn.tag = 1
        btn.titleLabel?.numberOfLines = 2
        btn.titleLabel?.textAlignment = .center
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    var clickBlock : SPBtnIndexClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.unidentifiedBtn)
        self.addSubview(self.identifiedBtBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.unidentifiedBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.identifiedBtBtn.snp.width).offset(0)
        }
        self.identifiedBtBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.unidentifiedBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.unidentifiedBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        sp_updateLineLayout()
    }
    fileprivate func sp_updateLineLayout(){
        self.lineView.snp.remakeConstraints { (maker) in
            maker.width.equalTo(40)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            if self.unidentifiedBtn.isSelected {
                maker.centerX.equalTo(self.unidentifiedBtn.snp.centerX).offset(0)
            }else{
                maker.centerX.equalTo(self.identifiedBtBtn.snp.centerX).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPAppraisalBtnView {
    @objc fileprivate func sp_unidentified(){
        sp_allNoSelect()
        self.unidentifiedBtn.isSelected = true
        sp_dealComplete(index: 0)
          sp_updateLineLayout()
    }
    @objc fileprivate func sp_identified(){
         sp_allNoSelect()
        self.identifiedBtBtn.isSelected = true
        sp_dealComplete(index: 1)
        sp_updateLineLayout()
    }
    /// 按钮点击回调处理
    ///
    /// - Parameter index: 点击位置
    fileprivate func sp_dealComplete(index: Int){
        guard let block = self.clickBlock else {
            return
        }
        block(index)
    }
    /// 所有的按钮不可选中
    fileprivate func sp_allNoSelect(){
        self.unidentifiedBtn.isSelected = false 
        self.identifiedBtBtn.isSelected = false
    }
    /// 设置那个位置选中
    ///
    /// - Parameter index: 位置
    func sp_dealSelect(index : Int){
        sp_allNoSelect()
        if index == 0 {
            self.unidentifiedBtn.isSelected = true
        }else{
            self.identifiedBtBtn.isSelected = true
        }
        sp_updateLineLayout()
    }
    /// 获取选中的位置
    ///
    /// - Returns: 位置
    func sp_getSelect()->Int{
        return self.unidentifiedBtn.isSelected ? 0 : 1
    }
}

