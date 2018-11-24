//
//  SPKeyboardTopView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/19.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPKeyboardTopView:  UIView{
    
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickCanceAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("完成", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var canceBlock : (()->Void)?
    var doneBlock : (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_showView(canceBlock:(()->Void)?,doneBlock:(()->Void)?)->UIView{
        let view = SPKeyboardTopView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 40))
        view.canceBlock = canceBlock
        view.doneBlock = doneBlock
        view.backgroundColor = UIColor.white
        return view
    }
    @objc fileprivate func sp_clickDoneAction(){
        if let block = self.doneBlock{
            block()
        }
        sp_hideKeyboard()
    }
    @objc fileprivate func sp_clickCanceAction(){
        if let block = self.canceBlock {
            block()
        }
        sp_hideKeyboard()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.canceBtn)
        self.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(120)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(120)
        }
    }
    deinit {
        
    }
}

