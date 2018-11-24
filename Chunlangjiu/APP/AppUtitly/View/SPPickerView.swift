//
//  SPPickerView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPPickerSelectComplete = (_ isSuccess : Bool , _ selectString : String?,_ index : Int)->Void

class SPPickerView:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var hideView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickCance))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var pickerView : UIPickerView = {
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 18)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var dataArray : [String]?{
        didSet{
            self.pickerView.reloadAllComponents()
        }
    }
    var selectBlock : SPPickerSelectComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func sp_show(data : [String]?,select : Int = 0,complete :SPPickerSelectComplete?){
        let view = SPPickerView()
        view.dataArray = data
        view.selectBlock = complete
        let appDeletaget : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDeletaget.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(appDeletaget.window!).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo((appDeletaget.window?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
            } else {
                   maker.bottom.equalTo((appDeletaget.window?.snp.bottom)!).offset(0)
            }
        }
        if select < sp_getArrayCount(array: data) {
            view.pickerView.selectRow(select, inComponent: 0, animated: true)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.hideView)
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.contentView.addSubview(self.pickerView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.hideView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
            maker.width.equalTo(80)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.top.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(40)
            maker.width.equalTo(80)
        }
        self.pickerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.canceBtn.snp.bottom).offset(0)
            maker.height.equalTo(216)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPPickerView : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < sp_getArrayCount(array: self.dataArray) {
             return sp_getString(string:self.dataArray?[row])
        }
       return nil
    }
}
extension SPPickerView {
    @objc fileprivate func sp_clickCance(){
        sp_dealComplete(isSuccess: false, select: nil,index: 0)
        sp_hiddenView()
    }
    @objc fileprivate func sp_clickDone(){
        if sp_getArrayCount(array: self.dataArray) > 0  {
            let row =  self.pickerView.selectedRow(inComponent: 0)
            if row < sp_getArrayCount(array: self.dataArray){
                sp_dealComplete(isSuccess: true, select: self.dataArray?[row],index: row)
            }
        }
        self.sp_hiddenView()
    }
    fileprivate func sp_hiddenView(){
       self.removeFromSuperview()
    }
    fileprivate func sp_dealComplete(isSuccess : Bool , select : String?,index : Int){
        guard let block = self.selectBlock else {
            return
        }
        block(isSuccess,select,index)
    }
    
}
