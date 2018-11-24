//
//  SPSortMainTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPSortMainTableCell: UITableViewCell {
    
    lazy var titleLabel : UILabel = {
        var label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 16)
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func labeIsSelect(select: Bool){
        if select {
            self.titleLabel.textColor =  SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        }else{
            self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            self.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
