//
//  SPProductNumView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/25.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPProductNumBlock  = (_ text:String)->Void
class SPProductNumView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "购买数量"
        return label
    }()
    fileprivate lazy var numView : SPNumView = {
        let view = SPNumView()
        return view
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDoneAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var clickBlock : SPProductNumBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(num:String = "1",complete:SPProductNumBlock?){
        let view = SPProductNumView()
        view.numView.numLabel.text = num
        view.clickBlock = complete
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.5)
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(appDelegate.window!).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo((appDelegate.window?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
            } else {
                // Fallback on earlier versions
                   maker.bottom.equalTo((appDelegate.window?.snp.bottom)!).offset(0)
            }
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.numView)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.top.equalTo(self.contentView).offset(16)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.equalTo(30)
        }
        self.numView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.top.equalTo(self.titleLabel.snp.top).offset(0)
            maker.height.equalTo(30)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(30)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPProductNumView {
    
    @objc fileprivate func sp_clickDoneAction(){
        sp_dealComplete()
        sp_remove()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block(sp_getString(string: self.numView.numLabel.text))
    }
    @objc fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        
        let point = touch.location(in:self)     //获取当前点击位置
        if point.y < self.contentView.frame.origin.y {
            sp_remove()
        }else{
              super.touchesBegan(touches, with: event)
        }
    }
}
