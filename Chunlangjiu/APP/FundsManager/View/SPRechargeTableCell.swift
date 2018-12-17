//
//  SPRechargeTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPRechargeTableCell: UITableViewCell {
    
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: ""), for: UIControlState.normal)
        btn.setImage(UIImage(named: ""), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickSelect), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
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
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
extension SPRechargeTableCell {
    @objc fileprivate func sp_clickSelect(){
        self.selectBtn.isSelected = true
    }
}
