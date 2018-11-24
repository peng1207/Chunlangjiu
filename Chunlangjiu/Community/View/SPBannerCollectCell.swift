//
//  SPBannerCollectCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPBannerCollectCell: UICollectionViewCell {
    
    lazy var bannerImageView : UIImageView = {
        return UIImageView()
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
        self.contentView.addSubview(self.bannerImageView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.bannerImageView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
