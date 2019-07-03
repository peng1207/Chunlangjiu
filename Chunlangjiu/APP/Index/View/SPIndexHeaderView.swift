//
//  SPIndexHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/9.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPIndexHeaderView:  UIView{
    lazy var bannerView : SPBannerView = {
        let view = SPBannerView()
        view.pageControl.otherColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.8)
        view.isAutoPaly = true
        return view
    }()
    lazy var iconView : SPIndexIconView = {
        let view = SPIndexIconView()
        view.isHidden = true
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    lazy var brandView : SPIndexBrandView = {
        let view = SPIndexBrandView()
        view.isHidden = true
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    var indexModel : SPIndexModel? {
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate var iconHeight : Constraint!
    fileprivate var iconTop : Constraint!
    fileprivate var brandHeight : Constraint!
    fileprivate var brandTop : Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        self.dealBannerAction()
       
        
        self.sp_setupData()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.bannerView.sp_reloadData()
       
        if sp_getArrayCount(array: self.indexModel?.iconList) > 0 {
            self.iconHeight.update(offset: 71)
            self.iconTop.update(offset: 10)
            self.iconView.isHidden = false
        }else{
            self.iconHeight.update(offset: 0)
            self.iconTop.update(offset: 0)
            self.iconView.isHidden = true
        }
        if  sp_getArrayCount(array: self.indexModel?.brandList) > 0 {
            self.brandHeight.update(offset: 200)
            self.brandTop.update(offset: 10)
            self.brandView.isHidden = false
        }else{
            self.brandHeight.update(offset: 0)
            self.brandTop.update(offset: 0)
            self.brandView.isHidden = true
        }
        self.iconView.dataArray = self.indexModel?.iconList
        self.brandView.dataArray = self.indexModel?.brandList
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.bannerView)

        self.addSubview(self.iconView)
        self.addSubview(self.brandView)
        self.brandView.backgroundColor = UIColor.white
        self.iconView.backgroundColor = UIColor.white
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
       
        self.bannerView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
//            maker.height.equalTo(200)
            maker.height.equalTo(self.bannerView.snp.width).multipliedBy(200.00/375.00)
        }
        self.iconView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
          self.iconTop = maker.top.equalTo(self.bannerView.snp.bottom).offset(10).constraint
            self.iconHeight = maker.height.equalTo(0).constraint
        }
        self.brandView.setNeedsLayout()
        self.brandView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.iconView).offset(0)
            self.brandTop = maker.top.equalTo(self.iconView.snp.bottom).offset(0).constraint
            self.brandHeight =  maker.height.equalTo(0).constraint
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        
    }
    deinit {
        
    }
}
extension SPIndexHeaderView {
    fileprivate func dealBannerAction(){
        self.bannerView.numBlock = { (section : Int)-> Int in
            if let model = self.indexModel {
                return sp_getArrayCount(array: model.bannerList)
            }
            
            return 0
        }
        self.bannerView.cellBlock = { (imageView : UIImageView,row : Int) in
            if let model = self.indexModel {
                if row < sp_getArrayCount(array: model.bannerList){
                    let bannerModel = model.bannerList![row]
                    imageView.sp_cache(string: sp_getString(string: bannerModel.imagesrc), plImage: sp_getDefaultImg())
                }
            }
        }
        self.bannerView.selectBlock = { (row : Int) in
            sp_log(message: "click row is \(row)")
        }
    }
}
