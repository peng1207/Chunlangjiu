//
//  SPCustomerServiceVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCustomerServiceVC: SPBaseVC {
    
    fileprivate lazy var phoneView : SPTextLabelView = {
        let view = SPTextLabelView()
        view.titleLabel.text = "全国热线"
        view.contentLabel.text = "400-788-9550"
        return view
    }()
    fileprivate lazy var wxView : SPTextLabelView = {
        let view = SPTextLabelView()
        view.titleLabel.text = "醇狼微信"
        view.contentLabel.text = "chunlang9"
        return view
    }()
    fileprivate lazy var qqView : SPTextLabelView = {
        let view = SPTextLabelView()
        view.titleLabel.text = "醇狼QQ"
        view.contentLabel.text = "3076783805"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
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
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "我的客服"
        self.view.addSubview(self.phoneView)
        self.view.addSubview(self.wxView)
        self.view.addSubview(self.qqView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.view).offset(10)
            maker.height.equalTo(50)
        }
        self.wxView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(self.phoneView.snp.height).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
        }
        self.qqView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(self.wxView.snp.height).offset(0)
            maker.top.equalTo(self.wxView.snp.bottom).offset(0)
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        
    }
    deinit {
        
    }
}
