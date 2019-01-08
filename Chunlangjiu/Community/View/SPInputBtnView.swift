//
//  SPInputBtnView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPInputBtnView : UIView{
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
     lazy var textFiled : SPTextFiled = {
        let filed = SPTextFiled()
        return filed
    }()
    
     lazy var codeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("获取验证码", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPBtnClickBlock?
    var maxCount : Int = 60
    fileprivate var num : Int = 60
    fileprivate var timer : Timer?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.codeBtn)
        self.addSubview(self.textFiled)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.textFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(110)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.codeBtn.snp.left).offset(-11)
        }
        self.codeBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-15)
            maker.width.equalTo(71)
            maker.height.equalTo(24)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}

extension SPInputBtnView {
    @objc fileprivate func sp_clickDoneAction(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    ///  开始定时
    func sp_startTime(){
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sp_timeRun), userInfo: nil, repeats: true)
            self.num = self.maxCount
        }
        self.codeBtn.isEnabled = false
    }
    /// 停止定时
    func sp_stopTime(){
        if let t = self.timer {
            if t.isValid {
                t.invalidate()
            }
            self.timer = nil
        }
        self.codeBtn.isEnabled = true
    }
    /// 定时器执行中
    @objc fileprivate func sp_timeRun(){
        if self.num <= 0 {
            sp_stopTime()
            self.codeBtn.setTitle("获取验证码", for: UIControlState.normal)
        }else{
            self.num = self.num - 1
            self.codeBtn.setTitle("\(self.num)S", for: UIControlState.normal)
        }
        
    }
    
}
