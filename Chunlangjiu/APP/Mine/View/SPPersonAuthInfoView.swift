//
//  SPPersonAutoInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPersonAuthInfoView:  UIView{
    fileprivate lazy var nameView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "真实姓名"
        view.sp_nextImg(isHidden: true)
        return view
    }()
    fileprivate lazy var typeView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "证件类型"
        view.sp_nextImg(isHidden: true)
        view.contentLabel.text = "身份证"
        return view
    }()
    fileprivate lazy var codeView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "证件号码"
        view.sp_nextImg(isHidden: true)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "个人认证资料"
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_setupData(){
        self.nameView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.name)
        self.codeView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.idcard)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.nameView)
        self.addSubview(self.typeView)
        self.addSubview(self.codeView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(22)
            maker.top.equalTo(self.snp.top).offset(26)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.snp.right).offset(-17)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        self.typeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.typeView).offset(0)
            maker.top.equalTo(self.typeView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
