//
//  SPProductBaseView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 商品的主
import Foundation
import UIKit
import SnapKit
class SPProductBaseView:  UIView{
//    lazy var sortView : SPAddressSelectView = {
//        let view = SPAddressSelectView()
//        view.titleLabel.text = "选择分类"
//        view.placeholder = "请选择"
//        view.nextImageView.image = UIImage(named: "public_pulldown_gray")
//        return view
//    }()
    lazy var brandView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "选择品牌"
        view.placeholder = "请选择"
          view.nextImageView.image = UIImage(named: "public_pulldown_gray")
        return view
    }()
    lazy var pSortView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "选择分类"
        view.placeholder = "请选择"
          view.nextImageView.image = UIImage(named: "public_pulldown_gray")
        return view
    }()
    lazy var placeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "选择产地"
        view.placeholder = "请选择"
        view.nextImageView.image = UIImage(named: "public_pulldown_gray")
        return view
    }()
    lazy var typeView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "选择类型"
        view.placeholder = "请选择"
        view.nextImageView.image = UIImage(named: "public_pulldown_gray")
        return view
    }()
//    lazy var alcoholDegreeView : SPAddressSelectView = {
//        let view = SPAddressSelectView()
//        view.titleLabel.text = "选择酒精度"
//        view.placeholder = "请选择"
//        view.nextImageView.image = UIImage(named: "public_pulldown_gray")
//        return view
//    }()
//    lazy var titleView : SPAddressEditView = {
//        let view = SPAddressEditView()
//        view.titleLabel.text = "商品标题"
//        view.textFiled.placeholder = "请填写"
//        return view
//    }()
//    lazy var subTitleView : SPAddressEditView = {
//        let view = SPAddressEditView()
//        view.titleLabel.text = "商品副标题"
//        view.textFiled.placeholder = "请填写"
//        return view
//    }()
//    lazy var labelView : SPAddressEditView = {
//        let view = SPAddressEditView()
//        view.titleLabel.text = "商品标签"
//        view.textFiled.placeholder = "例：产地，年份，品牌"
//        view.lineView.isHidden = true
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
//        self.addSubview(self.sortView)
       self.addSubview(self.brandView)
        self.addSubview(self.pSortView)
        self.addSubview(self.placeView)
        self.addSubview(self.typeView)
//        self.addSubview(self.alcoholDegreeView)
//        self.addSubview(self.titleView)
//        self.addSubview(self.subTitleView)
//        self.addSubview(self.labelView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
//        self.sortView.snp.makeConstraints { (maker) in
//            maker.left.right.top.equalTo(self).offset(0)
//            maker.height.equalTo(44)
//        }
//        self.sortView.nextImageView.snp.updateConstraints { (maker) in
//            maker.width.equalTo(17)
//            maker.height.equalTo(9)
//        }
        self.brandView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(self.pSortView.snp.height).offset(0)
            maker.top.equalTo(self.pSortView.snp.bottom).offset(0)
        }
        self.brandView.nextImageView.snp.updateConstraints { (maker) in
            maker.width.equalTo(17)
            maker.height.equalTo(9)
        }
        self.pSortView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(44)
            maker.top.equalTo(self).offset(0)
        }
        self.pSortView.nextImageView.snp.updateConstraints { (maker) in
            maker.width.equalTo(17)
            maker.height.equalTo(9)
        }
        self.placeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(self.pSortView.snp.height).offset(0)
            maker.top.equalTo(self.brandView.snp.bottom).offset(0)
        }
        self.placeView.nextImageView.snp.updateConstraints { (maker ) in
            maker.width.equalTo(17)
            maker.height.equalTo(9)
        }
        self.typeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(self.pSortView.snp.height).offset(0)
            maker.top.equalTo(self.placeView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.typeView.nextImageView.snp.updateConstraints { (maker ) in
            maker.width.equalTo(17)
            maker.height.equalTo(9)
        }
//        self.alcoholDegreeView.snp.makeConstraints { (maker ) in
//            maker.left.right.equalTo(self).offset(0)
//            maker.height.equalTo(self.pSortView.snp.height).offset(0)
//            maker.top.equalTo(self.typeView.snp.bottom).offset(0)
//            maker.bottom.equalTo(self.snp.bottom).offset(0)
//        }
//        self.alcoholDegreeView.nextImageView.snp.updateConstraints { (maker ) in
//            maker.width.equalTo(17)
//            maker.height.equalTo(9)
//        }
//        self.titleView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self).offset(0)
//            maker.height.equalTo(self.pSortView.snp.height).offset(0)
//            maker.top.equalTo(self.alcoholDegreeView.snp.bottom).offset(0)
//        }
//        self.subTitleView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.titleView).offset(0)
//            maker.height.equalTo(self.titleView.snp.height).offset(0)
//            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
//        }
//        self.labelView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.subTitleView).offset(0)
//            maker.top.equalTo(self.subTitleView.snp.bottom).offset(0)
//            maker.height.equalTo(self.subTitleView.snp.height).offset(0)
//            maker.bottom.equalTo(self.snp.bottom).offset(0)
//        }
    }
    deinit {
        
    }
}
