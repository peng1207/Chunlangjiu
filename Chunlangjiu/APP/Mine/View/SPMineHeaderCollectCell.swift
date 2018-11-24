//
//  SPMineHeaderCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/14.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPMineHeaderCollectCell: UICollectionViewCell {
    
     lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 18)
        label.textColor = UIColor.white
        return label
    }()
    fileprivate lazy var desLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 10)
        label.textColor = UIColor.white
        return label
    
    }()

    lazy var lineView : UIView = {
        let view = UIView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue) 
        return view
    }()
    var model : SPMineHeadModel?{
        didSet{
            sp_setupData()
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
     
        self.desLabel.text = sp_getString(string: self.model?.des)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        self.sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.desLabel)
        self.contentView.addSubview(self.desLabel)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
        self.desLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.lineView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.desLabel.snp.bottom).offset(6)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(0)
            maker.width.equalTo(sp_lineHeight)
            maker.height.equalTo(36)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
