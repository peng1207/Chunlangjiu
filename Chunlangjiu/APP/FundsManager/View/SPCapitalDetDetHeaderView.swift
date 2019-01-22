//
//  SPCapitalDetDetHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPCapitalDetDetHeaderView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "交易金额"
        return label
    }()
    lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 30)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
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
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(10)
            maker.height.equalTo(100)
            maker.bottom.equalTo(self.snp.bottom).offset(-10)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.right.equalTo(self.contentView).offset(-11)
            maker.top.equalTo(self.contentView).offset(22)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.contentView.snp.bottom).offset(10)
            maker.height.equalTo(sp_lineHeight)
        }
        
    }
    deinit {
        
    }
}
