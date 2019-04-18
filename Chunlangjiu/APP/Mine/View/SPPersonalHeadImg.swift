//
//  SPPersonalHeadImg.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPersonalHeadImg:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "我的头像"
        return label
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 22)
        view.isUserInteractionEnabled = true
        view.image = sp_getLogoImg()
        return view
    }()
    fileprivate lazy var nextImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_rightBack")
        view.isUserInteractionEnabled = true
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var clickBlock : SPBtnClickBlock?
    var url : String?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.iconImgView.sp_cache(string: sp_getString(string: url), plImage: sp_getLogoImg())
    }
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.iconImgView)
        self.addSubview(self.nextImgView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(21)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(44)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.right.equalTo(self.nextImgView.snp.left).offset(-10)
        }
        self.nextImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.right.equalTo(self.snp.right).offset(-17)
            maker.width.equalTo(7)
            maker.height.equalTo(13)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
