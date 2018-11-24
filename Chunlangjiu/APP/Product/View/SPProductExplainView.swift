//
//  SPProductExplainView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 商品说明
import Foundation
import UIKit
import SnapKit
class SPProductExplainView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.text = "商品说明"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    lazy var textView : SPTextView = {
        let view = SPTextView()
        view.placeholderLabel.text = "请输入产品的销售说明"
        view.textView.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        view.textView.font = sp_getFontSize(size: 16)
        return view
    }()
    
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
        self.addSubview(self.textView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.top.equalTo(self.snp.top).offset(15)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.textView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(16)
            maker.top.equalTo(self.titleLabel.snp.top).offset(-5)
            maker.height.equalTo(58)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
