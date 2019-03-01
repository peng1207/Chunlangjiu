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
    fileprivate lazy var reasonView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
  
    // 取消原因
    fileprivate lazy var canceView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "取消原因："
        view.isHidden = true
        view.sp_updateTitle(left: 11)
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.titleLabel.font = sp_getFontSize(size: 14)
        view.contentLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    // 申请原因
    fileprivate lazy var applyView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "申请理由："
        view.isHidden = true
        view.sp_updateTitle(left: 11)
         view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.titleLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    // 拒绝原因
    fileprivate lazy var refuseView : SPOrderContentView = {
        let view = SPOrderContentView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "拒绝原因："
        view.isHidden = true
        view.sp_updateTitle(left: 11)
         view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
         view.titleLabel.font = sp_getFontSize(size: 14)
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
    fileprivate var canceTop : Constraint!
    fileprivate var applyTop : Constraint!
    fileprivate var refuseTop : Constraint!
    fileprivate var reasonBottom : Constraint!
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
     
        var isValues = false
        if sp_getString(string: detaileModel?.cancel_reason).count > 0 || sp_getString(string: detaileModel?.shop_explanation).count > 0 || sp_getString(string: detaileModel?.sysaftersales).count > 0 {
            isValues = true
        }
        self.canceView.contentLabel.text = "\(sp_getString(string: detaileModel?.cancel_reason))"
        self.applyView.contentLabel.text = sp_getString(string: detaileModel?.sysaftersales)
        self.refuseView.contentLabel.text = sp_getString(string: detaileModel?.shop_explanation)
 
        if sp_getString(string: detaileModel?.cancel_reason).count > 0  {
            self.canceView.isHidden = false
        }else{
            self.canceView.isHidden = true
        }
        if sp_getString(string: detaileModel?.sysaftersales).count > 0  {
            self.applyView.isHidden = false
        }else{
            self.applyView.isHidden = true
        }
        if sp_getString(string: detaileModel?.shop_explanation).count > 0  {
            self.refuseView.isHidden = false
        }else{
            self.refuseView.isHidden = true
        }
        self.canceTop.update(offset: isValues ? 0 : 0 )
      
        if sp_getString(string: detaileModel?.cancel_reason).count > 0 , sp_getString(string: detaileModel?.sysaftersales).count > 0 {
            self.applyTop.update(offset: 10)
        }else{
            self.applyTop.update(offset: 0)
        }
        if sp_getString(string: detaileModel?.sysaftersales).count > 0 , sp_getString(string: detaileModel?.shop_explanation).count > 0 {
            self.refuseTop.update(offset: 10)
        }else{
            self.refuseTop.update(offset: 0)
        }
          self.reasonBottom.update(offset: isValues ? -10 : 0)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.stateView)
//        self.addSubview(self.tmpView)
        self.addSubview(self.reasonView)
        self.reasonView.addSubview(self.canceView)
        self.reasonView.addSubview(self.applyView)
        self.reasonView.addSubview(self.refuseView)
        self.addSubview(self.infoView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.stateView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
 
        self.reasonView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.stateView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.canceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
            
          self.canceTop = maker.top.equalTo(self.reasonView.snp.top).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.applyView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
           
          self.applyTop = maker.top.equalTo(self.canceView.snp.bottom).offset(0).constraint
             maker.height.greaterThanOrEqualTo(0)
        }
        self.refuseView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
           self.refuseTop = maker.top.equalTo(self.applyView.snp.bottom).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
           self.reasonBottom = maker.bottom.equalTo(self.reasonView.snp.bottom).offset(0).constraint
        }
        self.infoView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self.reasonView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
//        self.snp.makeConstraints { (maker) in
//            maker.bottom.equalTo(self.infoView.snp.bottom).offset(0)
//        }
    }
    deinit {
        
    }
}
