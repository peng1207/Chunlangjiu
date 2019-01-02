//
//  SPCommissionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/1.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCommissionView:  UIView{
    
    fileprivate lazy var pCommissionView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "平台佣金"
        return view
    }()
    fileprivate lazy var sPayView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "商家实收"
        view.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
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
        self.addSubview(self.pCommissionView)
        self.addSubview(self.sPayView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.pCommissionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(40)
        }
        self.sPayView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.pCommissionView).offset(0)
            maker.top.equalTo(self.pCommissionView.snp.bottom).offset(0)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
