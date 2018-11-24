//
//  SPWineryDetaileBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryDetaileBtnView:  UIView{
    
    fileprivate lazy var introductionBtn : UIButton = {
        let btn = sp_createBtn(title: "名庄简介", action: #selector(sp_clickIntroductionAction))
        btn.isSelected = true
        return btn
    }()
    fileprivate lazy var detaileInfoBtn : UIButton = {
        return sp_createBtn(title: "详细介绍", action: #selector(sp_clickDetaileInfoAction))
    }()
    fileprivate lazy var scoreBtn : UIButton = {
        return sp_createBtn(title: "历年评分", action: #selector(sp_clickScoreAction))
    }()
    fileprivate lazy var pictureBtn : UIButton = {
        return sp_createBtn(title: "酒庄图片", action: #selector(sp_clickPictureAction))
    }()
    fileprivate lazy var redLineView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var btnClickBlock : SPBtnIndexClickBlock?
    fileprivate func sp_createBtn(title:String,action:Selector) -> UIButton {
        let btn  = UIButton(type: UIButtonType.custom)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitle(title, for: UIControlState.normal)
        btn.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        return btn
    }
//    fileprivate var lineLeft
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.introductionBtn)
        self.addSubview(self.detaileInfoBtn)
        self.addSubview(self.scoreBtn)
        self.addSubview(self.pictureBtn)
        self.addSubview(self.lineView)
        self.addSubview(self.redLineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.introductionBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.detaileInfoBtn.snp.width).offset(0)
        }
        self.detaileInfoBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.introductionBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.scoreBtn.snp.width).offset(0)
        }
        self.scoreBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileInfoBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.pictureBtn.snp.width).offset(0)
        }
        self.pictureBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scoreBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.redLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.introductionBtn.snp.left).offset(0)
            maker.width.equalTo(self.detaileInfoBtn.snp.width).offset(0)
            maker.height.equalTo(sp_heightOfScale(height: 2))
            maker.bottom.equalTo(self).offset(0)
        }
    }
    fileprivate func sp_updateRedLineLayout(){
        self.redLineView.layoutIfNeeded()
        self.redLineView.snp.remakeConstraints { (maker) in
            if self.introductionBtn.isSelected {
                 maker.left.equalTo(self.introductionBtn.snp.left).offset(0)
            }else if self.detaileInfoBtn.isSelected {
                  maker.left.equalTo(self.detaileInfoBtn.snp.left).offset(0)
            }else if self.scoreBtn.isSelected {
                  maker.left.equalTo(self.scoreBtn.snp.left).offset(0)
            }else if self.pictureBtn.isSelected {
                  maker.left.equalTo(self.pictureBtn.snp.left).offset(0)
            }
            maker.width.equalTo(self.detaileInfoBtn.snp.width).offset(0)
            maker.height.equalTo(sp_heightOfScale(height: 2))
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPWineryDetaileBtnView {
    /// 点击名庄简介
    @objc fileprivate func sp_clickIntroductionAction(){
        self.sp_dealBtnSelect(index: 0)
        self.sp_dealClickComplete(index: 0)
    }
    /// 点击详细介绍
    @objc fileprivate func sp_clickDetaileInfoAction(){
        self.sp_dealBtnSelect(index: 1)
        self.sp_dealClickComplete(index: 1)
    }
    /// 点击历年评分
    @objc fileprivate func sp_clickScoreAction(){
        self.sp_dealBtnSelect(index: 2)
        self.sp_dealClickComplete(index: 2)
    }
    /// 点击酒庄图片
    @objc fileprivate func sp_clickPictureAction(){
        self.sp_dealBtnSelect(index: 3)
        self.sp_dealClickComplete(index: 3)
      
    }
    ///  处理按钮的选择
    ///
    /// - Parameter index: 第几个按钮选择
    func sp_dealBtnSelect(index : Int){
        self.introductionBtn.isSelected = false
        self.detaileInfoBtn.isSelected = false
        self.scoreBtn.isSelected = false
        self.pictureBtn.isSelected = false
        if index == 0 {
            self.introductionBtn.isSelected = true
        }else if index == 1 {
            self.detaileInfoBtn.isSelected = true
        }else if index == 2{
            self.scoreBtn.isSelected = true
        }else if index == 3 {
            self.pictureBtn.isSelected = true
        }
          self.sp_updateRedLineLayout()
    }
    /// 处理点击按钮的回调
    ///
    /// - Parameter index: <#index description#>
    fileprivate func sp_dealClickComplete(index : Int){
        guard let block = self.btnClickBlock else {
            return
        }
        block(index)
    }
    
}
