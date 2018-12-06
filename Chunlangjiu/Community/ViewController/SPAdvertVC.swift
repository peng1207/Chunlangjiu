//
//  SPAdvertVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 广告页
class SPAdvertVC : SPBaseVC{
    
    fileprivate lazy var advertImg : UIImageView = {
        return UIImageView()
    }()
    fileprivate lazy var skipBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("跳过", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        btn.sp_cornerRadius(cornerRadius: 15)
        btn.addTarget(self, action: #selector(sp_clickAdvert), for: UIControlEvents.touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_setupUI()
        sp_setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    /// 添加UI
    override func sp_setupUI(){
        self.view.addSubview(self.advertImg)
        self.view.addSubview(self.skipBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.advertImg.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.view).offset(0)
        }
        self.skipBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.width.equalTo(60)
            maker.right.equalTo(self.view.snp.right).offset(-20)
            maker.top.equalTo(self.view.snp.top).offset(sp_getstatusBarHeight() + 20)
        }
    }
    /// 处理数据
    fileprivate func sp_setupData(){
        
    }
}

extension SPAdvertVC {
    @objc fileprivate func sp_clickAdvert(){
        
    }
}

