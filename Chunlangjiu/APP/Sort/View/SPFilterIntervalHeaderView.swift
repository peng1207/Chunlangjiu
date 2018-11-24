//
//  SPFilterIntervalHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPFilterIntervalHeaderView:  UICollectionReusableView{
    
    lazy var headerView : SPIntervalView = {
        let view = SPIntervalView()
        view.backgroundColor = UIColor.white
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
        self.addSubview(self.headerView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.headerView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.height.equalTo(88)
        }
    }
    deinit {
        
    }
}
