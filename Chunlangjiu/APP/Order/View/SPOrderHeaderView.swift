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
    fileprivate lazy var canceView : SPOrderReasonView = {
        let view = SPOrderReasonView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "取消原因："
        view.isHidden = true
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.titleLabel.font = sp_getFontSize(size: 14)
        view.contentLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    // 申请原因
    fileprivate lazy var applyView : SPOrderReasonView = {
        let view = SPOrderReasonView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "申请理由："
        view.isHidden = true
         view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.titleLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    // 拒绝原因
    fileprivate lazy var refuseView : SPOrderReasonView = {
        let view = SPOrderReasonView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "拒绝原因："
        view.isHidden = true
         view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
         view.titleLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    // 备注
    fileprivate lazy var remarkView : SPOrderReasonView = {
        let view = SPOrderReasonView()
        view.contentLabel.numberOfLines = 0
        view.titleLabel.text = "备       注："
        view.isHidden = true
        view.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.titleLabel.font = sp_getFontSize(size: 14)
        return view
    }()
    lazy var imgView : SPOrderImgView = {
        let view = SPOrderImgView()
        view.isHidden = true
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
    fileprivate var remarkTop : Constraint!
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
        if sp_getString(string: detaileModel?.cancel_reason).count > 0 || sp_getString(string: detaileModel?.shop_explanation).count > 0 || sp_getString(string: detaileModel?.reason).count > 0 || sp_getString(string: detaileModel?.description_str).count > 0{
            isValues = true
        }
        self.canceView.contentLabel.text = "\(sp_getString(string: detaileModel?.cancel_reason))"
        self.applyView.contentLabel.text = sp_getString(string: detaileModel?.reason)
        self.refuseView.contentLabel.text = sp_getString(string: detaileModel?.shop_explanation)
        self.remarkView.contentLabel.text = sp_getString(string: detaileModel?.description_str)
//        let imgArray = detaileModel?.evidence_pic;
        var imgArray : [String]?
        if sp_getString(string: detaileModel?.evidence_pic).count > 0 {
            imgArray = sp_getString(string: detaileModel?.evidence_pic).components(separatedBy: ",")
        }else{
            imgArray = [String]()
        }

        var isCanceValue  = false
        var isReasonValue = false
        var isShopExplanationValue = false
        var isRemarkValue = false
        let isImgValue = sp_getArrayCount(array: imgArray) > 0 ? true : false
        self.imgView.isHidden = !isImgValue
        self.imgView.imgList = imgArray
        if sp_getString(string: detaileModel?.cancel_reason).count > 0  {
            self.canceView.isHidden = false
            isCanceValue = true
        }else{
            self.canceView.isHidden = true
        }
        if sp_getString(string: detaileModel?.reason).count > 0  {
            self.applyView.isHidden = false
            isReasonValue = true
        }else{
            self.applyView.isHidden = true
        }
        if sp_getString(string: self.detaileModel?.description_str).count > 0 {
            self.remarkView.isHidden = false
            isRemarkValue = true
        }else{
            self.remarkView.isHidden = true
        }
        
        if sp_getString(string: detaileModel?.shop_explanation).count > 0  {
            self.refuseView.isHidden = false
            isShopExplanationValue = true
        }else{
            self.refuseView.isHidden = true
        }
        self.canceTop.update(offset: isValues ? 0 : 0 )
        
        if isReasonValue {
            self.applyTop.update(offset: isCanceValue ? 10 : 0)
        }else{
            self.applyTop.update(offset: 0)
        }
        
        if isRemarkValue {
            self.remarkTop.update(offset: isReasonValue ? 10 : isCanceValue ? 10 : 0)
        }else{
            self.remarkTop.update(offset: 0)
        }
        if  isShopExplanationValue {
            self.refuseTop.update(offset: isImgValue ? 0 : isRemarkValue ? 10 :  isReasonValue ? 10 : isCanceValue ? 10 : 0 )
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
        self.reasonView.addSubview(self.remarkView)
        self.reasonView.addSubview(self.imgView)
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
        self.remarkView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.remarkTop = maker.top.equalTo(self.applyView.snp.bottom).offset(0).constraint
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.remarkView.snp.bottom).offset(0)
        }
        self.refuseView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.reasonView).offset(0)
            self.refuseTop = maker.top.equalTo(self.imgView.snp.bottom).offset(0).constraint
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
