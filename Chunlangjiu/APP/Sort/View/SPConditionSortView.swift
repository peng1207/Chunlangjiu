//
//  SPConditionSortView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/25.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConditionSortView: UICollectionViewCell {
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    var isSelect : Bool = false {
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        if  isSelect {
            self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        }else{
            self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(0)
            maker.height.equalTo(40)
            maker.right.equalTo(self.titleLabel.snp.right).offset(6)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView.snp.left).offset(11)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
//            maker.right.equalTo(self.contentView).offset(-6)
        }
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = self.contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var cellframe = layoutAttributes.frame
        cellframe.size.width = size.width
        layoutAttributes.frame = cellframe
        return layoutAttributes
    }
}
