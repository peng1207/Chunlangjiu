//
//  SPTextView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/17.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPTextView:  UIView{
    
    lazy var textView : UITextView = {
        let view = UITextView()
          view.tintColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        view.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
 
        return view;
    }()
    lazy var placeholderLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.font = sp_getFontSize(size: 11)
        label.numberOfLines = 0
        return label
    }()
    fileprivate var heightConstraint : Constraint!
    var minHeight : CGFloat = 30 {
        didSet{
            self.heightConstraint.update(offset: minHeight)
        }
    }
    var content : String?{
        set{
            self.textView.text = sp_getString(string: newValue)
            self.sp_textViewChange()
        }
        get{
            return  sp_getString(string: self.textView.text)
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
        self.addSubview(self.textView)
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.preferredMaxLayoutWidth = sp_getScreenWidth()
        self.sp_addConstraint()
 
        NotificationCenter.default.addObserver(self, selector: #selector(sp_textViewChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
          NotificationCenter.default.addObserver(self, selector: #selector(sp_textDidBenin), name:  NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.textView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            self.heightConstraint =  maker.height.equalTo(30).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.placeholderLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(3)
            maker.right.equalTo(self).offset(-3)
            maker.top.equalTo(self).offset(8)
            maker.height.greaterThanOrEqualTo(0)
            
            
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
fileprivate extension SPTextView{
    @objc fileprivate func sp_textViewChange(){
        if self.textView.text.count > 0  {
            self.placeholderLabel.isHidden = true
        }else{
            self.placeholderLabel.isHidden = false
        }
        let frame = textView.frame
        let constrainSize = CGSize(width: frame.size.width, height: frame.size.height)
        var size = textView.sizeThatFits(constrainSize)
        if size.height < minHeight {
            size.height = minHeight
        }
        self.heightConstraint.update(offset: size.height)
        
    }
    @objc fileprivate func sp_textDidBenin(){
//        self.placeholderLabel.isHidden = true
    }
    
}
