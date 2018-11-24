//
//  SPDatePicker.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/17.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPDateComplete = (_ date : Date)->Void

class SPDatePicker:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var datePicker : UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.maximumDate = Date()
        return view
    }()
    fileprivate var complete : SPDateComplete?
    class func sp_show(datePickerMode : UIDatePicker.Mode = UIDatePicker.Mode.date , minDate : Date? = nil,maxDate : Date? = nil,complete : SPDateComplete?){
        let view = SPDatePicker()
        view.datePicker.datePickerMode = datePickerMode
        view.datePicker.minimumDate = minDate
        view.datePicker.maximumDate = maxDate
        view.complete = complete
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue).withAlphaComponent(0.3)
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(appDelegate.window!).offset(0)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.contentView.addSubview(self.datePicker)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                  maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
          
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
            maker.width.equalTo(80)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.top.equalTo(self.contentView).offset(0)
            maker.width.height.equalTo(self.canceBtn).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.canceBtn.snp.bottom).offset(0)
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.datePicker.snp.makeConstraints { (maker ) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            maker.height.equalTo(216)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPDatePicker{
    @objc fileprivate func sp_clickCance(){
        sp_remove()
    }
    @objc fileprivate func sp_clickDone(){
        sp_dealComplete()
        sp_remove()
    }
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    fileprivate func sp_dealComplete(){
        sp_log(message: self.datePicker.date)
        guard let block = self.complete else {
            return
        }
        block(self.datePicker.date)
    }
}
