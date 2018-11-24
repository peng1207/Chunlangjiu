//
//  SPOrderHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/11/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderHeaderView:  UIView{
    fileprivate lazy var stateView : SPOrderStateView = {
        let view = SPOrderStateView()
        return view
    }()
    fileprivate lazy var infoView : SPOrderInfoView = {
        let view = SPOrderInfoView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    var detaileModel : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.stateView.detaileModel = detaileModel
        self.infoView.content = sp_getString(string: detaileModel?.info)
        self.infoView.isHidden = sp_getString(string: detaileModel?.info).count > 0  ? false : true
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.stateView)
        self.addSubview(self.infoView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.stateView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.infoView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.stateView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
