//
//  SPActivityHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPActivityHeaderView:  UIView{
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
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
        self.addSubview(self.imgView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.imgView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
