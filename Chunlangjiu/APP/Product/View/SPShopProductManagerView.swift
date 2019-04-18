//
//  SPShopProductManagerView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopProductManagerView:  UIView{
    lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        return view
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        return label
    }()
    lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    fileprivate var titleTop : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_updateTitle(top:CGFloat){
        self.titleTop.update(offset: top)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.iconImgView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.numLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
            maker.right.equalTo(self.titleLabel.snp.left).offset(-4)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
            self.titleTop = maker.top.equalTo(self.snp.top).offset(39).constraint
            maker.left.equalTo(self.snp.centerX).offset(-10)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
    }
    deinit {
        
    }
}
