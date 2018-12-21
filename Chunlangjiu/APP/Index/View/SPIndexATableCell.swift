//
//  SPIndexATableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SPIndexATableCell_Product_Width : CGFloat = 140

class SPIndexATableCell: UITableViewCell {
    lazy var auctionView : SPAuctionView = {
        return SPAuctionView()
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
        self.sp_setupData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.auctionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(self.contentView).offset(0)
        }
        
    }
    deinit {
        
    }
}
