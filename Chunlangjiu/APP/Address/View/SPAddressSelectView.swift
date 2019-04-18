//
//  SPAddressSelectView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/18.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAddressSelectView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
     lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    
    lazy var nextImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "public_rightBack")
        return imageView
    }()
    var placeholder : String?{
        didSet{
            self.sp_dealConetent()
        }
    }
    var content : String?{
        didSet{
             self.sp_dealConetent()
        }
    }
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var selectBlock : SPBtnClickBlock?
     fileprivate var titleLeftConstraint : Constraint!
      fileprivate var contentLeftConstraint : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_updateTitleLeft(left : CGFloat){
        self.titleLeftConstraint.update(offset: left)
         self.contentLeftConstraint.update(offset: left + 100)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.nextImageView)
        self.addSubview(self.lineView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTapAction))
        self.addGestureRecognizer(tap)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            self.titleLeftConstraint = maker.left.equalTo(self.snp.left).offset(10).constraint
            maker.top.equalTo(self.contentLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.contentLabel.snp.left).offset(-9)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
          self.contentLeftConstraint = maker.left.equalTo(self.snp.left).offset(110).constraint
            maker.top.equalTo(self.snp.top).offset(15)
            maker.right.equalTo(self.nextImageView.snp.left).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-15)
        }
        self.nextImageView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(15)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
fileprivate extension  SPAddressSelectView {
    /// 点击回调
    @objc fileprivate func sp_clickTapAction(){
        guard let block = self.selectBlock else {
            return
        }
        block()
    }
    fileprivate func sp_dealConetent(){
        if sp_getString(string: self.content).count > 0 {
            self.contentLabel.text = sp_getString(string: self.content)
            self.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            self.contentLabel.font = sp_getFontSize(size: 16)
        }else{
            self.contentLabel.text = sp_getString(string: self.placeholder)
            self.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
            self.contentLabel.font = sp_getFontSize(size: 13)
        }
        
    }
}
