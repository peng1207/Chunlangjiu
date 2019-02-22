//
//  SPProductAuctionCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/20.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductAuctionCollectCell: UICollectionViewCell {
    lazy var auctionView : SPAuctionView = {
        let view = SPAuctionView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.auctionView)
        self.sp_addConstraint()
        self.auctionView.sp_cornerRadius(cornerRadius: 5)
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(175)
        }
    }
    deinit {
        
    }
}
