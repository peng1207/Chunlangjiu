
//
//  SPIndexSectionDHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

let SPIndexSectionDHeaderView_Title_Height : CGFloat = 39

class SPIndexSectionDHeaderView:  UITableViewHeaderFooterView{
    lazy var imageView : UIImageView = {
        return UIImageView()
    }()
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        if SP_ISSHOW_AUCTION {
             label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_97a959.rawValue)
        }else{
             label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        }
        label.textAlignment = NSTextAlignment.center
        label.font = sp_getFontSize(size: 18)
        return label
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
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imageView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(SPIndexSectionDHeaderView_Title_Height)
        }
    }
    deinit {
        
    }
}
