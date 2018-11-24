//
//  SPProductTipsView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductTipsView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "说明"
        label.isHidden = true
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        return label
    }()
    var content : String?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 赋值
    fileprivate func sp_setupData(){
        self.contentLabel.text = sp_getString(string: self.content)
        sp_deal(haveData: sp_getString(string: self.content).count > 0 ? true : false)
    }
    fileprivate func sp_deal(haveData:Bool){
        self.titleLabel.isHidden = !haveData
        self.titleLabel.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            if haveData{
                maker.top.equalTo(self.snp.top).offset(15)
                maker.height.greaterThanOrEqualTo(0)
            }else{
                maker.top.equalTo(self.snp.top).offset(0)
                maker.height.equalTo(0)
            }
        }
        self.contentLabel.snp.remakeConstraints { (maker) in
            if haveData {
                 maker.height.greaterThanOrEqualTo(0)
                  maker.bottom.equalTo(self.snp.bottom).offset(-10)
            }else{
                maker.height.equalTo(0)
                maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
            maker.left.equalTo(self.titleLabel.snp.right).offset(19)
            maker.top.equalTo(self.titleLabel.snp.top).offset(0)
            maker.right.equalTo(self.snp.right).offset(-10)
           
          
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
       sp_deal(haveData: false)
    }
    deinit {
        
    }
}
