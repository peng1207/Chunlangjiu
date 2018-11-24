//
//  SPOrderEvaluationView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/1.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

private let SP_Evaluation_Start_Tag    =   1000

class SPOrderEvaluationView:  UIView{
    fileprivate lazy var oneBtn : UIButton = {
      return sp_createbtn(tag: SP_Evaluation_Start_Tag)
    }()
    fileprivate lazy var twoBtn : UIButton = {
        return sp_createbtn(tag: SP_Evaluation_Start_Tag + 1)
    }()
    fileprivate lazy var threeBtn : UIButton = {
        return sp_createbtn(tag: SP_Evaluation_Start_Tag + 2 )
    }()
    fileprivate lazy var fourBtn : UIButton = {
        return sp_createbtn(tag: SP_Evaluation_Start_Tag + 3)
    }()
    fileprivate lazy var fifeBtn : UIButton = {
        return sp_createbtn(tag: SP_Evaluation_Start_Tag + 4)
    }()
    private func sp_createbtn(tag : Int)-> UIButton{
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_star_g"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_star_y"), for: UIControlState.selected)
        btn.tag = tag
        btn.isSelected = true
        btn.addTarget(self, action: #selector(sp_clickBtnAction(btn:)), for: UIControlEvents.touchUpInside)
        return btn
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 获取选择的数量
    ///
    /// - Returns: 数量
    func sp_getSelect()-> Int{
        var count : Int = 0
        if self.oneBtn.isSelected {
            count = count + 1
        }
        if  self.twoBtn.isSelected {
            count = count + 1
        }
        if self.threeBtn.isSelected {
            count = count + 1
        }
        if self.fourBtn.isSelected {
            count = count + 1
        }
        if self.fifeBtn.isSelected {
            count = count + 1
        }
        return count
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       
        self.addSubview(self.oneBtn)
        self.addSubview(self.twoBtn)
        self.addSubview(self.threeBtn)
        self.addSubview(self.fourBtn)
        self.addSubview(self.fifeBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
      
        self.oneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(8)
            maker.top.equalTo(self.snp.top).offset(18)
            maker.width.height.equalTo(27)
        }
        self.twoBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.oneBtn.snp.right).offset(17)
            maker.top.width.height.equalTo(self.oneBtn).offset(0)
        }
        self.threeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.twoBtn.snp.right).offset(17)
            maker.top.width.height.equalTo(self.oneBtn).offset(0)
        }
        self.fourBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.threeBtn.snp.right).offset(17)
            maker.width.height.top.equalTo(self.oneBtn).offset(0)
        }
        self.fifeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.fourBtn.snp.right).offset(17)
            maker.top.width.height.equalTo(self.oneBtn).offset(0)
        }
        
    }
    deinit {
        
    }
}

extension SPOrderEvaluationView {
    @objc fileprivate func sp_clickBtnAction(btn : UIButton){
        
        for i in 0...4 {
            let sender : UIButton = self.viewWithTag(i + SP_Evaluation_Start_Tag) as! UIButton
            if sender.tag <= btn.tag {
                sender.isSelected = true
            }else{
                sender.isSelected = false
            }
        }
    }
    
}
