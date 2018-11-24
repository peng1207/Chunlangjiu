//
//  SPFilterSectionHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/12.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPFilterSectionHeaderView:  UICollectionReusableView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    lazy var moreBtn : UIButton = {
        let btn = UIButton()
        btn.setTitle("更多", for: UIControlState.normal)
        btn.setTitle("收起", for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_999999.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickMoreAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    lazy var topLineView : UIView = {
        return sp_getLineView()
    }()
    lazy var bottomLineView : UIView = {
        return sp_getLineView()
    }()
    var clickComplete : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc fileprivate func sp_clickMoreAction(){
        guard let block = self.clickComplete else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.moreBtn)
        self.addSubview(self.topLineView)
        self.addSubview(self.bottomLineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(12)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.moreBtn.snp.left).offset(-10)
        }
        self.moreBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(50)
        }
        self.topLineView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.bottomLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(12)
            maker.right.equalTo(self).offset(-10)
            maker.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
