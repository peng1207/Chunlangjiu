//
//  SPWineryListSectionHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/27.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryListSectionHeaderView : UITableViewHeaderFooterView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    fileprivate lazy var pullBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
   
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.pullBtn)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.pullBtn.snp.left).offset(-10)
        }
        self.pullBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView.snp.right).offset(-10)
            maker.centerY.equalTo(self.contentView).offset(0)
            maker.width.equalTo(17)
            maker.height.equalTo(9)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
