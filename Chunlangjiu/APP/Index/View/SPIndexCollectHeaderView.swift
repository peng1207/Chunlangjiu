//
//  SPIndexCollectHeaderView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPIndexCollectHeaderView: UICollectionReusableView {
    
    lazy var titleLabel :UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    lazy var moreBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("更多推荐 >", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.isHidden = true
        return btn
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
       self.addSubview(self.titleLabel)
        self.addSubview(self.moreBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(self).offset(0)
        }
        self.moreBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-12)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
    }
    deinit {
        
    }
    
    
}
