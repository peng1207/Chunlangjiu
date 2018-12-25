//
//  SPTextLabelView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPTextLabelView:  UIView{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate var conentLeft : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_updateLeft(left : CGFloat){
        self.conentLeft.update(offset: left)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.contentLabel.snp.left).offset(-10)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            self.conentLeft = maker.left.equalTo(self).offset(105).constraint
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(-11)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
