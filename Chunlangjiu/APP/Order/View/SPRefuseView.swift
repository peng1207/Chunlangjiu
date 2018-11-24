//
//  SPRefuseView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/16.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPRefuseComplete = (_ reason : String?)->Void
class SPRefuseView:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "拒绝理由"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var reasonView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "拒绝理由"
        view.textFiled.placeholder = "请输入"
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var complete : SPRefuseComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(title:String,msg: String,isNum : Bool = false,  complete:SPRefuseComplete?){
        let view = SPRefuseView()
        view.complete = complete
        view.titleLabel.text = sp_getString(string: title)
        view.reasonView.titleLabel.text = sp_getString(string: msg)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        if isNum {
            view.reasonView.textFiled.keyboardType = .decimalPad
        }
        let appDelegete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegete.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(appDelegete.window!).offset(0)
        }
        
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.reasonView)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-20)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
            maker.height.equalTo(40)
            maker.top.equalTo(self.contentView).offset(0)
        }
        self.reasonView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
            maker.height.equalTo(44)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.reasonView.snp.bottom).offset(20)
            maker.width.equalTo(self.doneBtn).offset(0)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(0)
            maker.top.height.equalTo(self.canceBtn).offset(0)
            maker.right.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
// MARK: - action
extension SPRefuseView {
    
    @objc fileprivate func sp_clickCance(){
        sp_remove()
    }
    @objc fileprivate func sp_clickDone(){
        guard sp_getString(string: self.reasonView.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入拒绝理由")
            return
        }
        sp_dealComplete()
        sp_remove()
    }
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.complete else {
            return
        }
        block(self.reasonView.textFiled.text)
    }
    
}
