//
//  SPOrderReasonView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/28.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderReasonView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = sp_getScreenWidth() - 94
        return label
    }()
    var content : String? {
        didSet{
            self.sp_setupData()
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
        self.contentLabel.text = sp_getString(string: contentLabel)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
 
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(11)
            maker.top.equalTo(self.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.equalTo(72)
        }
 
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(0)
            maker.right.equalTo(self.snp.right).offset(-11)
            maker.top.equalTo(self.titleLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
