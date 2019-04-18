//
//  SPShopProductAuctionPriceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/5.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SPShopProductAuctionPriceContentView:  UIView{
    fileprivate lazy var phoneLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var statusLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "领先"
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPAuctionPrice?{
        didSet{
            sp_setupData()
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
        self.phoneLabel.text = sp_getString(string: self.model?.mobile)
        self.priceLabel.text = sp_getString(string: self.model?.price)
        self.timeLabel.text = sp_getString(string: self.model?.showTime)
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.phoneLabel)
        self.addSubview(self.timeLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.statusLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.phoneLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.phoneLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(19)
            maker.top.equalTo(self).offset(18)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.statusLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.statusLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.right).offset(10)
            maker.top.equalTo(self.phoneLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.right.lessThanOrEqualTo(self.priceLabel.snp.left).offset(-10)
        }
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-25)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.phoneLabel.snp.left).offset(0)
            maker.top.equalTo(self.phoneLabel.snp.bottom).offset(10)
            maker.right.lessThanOrEqualTo(self.priceLabel.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}


class SPShopProductAuctionPriceView:  UIView{
    fileprivate lazy var titleView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var nextImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_rightBack")
        return view
    }()
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    
    func sp_update(list : [SPAuctionPrice]?,total : Int,isEnd:Bool = false){
        for view in self.subviews {
            if view.isKind(of: SPShopProductAuctionPriceContentView.classForCoder()){
                view.removeFromSuperview()
            }
        }
        var dataList = [SPAuctionPrice]()
        if sp_getArrayCount(array: list) > 2 {
            dataList.append(list![0])
            dataList.append(list![1])
        }else{
            if sp_getArrayCount(array: list) > 0 {
                dataList = list!
            }
        }
        self.titleLabel.text = "当前出价记录（\(total)）条"
        self.titleView.snp.remakeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(35)
            if sp_getArrayCount(array: dataList) == 0 {
                maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
        }
        if sp_getArrayCount(array: dataList) > 0  {
            var index = 0
            var tmpView : UIView?
            
            for model in dataList {
                let contenctView = SPShopProductAuctionPriceContentView()
                contenctView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
                contenctView.model = model
                if index == 0 {
                    if isEnd {
                         contenctView.statusLabel.text = "成交"
                    }else{
                         contenctView.statusLabel.text = "领先"
                    }
                   contenctView.statusLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
                }else{
                    if isEnd {
                        contenctView.statusLabel.text = "出局"
                    }else{
                         contenctView.statusLabel.text = "落后"
                    }
                    contenctView.statusLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
                }
                self.addSubview(contenctView)
                contenctView.snp.makeConstraints { (maker) in
                    maker.left.right.equalTo(self).offset(0)
                    maker.height.equalTo(65)
                    if let v = tmpView {
                        maker.top.equalTo(v.snp.bottom).offset(0)
                    }else{
                        maker.top.equalTo(self.titleView.snp.bottom).offset(0)
                    }
                    if index == sp_getArrayCount(array: list) - 1 {
                        maker.bottom.equalTo(self.snp.bottom).offset(0)
                    }
                }
                
                index = index + 1
                tmpView = contenctView
                
            }
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleView)
        self.titleView.addSubview(self.titleLabel)
        self.titleView.addSubview(self.nextImgView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickTap))
        self.titleView.addGestureRecognizer(tap)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self).offset(0)
            maker.height.equalTo(35)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleView.snp.left).offset(10)
            maker.top.bottom.equalTo(self.titleView).offset(0)
            maker.right.equalTo(self.nextImgView.snp.left).offset(-10);
        }
        self.nextImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.titleView.snp.right).offset(-11)
            maker.centerY.equalTo(self.titleView.snp.centerY).offset(0)
            maker.width.equalTo(9)
            maker.height.equalTo(18)
        }
    }
    deinit {
        
    }
}

extension SPShopProductAuctionPriceView {
    
    @objc fileprivate func sp_clickTap(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    
}
