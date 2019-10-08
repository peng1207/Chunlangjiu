//
//  SPSearchView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 获取数据回调
typealias SPGetSearchBlock = (_ text : String?)->Void
typealias SPTextDidClickBlock = ()->Bool

class SPSearchView:  UIView{
    lazy var searchTextFiled : SPTextFiled = {
        let textFiled = SPTextFiled()
        textFiled.font = sp_getFontSize(size: 14)
        textFiled.placeholder = "请输入商品关键字"
        textFiled.backgroundColor = UIColor.white
        textFiled.clearButtonMode = UITextFieldViewMode.whileEditing
        textFiled.sp_cornerRadius(cornerRadius: 15)
        textFiled.delegate = self
        textFiled.returnKeyType = UIReturnKeyType.search
        textFiled.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        textFiled.attributedPlaceholder = NSAttributedString(string: "请输入商品关键字", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)])
        textFiled.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {

        }, doneBlock: { [weak self]in
            self?.sp_dealComplete()
        })
        return textFiled
    }()
    
    fileprivate lazy var searchView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return view
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setImage( UIImage(named: "public_search_gray"), for: UIControlState.normal)
        return btn
    }()
    
    var searchBlock : SPGetSearchBlock?
    var didClickBlock : SPTextDidClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize{
        get{
            return UILayoutFittingExpandedSize
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.searchTextFiled)
        self.searchTextFiled.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.searchView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.searchTextFiled.leftView = self.searchView
       
        self.searchTextFiled.leftViewMode = UITextFieldViewMode.always
        
        self.searchView.addSubview(self.searchBtn)
        self.searchBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.searchView).offset(5)
            maker.right.equalTo(self.searchView).offset(-5)
            maker.top.bottom.equalTo(self.searchView).offset(0)
        }
 
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
 
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchTextFiled.frame = CGRect(x: 0, y: (self.frame.size.height - self.searchTextFiled.frame.size.height) / 2.0, width: self.searchTextFiled.frame.size.width, height: self.searchTextFiled.frame.size.height)
    }
    deinit {
        
    }
}
extension SPSearchView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sp_dealComplete()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let block = self.didClickBlock {
            return block()
        }
        return true
    }
}
extension SPSearchView {
    fileprivate func sp_dealComplete(){
        guard let block = self.searchBlock else {
            sp_hideKeyboard()
            return
        }
        block( sp_getString(string: self.searchTextFiled.text))
        if sp_getString(string: self.searchTextFiled.text).count > 0 {
            sp_hideKeyboard()
        }
        
    }
}
