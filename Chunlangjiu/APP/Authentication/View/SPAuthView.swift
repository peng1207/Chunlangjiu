//
//  SPAuthView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/17.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPAuthView:  UIView{
     lazy var imgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        return label
    }()
    lazy var applyBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("申请", for: UIControlState.normal)
        btn.setTitle("已认证", for: UIControlState.disabled)
  
        btn.setBackgroundImage(UIImage.sp_getImageWithColor(color:  SPColorForHexString(hex: SP_HexColor.color_189cdd.rawValue)), for: UIControlState.normal)
         btn.setBackgroundImage(UIImage.sp_getImageWithColor(color:  SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)), for: UIControlState.disabled)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.addTarget(self, action: #selector(sp_clickApply), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.imgView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.applyBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self).offset(19)
            maker.width.equalTo(47)
            maker.height.equalTo(47)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(5)
            maker.right.equalTo(self.snp.right).offset(-5)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.imgView.snp.bottom).offset(16)
        }
        self.applyBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.height.equalTo(25)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(11)
        }
        
    }
    deinit {
        
    }
}
extension SPAuthView {
    @objc fileprivate func sp_clickApply(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
}
