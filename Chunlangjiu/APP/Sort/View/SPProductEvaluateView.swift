
//
//  SPProductEvaluateView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/10.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

import UIKit
import SnapKit
class SPProductEvaluateView:  UIView{
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    
    lazy var nextImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_rightBack")
        return imageView
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var dataArray : [SPEvaluateModel]?{
        didSet{
            self.sp_setupSubView()
        }
    }
    var total : Int = 0{
        didSet{
            sp_setupData()
        }
    }
    var clickBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupSubView(){
        
        for view in self.subviews {
            if view is SPEvaluateView {
                view.removeFromSuperview()
            }
        }
        
        if sp_getArrayCount(array: self.dataArray) > 0 {
            var view : UIView? = nil
            var index : Int = 0
            for data in self.dataArray! {
                let evaluateView = SPEvaluateView()
                evaluateView.evaluateModel = data
                self.addSubview(evaluateView)
                evaluateView.snp.makeConstraints { (maker) in
                    maker.left.right.equalTo(self).offset(0)
                    maker.height.greaterThanOrEqualTo(0)
                    if let tempView = view {
                        maker.top.equalTo(tempView.snp.bottom).offset(0)
                    }else{
                        maker.top.equalTo(self.lineView.snp.bottom).offset(0)
                    }
                    
                    if index == sp_getArrayCount(array: self.dataArray) - 1{
                        maker.bottom.equalTo(self.snp.bottom).offset(0)
                    }
                }
                view = evaluateView
                index = index + 1
            }
        }
        
        self.lineView.snp.remakeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.nextImageView.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(sp_lineHeight)
            if sp_getArrayCount(array: self.dataArray) > 0{
                
            }else{
                maker.bottom.equalTo(self.snp.bottom).offset(0)
            }
        }
       
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if self.total > 0 {
            self.titleLabel.isHidden = false
            self.nextImageView.isHidden = false
        }else{
            self.titleLabel.isHidden = false
            self.nextImageView.isHidden = false
        }
        if self.total > 0 {
              self.titleLabel.text = "商品评价(\(total))"
        }else{
              self.titleLabel.text = "商品评价"
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
        
        let point = touch.location(in:self)     //获取当前点击位置
        if point.y < self.titleLabel.frame.height + self.titleLabel.frame.origin.y {
            sp_dealComplete()
        }else{
            super.touchesBegan(touches, with: event)
        }
    }
    fileprivate func sp_dealComplete(){
        guard let block = self.clickBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.nextImageView)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.top.equalTo(self.snp.top).offset(10)
            maker.right.equalTo(self.nextImageView.snp.left).offset(-10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.nextImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.centerY.equalTo(self.titleLabel.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.right.equalTo(self.nextImageView.snp.right).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
            maker.height.equalTo(sp_lineHeight)
        }
        
    }
    deinit {
        
    }
}
