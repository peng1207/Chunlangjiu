//
//  SPIndexHeadHeaderView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPIndexHeadHeaderView : UICollectionReusableView {
    lazy var tableHeaderView : SPIndexHeaderView = {
        let view  = SPIndexHeaderView()
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.tableHeaderView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableHeaderView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
//            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
