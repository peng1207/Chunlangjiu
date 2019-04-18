//
//  SPIndexTitleView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/13.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexTitleView:  UIView{
     lazy var showCityView : SPIndexShowCityView = {
        let view = SPIndexShowCityView()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: SP_NAVGIT_HEIGHT)
        return view
    }()
    lazy var searchView : SPSearchView = {
        let view = SPSearchView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 160, height: 30))
    
        return view
    }()
    lazy var msgBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "pubilc_msg_white"), for: UIControlState.normal)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.showCityView)
        self.addSubview(self.searchView)
        self.addSubview(self.msgBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.searchView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(80)
            maker.right.equalTo(self).offset(-80)
            maker.height.equalTo(30)
            maker.bottom.equalTo(self).offset(-6)
        }
        self.showCityView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.bottom.equalTo(self).offset(0)
            maker.height.equalTo(SP_NAVGIT_HEIGHT)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.searchView.snp.left).offset(-5)
        }
        self.msgBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.centerY.equalTo(self.searchView.snp.centerY).offset(0)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
    }
    deinit {
        
    }
}
