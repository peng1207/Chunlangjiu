//
//  SPMineEditView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/10/24.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPMineEditBlock = (_ text : String)->Void

class SPMineEditView:  UIView{
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_remvoe))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "修改名称"
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        return label
    }()
    fileprivate lazy var msgLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.text = "可输入2-7个字的名称，包括特殊符号"
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var textFiled : SPTextFiled = {
        let filed = SPTextFiled()
        filed.font = sp_getFontSize(size: 16)
        filed.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: 1)
        filed.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        filed.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            sp_hideKeyboard()
        }, doneBlock: { [weak self] in
            self?.sp_clickDone()
        })
        return filed
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var editBlock : SPMineEditBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(title:String?,complete:SPMineEditBlock?){
        let view = SPMineEditView()
        view.editBlock = complete
        if sp_getString(string: title).count > 0 {
            view.titleLabel.text = sp_getString(string: title)
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(appDelegate.window!).offset(0)
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
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.msgLabel)
        self.contentView.addSubview(self.textFiled)
        self.contentView.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(40)
            maker.right.equalTo(self).offset(-40)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.contentView).offset(0)
        }
        self.msgLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(30)
            maker.right.equalTo(self.contentView).offset(-30)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        self.textFiled.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.msgLabel).offset(0)
            maker.top.equalTo(self.msgLabel.snp.bottom).offset(10)
            maker.height.equalTo(30)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(30)
            maker.centerX.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.textFiled.snp.bottom).offset(25)
            maker.bottom.equalTo(self.contentView).offset(-20)
        }
    }
    deinit {
        
    }
}
extension SPMineEditView {
    @objc fileprivate func sp_remvoe(){
         sp_hideKeyboard()
        self.removeFromSuperview()
    }
    @objc fileprivate func sp_clickDone(){
        guard sp_getString(string: self.textFiled.text).count > 0 else {
            sp_showTextAlert(tips: "请输入名称")
            return
        }
        guard let block = self.editBlock else {
            return
        }
        block(sp_getString(string: self.textFiled.text))
        sp_remvoe()
    }
    
    
}
