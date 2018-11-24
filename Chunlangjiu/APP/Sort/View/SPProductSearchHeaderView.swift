//
//  SPProductSearchHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/15.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductSearchHeaderView : UICollectionReusableView{
    
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 18)
        label.text = "历史搜索"
        return label
    }()
    fileprivate lazy var deleteBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_delete_red"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDeleteAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var deleteBlock : SPBtnClickBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.deleteBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.deleteBtn.snp.left).offset(-10)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.width.equalTo(21)
            maker.height.equalTo(23)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPProductSearchHeaderView {
   @objc fileprivate func sp_clickDeleteAction(){
        guard let block = self.deleteBlock else {
            return
        }
        block()
    }
    
}
