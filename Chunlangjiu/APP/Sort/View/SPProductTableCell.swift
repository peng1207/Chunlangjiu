//
//  SPProductTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/23.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPProductTableCell: UITableViewCell {
    lazy var productView : SPProductView = {
        let view = SPProductView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
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
        self.contentView.addSubview(self.productView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.height.equalTo(150)
            maker.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
