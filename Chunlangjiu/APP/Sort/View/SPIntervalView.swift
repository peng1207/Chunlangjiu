//
//  SPIntervalView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPIntervalValueBlock = (_ minText : String? ,_ maxText :String?)-> Void

class SPIntervalView:  UIView{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var maxTextField : SPTextFiled = {
        let textField = SPTextFiled()
        textField.textAlignment = NSTextAlignment.center
        textField.sp_cornerRadius(cornerRadius: 13.5)
        textField.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            self.sp_dealComplete()
        })
        textField.addTarget(self, action: #selector(sp_textField1TextChange), for: UIControlEvents.editingChanged)
        return textField
    }()
    lazy var minTextField : SPTextFiled = {
        let textField = SPTextFiled()
        textField.textAlignment = NSTextAlignment.center
        textField.sp_cornerRadius(cornerRadius: 13.5)
        textField.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = UIKeyboardType.numberPad
        textField.delegate = self
        textField.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {[weak self]in
            self?.sp_dealComplete()
        })
        textField.addTarget(self, action: #selector(sp_textField1TextChange), for: UIControlEvents.editingChanged)
        return textField
    }()
    lazy var midLabel : UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var valueBlock : SPIntervalValueBlock?
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
        self.addSubview(self.lineView)
        self.addSubview(self.maxTextField)
        self.addSubview(self.minTextField)
        self.addSubview(self.midLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(12)
            maker.height.equalTo(44)
            maker.right.equalTo(self.snp.right).offset(10)
            maker.top.equalTo(self).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
        self.minTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(8)
            maker.height.equalTo(27)
            maker.width.equalTo(self.maxTextField.snp.width).offset(0)
        }
        self.midLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.midLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.minTextField.snp.right).offset(10)
            maker.centerY.equalTo(self.minTextField.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.maxTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.midLabel.snp.right).offset(12)
            maker.top.equalTo(self.minTextField.snp.top).offset(0)
            maker.height.equalTo(self.minTextField.snp.height).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPIntervalView : UITextFieldDelegate{
    fileprivate func sp_dealComplete(){
        guard let block = self.valueBlock else {
            return
        }
        block(self.minTextField.text,self.maxTextField.text)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sp_dealComplete()
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - action
extension SPIntervalView {
   @objc fileprivate func  sp_textField1TextChange(){
        sp_dealComplete()
    }
}

