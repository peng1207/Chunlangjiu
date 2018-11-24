//
//  SPWineryIntroductionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPWineryIntroductionView:  UIScrollView{
    
    fileprivate lazy var detaileLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var detaileLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var placeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var areaLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var treeAge : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        return label
    }()
    fileprivate lazy var placeLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var varietyTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        
        return label
    }()
    fileprivate lazy var varietyLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0;
        return label
    }()
    fileprivate lazy var varietyLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var contactLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.text = "联系方式："
        return label
    }()
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.text = "电话"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        return label
    }()
    fileprivate lazy var webLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.text = "网址"
         label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.isHidden = true
        return label
    }()
    fileprivate lazy var addressTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.text = "地址"
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.isHidden = true
        return label
    }()
    fileprivate lazy var addressLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var contactLineView : UIView = {
        return sp_getLineView()
    }()
    var detaileModel : SPWinerDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.detaileLabel.text = sp_getString(string: self.detaileModel?.intro)
        self.phoneLabel.text = "电话 \(sp_getString(string: self.detaileModel?.phone))"
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.detaileLabel)
        self.addSubview(self.detaileLineView)
        self.addSubview(self.placeLabel)
        self.addSubview(self.areaLabel)
        self.addSubview(self.treeAge)
        self.addSubview(self.placeLineView)
        self.addSubview(self.varietyTitleLabel)
        self.addSubview(self.varietyLabel)
        self.addSubview(self.varietyLineView)
        self.addSubview(self.contactLabel)
        self.addSubview(self.phoneLabel)
        self.addSubview(self.webLabel)
        self.addSubview(self.addressTitleLabel)
        self.addSubview(self.addressLabel)
        self.addSubview(self.contactLineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.detaileLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(10)
            maker.top.equalTo(self).offset(20)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.snp.centerX).offset(0)
        }
        self.detaileLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileLabel.snp.left).offset(0)
            maker.right.equalTo(self.detaileLabel.snp.right).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.detaileLabel.snp.bottom).offset(15)
        }
        self.placeLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.top.equalTo(self.detaileLineView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.areaLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.top.equalTo(self.placeLabel.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.treeAge.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.areaLabel.snp.bottom).offset(0)
        }
        self.placeLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLineView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.treeAge.snp.bottom).offset(0)
        }
        self.varietyTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.placeLineView.snp.bottom).offset(0)
        }
        self.varietyLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.varietyTitleLabel.snp.bottom).offset(0)
        }
        self.varietyLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLineView).offset(0)
            maker.top.equalTo(self.varietyLabel.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.contactLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.varietyLineView.snp.bottom).offset(20)
        }
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.contactLabel.snp.bottom).offset(10)
        }
        self.webLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.phoneLabel.snp.bottom).offset(10)
        }
        self.addressTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.addressTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileLabel).offset(0)
            maker.top.equalTo(self.webLabel.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        
        self.addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.addressTitleLabel.snp.right).offset(20)
            maker.top.equalTo(self.addressTitleLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.detaileLabel).offset(0)
        }
        self.contactLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.detaileLineView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.addressTitleLabel.snp.bottom).offset(15)
            maker.bottom.equalTo(self.snp.bottom).offset(-20)
        }
        
    }
    deinit {
        
    }
}
