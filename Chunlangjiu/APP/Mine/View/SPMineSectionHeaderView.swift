//
//  SPMineSectionHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineSectionHeaderView:  UICollectionReusableView{
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    lazy var nextImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_rightBack")
        imageView.isUserInteractionEnabled = true
        return imageView
        
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   @objc fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_dealComplete))
        self.addGestureRecognizer(tap)
        self.addSubview(self.titleLabel)
        self.addSubview(self.nextImageView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(9)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(-9)
        }
        self.nextImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
