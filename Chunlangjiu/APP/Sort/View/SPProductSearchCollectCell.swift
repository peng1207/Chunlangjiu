//
//  SPProductSearchCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/15.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductSearchCollectCell: UICollectionViewCell {
    
    fileprivate lazy var titleView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        view.sp_cornerRadius(cornerRadius: 13.5)
        return view
    }()
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.height.equalTo(27)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.contentView.snp.right).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(self.titleView).offset(0)
            maker.left.equalTo(self.titleView.snp.left).offset(9)
            maker.right.equalTo(self.titleView.snp.right).offset(-9)
        }
    }
    deinit {
        
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        var rect = self.titleLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 20 - 30, height: 27), limitedToNumberOfLines: 1)
        if rect.size.width < 74 {
            rect.size.width = 74
        }
        rect.size.height = 27
        attributes.frame = rect
        return attributes
    }
}
