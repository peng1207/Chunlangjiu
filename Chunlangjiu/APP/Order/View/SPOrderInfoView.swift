//
//  SPOrderInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/11/1.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderInfoView:  UIView{
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    var content : String? {
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var topConstraint : Constraint!
    fileprivate var bottomConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.titleLabel.text = sp_getString(string: content)
        let haveData = sp_getString(string: content).count > 0 ? true : false
        self.topConstraint.update(offset: haveData ? 10 : 0 )
        self.bottomConstraint.update(offset: haveData ? -10 : 0)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.lineView)
        self.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.right.equalTo(self).offset(-11)
             self.topConstraint = maker.top.equalTo(self.snp.top).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
          
           self.bottomConstraint =  maker.bottom.equalTo(self.snp.bottom).offset(-10).constraint
        }
    }
    deinit {
        
    }
}
