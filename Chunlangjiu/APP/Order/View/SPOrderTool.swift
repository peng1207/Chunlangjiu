//
//  SPOrderTool.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private let SP_ORDERTOOL_TAG =  10000
typealias SPOrderToolSelectComplete = (_ index : Int)->Void
class SPOrderTool:  UIView{
    
    fileprivate lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate lazy var oneBtn : UIButton = {
         return sp_createBtn(tag: SP_ORDERTOOL_TAG)
    }()
    fileprivate lazy var twoBtn : UIButton = {
        return sp_createBtn(tag: SP_ORDERTOOL_TAG + 1)
    }()
    fileprivate lazy var threeBtn : UIButton = {
        return sp_createBtn(tag: SP_ORDERTOOL_TAG + 2)
    }()
    fileprivate lazy var fourBtn : UIButton = {
        return sp_createBtn(tag: SP_ORDERTOOL_TAG + 3)
    }()
    fileprivate lazy var fifeBtn : UIButton = {
        return sp_createBtn(tag: SP_ORDERTOOL_TAG + 4)
    }()
    fileprivate let lineHeight = 2
    private func sp_createBtn(tag : Int) -> UIButton{
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.tag = tag
        btn.addTarget(self, action: #selector(sp_clickBtnAction(sender:)), for: UIControlEvents.touchUpInside)
        return btn
    }
    var dataArray : [SPOrderToolModel]?{
        didSet{
            self.sp_setupData()
        }
    }
    var selectBlock : SPOrderToolSelectComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            var index = 0
            for toolModel in self.dataArray! {
                let button : UIButton? = self.viewWithTag(index + SP_ORDERTOOL_TAG) as? UIButton
                if let btn = button{
                    btn.setTitle(sp_getString(string: toolModel.statusString), for: UIControlState.normal)
                }
                
                
                index = index + 1
            }
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.oneBtn)
        self.addSubview(self.twoBtn)
        self.addSubview(self.threeBtn)
        self.addSubview(self.fourBtn)
        self.addSubview(self.fifeBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.oneBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.twoBtn.snp.width).offset(0)
        }
        self.twoBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.oneBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.oneBtn).offset(0)
            maker.width.equalTo(self.threeBtn.snp.width).offset(0)
        }
        self.threeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.twoBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.twoBtn).offset(0)
            maker.width.equalTo(self.fourBtn.snp.width).offset(0)
        }
        self.fourBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.threeBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.threeBtn).offset(0)
            maker.width.equalTo(self.fifeBtn.snp.width).offset(0)
        }
        self.fifeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.fourBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.fourBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.oneBtn.snp.left).offset(0)
            maker.width.equalTo(self.oneBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.height.equalTo(lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPOrderTool {
    @objc fileprivate func sp_clickBtnAction(sender : UIButton){
        sp_btnSelect(tag: sender.tag)
        sp_updateLineLayout(btn: sender)
        sp_dealSelect(index: sender.tag - SP_ORDERTOOL_TAG)
    }
    fileprivate func sp_btnSelect(tag : Int){
        for btn  in self.subviews {
            if btn is UIButton {
                let button : UIButton = btn as! UIButton
                if button.tag == tag{
                    button.isSelected = true
                }else{
                    button.isSelected = false
                }
            }
        }
    }
    fileprivate func sp_updateLineLayout(btn  : UIButton){
        self.lineView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(btn.snp.left).offset(0)
            maker.width.equalTo(self.oneBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.height.equalTo(lineHeight)
        }
    }
    func sp_clickWhich(index : Int){
        sp_btnSelect(tag: index + SP_ORDERTOOL_TAG)
        let btn : UIButton? = self.viewWithTag(index + SP_ORDERTOOL_TAG) as?  UIButton
        if let b = btn{
            sp_updateLineLayout(btn: b)
        }
        sp_dealSelect(index: index)
    }
    fileprivate func sp_dealSelect(index : Int){
        guard let block  = self.selectBlock else {
            return
        }
        block(index)
    }
    func sp_getSelect()->Int{
        var index = 0
        for btn  in self.subviews {
            if btn is UIButton {
                let button : UIButton = btn as! UIButton
                if button.isSelected {
                    index = button.tag - SP_ORDERTOOL_TAG
                    break
                }
            }
        }
        return index
    }
    
}
