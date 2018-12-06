//
//  SPTutorialPageVC.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 教程页
class SPTutorialPageVC : SPBaseVC{
    
    fileprivate var collectionView : UICollectionView!
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
        
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    /// 处理数据
    fileprivate func sp_setupData(){
        
    }
}
extension SPTutorialPageVC {
    @objc fileprivate func sp_clickAdvert(){
        
    }
}
