//
//  SPLookPictureCollectCell.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/9/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPLookPictureCollectCell : UICollectionViewCell {
    lazy var imageView : UIImageView = {
        let view  = UIImageView()
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 创建UI
    fileprivate func sp_setupUI() {
        self.contentView.addSubview(self.imageView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker ) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
