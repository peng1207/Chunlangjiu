//
//  SPAuthHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/17.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAuthHeaderView:  UIView{
    
    fileprivate lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 25)
        return view
    }()
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.text = "立即实名认证享受更多特权服务"
        return label
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
        self.addSubview(self.logoImgView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.tipLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.logoImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(50)
            maker.left.equalTo(self).offset(30)
            maker.top.equalTo(self).offset(22)
        }
        self.nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.logoImgView.snp.right).offset(23)
            maker.top.equalTo(self).offset(32)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.snp.right).offset(-11)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.nameLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.nameLabel.snp.bottom).offset(10)
        }
    }
    deinit {
        
    }
}
