//
//  SPConditionFilterCell.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConditionFilterCell : UICollectionViewCell{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    
    override init(frame: CGRect) {
    super.init(frame: frame)
        sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView).offset(-11)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.height.equalTo(18)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.width.equalTo(5)
        }
    }
}
