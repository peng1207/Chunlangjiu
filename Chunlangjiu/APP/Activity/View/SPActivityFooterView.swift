//
//  SPActivityFooterView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPActivityFooterView:  UIView{
    lazy var imgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate var top : Constraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    func sp_updateTop(top:CGFloat){
        self.top.update(offset: top)
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
            maker.left.right.bottom.equalTo(self).offset(0)
           self.top = maker.top.equalTo(self.snp.top).offset(41).constraint
        }
    }
    deinit {
        
    }
}
