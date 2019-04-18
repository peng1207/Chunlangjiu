//
//  SPProductParmView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
//  商品参数
import Foundation
import UIKit
import SnapKit
class SPProductParmView:  UIView{
    
    lazy var parmTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "商品参数"
        return label
    }()
    lazy var typeView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "类型:"
        return view
    }()
    lazy var capacityView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "容量:"
        view.contentLabel.text = ""
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
        return view
    }()
    lazy var wineryView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "酒庄:"
        return view
    }()
    lazy var seriesView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "系列:"
        return view
    }()
    lazy var packView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "包装:"
        return view
    }()
    lazy var degreesView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "酒精度:"
        view.contentLabel.text = "%"
        view.textFiled.keyboardType = UIKeyboardType.decimalPad
        return view
    }()
    lazy var placeView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "产地:"
        return view
    }()
    lazy var yearView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "年份:"
        return view
    }()
    lazy var materialView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "原料:"
        return view
    }()
    lazy var storageView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "储存:"
        return view
    }()
    lazy var enclosureView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "附件:"
        view.textFiled.placeholder = "礼盒、防尘袋、保卡、说明书、吊牌等"
        return view
    }()
    lazy var sourceView : SPProductParmContentView = {
        let view = SPProductParmContentView()
        view.titleLabel.text = "来源:"
        view.textFiled.placeholder = "珍藏、朋友赠送、礼品、自购、其他等"
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.parmTitleLabel)
//        self.addSubview(self.typeView)
        self.addSubview(self.seriesView)
        self.addSubview(self.wineryView)
        self.addSubview(self.capacityView)
        self.addSubview(self.packView)
        self.addSubview(self.yearView)
        self.addSubview(self.materialView)
        self.addSubview(self.storageView)
        self.addSubview(self.enclosureView)
        self.addSubview(self.sourceView)
//        self.addSubview(self.degreesView)
//        self.addSubview(self.placeView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.parmTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.parmTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(16)
            maker.top.equalTo(self.snp.top).offset(0)
            maker.height.equalTo(40)
            maker.right.equalTo(self.snp.right).offset(-16)
        }
        self.capacityView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.parmTitleLabel.snp.left).offset(0)
            maker.top.equalTo(self.parmTitleLabel.snp.bottom).offset(0)
            maker.height.equalTo(40)
            maker.right.equalTo(self.parmTitleLabel.snp.right).offset(0)
        }
        self.wineryView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.capacityView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.seriesView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.wineryView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.packView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.yearView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
           
        }
        self.yearView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.seriesView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.materialView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.packView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.storageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.enclosureView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.enclosureView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.materialView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
        }
        self.sourceView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.capacityView.snp.left).offset(0)
            maker.top.equalTo(self.storageView.snp.bottom).offset(0)
            maker.height.equalTo(self.capacityView).offset(0)
            maker.right.equalTo(self.capacityView.snp.right).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
//        self.degreesView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.seriesView.snp.left).offset(0)
//            maker.right.equalTo(self.seriesView.snp.right).offset(0)
//            maker.top.equalTo(self.packView.snp.top).offset(0)
//            maker.height.equalTo(self.packView.snp.height).offset(0)
//        }
//        self.placeView.snp.makeConstraints { (maker) in
//            maker.left.equalTo(self.packView.snp.left).offset(0)
//            maker.right.equalTo(self.degreesView.snp.right).offset(0)
//            maker.top.equalTo(self.packView.snp.bottom).offset(0)
//            maker.height.equalTo(self.packView.snp.height).offset(0)
//            maker.bottom.equalTo(self.snp.bottom).offset(-10)
//        }
    }
    deinit {
        
    }
}

class SPProductParmContentView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 15)
        return label
    }()
    lazy var textFiled : SPTextFiled = {
        let text = SPTextFiled()
        text.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        text.font = sp_getFontSize(size: 14)
        text.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {
            
        }, doneBlock: {
            
        })
        return text
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.textFiled)
        self.addSubview(self.contentLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
         self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.textFiled.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(2)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.contentLabel.snp.left).offset(0)
        }
        self.contentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}

