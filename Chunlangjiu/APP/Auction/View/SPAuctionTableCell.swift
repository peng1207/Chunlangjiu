//
//  SPAuctionTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/7.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SP_AUCTION_PRODUCT_WIDTH :  CGFloat = 140
class SPAuctionTableCell: UITableViewCell {
    lazy var auctionView : SPAuctionView = {
        return SPAuctionView()
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.auctionView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self.contentView).offset(0)
        }
        self.auctionView.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.auctionView.snp.left).offset(10)
            maker.width.equalTo(SP_AUCTION_PRODUCT_WIDTH)
            maker.height.equalTo(self.auctionView.productImageView.snp.width).multipliedBy(SP_PRODUCT_SCALE)
        maker.top.equalTo(self.auctionView.snp.top).offset(15)
        }
    }
    deinit {
        
    }
}
