//
//  SPProductPriceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 价格
import Foundation
import UIKit
import SnapKit
class SPProductPriceView:  UIView{

    lazy var priceView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品价格"
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
        return view
    }()
    lazy var stockView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "商品库存"
        view.textFiled.keyboardType = UIKeyboardType.numberPad
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
        self.addSubview(self.priceView)
        self.addSubview(self.stockView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
        maker.top.equalTo(self.snp.top).offset(0)
            maker.height.equalTo(44)
        }
        self.stockView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.priceView).offset(0)
            maker.height.equalTo(self.priceView.snp.height).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
