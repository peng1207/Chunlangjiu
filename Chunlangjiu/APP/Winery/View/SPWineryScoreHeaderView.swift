//
//  SPWineryScoreHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryScoreHeaderView : UIView{
    fileprivate lazy var yearLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "年份"
        return label
    }()
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var rpLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "RP评分"
        return label
    }()
    fileprivate lazy var wsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
         label.text = "WS评分"
        return label
    }()
    fileprivate lazy var jrLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
         label.text = "JR评分"
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
        self.addSubview(self.yearLabel)
        self.addSubview(self.iconImageView)
        self.addSubview(self.rpLabel)
        self.addSubview(self.wsLabel)
        self.addSubview(self.jrLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.yearLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(17)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(60)
        }
        self.iconImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.yearLabel.snp.right).offset(15)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.equalTo(0)
            maker.height.equalTo(0)
        }
        self.rpLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImageView.snp.right).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.wsLabel.snp.width).offset(0)
        }
        self.wsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.rpLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.jrLabel.snp.width).offset(0)
        }
        self.jrLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.wsLabel.snp.right).offset(5)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
