//
//  SPIndexShowCityView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexShowCityView:  UIView{
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = sp_getFontSize(size: 14)
        label.textColor = UIColor.white
        label.text = sp_getString(string: SPAPPManager.instance().showCity)
        if sp_getString(string: label.text).count <= 0 {
            label.text = "选择城市"
        }
        return label
    }()
    fileprivate lazy var pullImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_pulldown")
        imageView.isUserInteractionEnabled = true
        return imageView
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
         
        self.addSubview(self.titleLabel)
        self.addSubview(self.pullImageView)
        self.sp_addConstraint()
    }
    func sp_setupData(){
        self.titleLabel.text = sp_getString(string: SPAPPManager.instance().showCity)
        if sp_getString(string: self.titleLabel.text).count <= 0 {
            self.titleLabel.text = "城市"
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
//        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.pullImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(5)
            maker.width.equalTo(14)
            maker.height.equalTo(7)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.right.lessThanOrEqualTo(self.snp.right).offset(-2)
        }
    }
    deinit {
        
    }
}
