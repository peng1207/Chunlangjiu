//
//  SPProductDetailTopView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPProductDetailTopView:  UIView{

    fileprivate lazy var productBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("商品", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.selected)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(sp_clickProductAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var detaileBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("详情", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.selected)
            btn.addTarget(self, action: #selector(sp_clickDetaileAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var evaluateBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("评价", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.selected)
            btn.addTarget(self, action: #selector(sp_clickEvaluateAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var underline : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    var btnClickBlock : SPBtnIndexClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.productBtn)
        self.addSubview(self.detaileBtn)
        self.addSubview(self.evaluateBtn)
//        self.addSubview(self.lineView)
        self.addSubview(self.underline)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(60)
        }
        self.detaileBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.productBtn.snp.width).offset(0)
        }
        self.evaluateBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.productBtn.snp.width).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
//        self.lineView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.productBtn).offset(0)
//            maker.bottom.equalTo(self).offset(0)
//            maker.height.equalTo(sp_lineHeight)
//        }
        self.sp_updateUnderLineLayout()
    }
    fileprivate func sp_updateUnderLineLayout(){
        self.underline.snp.remakeConstraints { (maker) in
            if self.productBtn.isSelected{
                  maker.left.right.equalTo(self.productBtn).offset(0)
            }else if self.detaileBtn.isSelected{
                  maker.left.right.equalTo(self.detaileBtn).offset(0)
            }else if self.evaluateBtn.isSelected {
                  maker.left.right.equalTo(self.evaluateBtn).offset(0)
            }
          
            maker.height.equalTo(2)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPProductDetailTopView {
    @objc fileprivate func sp_clickProductAction(){
        self.sp_setBtnIndex(index: 0)
        self.sp_dealBtnClickComplter(index: 0)
    }
    @objc fileprivate func sp_clickDetaileAction(){
           self.sp_setBtnIndex(index: 1)
         self.sp_dealBtnClickComplter(index: 1)
    }
    @objc fileprivate func sp_clickEvaluateAction(){
          self.sp_setBtnIndex(index: 2)
         self.sp_dealBtnClickComplter(index: 2)
    }
    fileprivate func sp_dealBtnClickComplter(index : Int){
        guard let block = self.btnClickBlock else {
            return
        }
        block(index)
    }
    func sp_setBtnIndex(index : Int){
        self.productBtn.isSelected = false
        self.detaileBtn.isSelected = false
        self.evaluateBtn.isSelected = false
        if index == 0 {
            self.productBtn.isSelected = true
        }else if index == 1 {
            self.detaileBtn.isSelected = true
        }else if index == 2 {
            self.evaluateBtn.isSelected = true
        }
         self.sp_updateUnderLineLayout()
    }
}
