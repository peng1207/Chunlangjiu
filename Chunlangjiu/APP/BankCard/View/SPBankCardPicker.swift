//
//  SPBankCardPicker.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/6.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPBankCarkPickerComplete = (_ pModel : SPAreaModel?, _ cModel : SPAreaModel?)->Void
class SPBankCardPicker:  UIView{
    fileprivate var pickerView : UIPickerView!
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var btnView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_000000.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var dataArray : [SPAreaModel]? {
        didSet{
            if sp_getArrayCount(array: dataArray) > 0 {
                let model = dataArray?.first
                self.cityArray = model?.children
            }
            self.pickerView.reloadAllComponents()
            
        }
    }
    fileprivate var cityArray : [SPAreaModel]?
    var selectBlock : SPBankCarkPickerComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.doneBtn)
        self.contentView.addSubview(self.canceBtn)
        self.pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.contentView.addSubview(pickerView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(0)
            }else{
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
extension SPBankCardPicker : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return sp_getArrayCount(array: self.dataArray)
        }else if component == 1 {
            return sp_getArrayCount(array: self.cityArray)
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row < sp_getArrayCount(array: self.dataArray) {
                let model = self.dataArray?[row]
                return sp_getString(string:model?.value)
            }
        }else if component == 1 {
            if row < sp_getArrayCount(array: self.cityArray){
                let model = self.cityArray?[row]
                return sp_getString(string:model?.value)
            }
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if row < sp_getArrayCount(array: self.dataArray) {
                let model = self.dataArray?[row]
                self.cityArray = model?.children
                self.pickerView.reloadComponent(1)
            }
        }
    }
}

extension SPBankCardPicker {
    @objc fileprivate func sp_clickCance(){
        sp_hidde()
    }
    @objc fileprivate func sp_clickDone(){
        guard let block = self.selectBlock else {
            return
        }
        var pModel : SPAreaModel?
        var cModel : SPAreaModel?
        if  sp_getArrayCount(array: self.dataArray) > 0 {
            let row = self.pickerView.selectedRow(inComponent: 0)
            if row < sp_getArrayCount(array: self.dataArray) {
                pModel = self.dataArray?[row]
            }
        }
        if sp_getArrayCount(array: self.cityArray) > 0  {
            let row = self.pickerView.selectedRow(inComponent: 1)
            if row < sp_getArrayCount(array: self.cityArray) {
                cModel = self.cityArray?[row]
            }
        }
        block(pModel,cModel)
        sp_hidde()
    }
    fileprivate func sp_hidde(){
        self.isHidden = true
    }
}
