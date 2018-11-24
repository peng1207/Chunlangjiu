//
//  SPNumView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
/// 点击减
let SP_NUM_CLICK_MINU = 0
/// 点击加
let SP_NUM_CLICK_ADD = 1
/// 输入数字改变回调 type 0 点击 减 1 加
typealias SPNumComplete = (_ type : Int,_ num : String)->Void

class SPNumView:  UIView{
    lazy var minuBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_minus_gray"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickMinuAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var addBtn : UIButton = {
       let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_add_red"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickAddAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textAlignment = NSTextAlignment.center
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    var numBlock : SPNumComplete?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.minuBtn)
        self.addSubview(self.numLabel)
        self.addSubview(self.addBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.minuBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(4)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.centerY.equalTo(self.snp.centerY)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self).offset(0)
            maker.left.equalTo(self.minuBtn.snp.right).offset(4)
            maker.width.equalTo(30)
        }
        self.addBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.numLabel.snp.right).offset(4)
            maker.width.equalTo(self.minuBtn.snp.width).offset(0)
            maker.height.equalTo(self.minuBtn.snp.height).offset(0)
            maker.centerY.equalTo(self.minuBtn.snp.centerY).offset(0)
            maker.right.equalTo(self.snp.right).offset(-4)
        }
    }
    deinit {
        
    }
}

extension SPNumView {
    @objc fileprivate func sp_clickAddAction(){
        let numText = sp_getString(string: self.numLabel.text)
        var num = Int(numText)
        num = num! + 1
       
        self.numLabel.text = sp_getString(string:  num?.description)
        sp_dealNumComplete(type: SP_NUM_CLICK_ADD)
    }
    @objc fileprivate func sp_clickMinuAction(){
        let numText = sp_getString(string: self.numLabel.text)
 
        var num = Int(numText)
        num = num! - 1
        if num! < 1  {
            num = 1
        }
        self.numLabel.text =  sp_getString(string:  num?.description)
        sp_dealNumComplete(type: SP_NUM_CLICK_MINU)
    }
    fileprivate func sp_dealNumComplete(type:Int){
        guard let block = self.numBlock  else {
            return
        }
        block(type,sp_getString(string: self.numLabel.text))
    }
}
