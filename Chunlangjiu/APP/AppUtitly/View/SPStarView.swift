//
//  SPStarView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/19.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPStarView:  UIView{
    
    fileprivate  lazy var firstStarBtn : UIButton = {
        let btn = self.sp_setupBtn()
        return btn 
    }()
    fileprivate lazy var secondStarBtn : UIButton = {
        let btn = self.sp_setupBtn()
        return btn
    }()
    fileprivate lazy var thridStarBtn : UIButton = {
        let btn = self.sp_setupBtn()
        return btn
    }()
    fileprivate lazy var fourStarBtn : UIButton = {
        let btn = self.sp_setupBtn()
        return btn
    }()
    fileprivate lazy var fifStarbtn : UIButton = {
        let btn = self.sp_setupBtn()
        return btn
    }()
    var count : Int = 0 {
        didSet{
            self.sp_setupData()
        }
    }
    fileprivate func sp_setupBtn()->UIButton{
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_star_g"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_star_y"), for: UIControlState.selected)
        return btn
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
        self.fifStarbtn.isSelected = false
        self.secondStarBtn.isSelected = false
        self.firstStarBtn.isSelected = false
        self.thridStarBtn.isSelected = false
        self.fourStarBtn.isSelected = false
        if count == 0 {
            
        }else{
            for i in 1...self.count{
                if i == 1 {
                    self.firstStarBtn.isSelected = true
                }else if i == 2 {
                    self.secondStarBtn.isSelected = true
                }else if i == 3 {
                    self.thridStarBtn.isSelected = true
                }else if i == 4 {
                    self.fourStarBtn.isSelected = true
                }else{
                    self.fifStarbtn.isSelected = true
                }
            }
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.firstStarBtn)
        self.addSubview(self.secondStarBtn)
        self.addSubview(self.thridStarBtn)
        self.addSubview(self.fourStarBtn)
        self.addSubview(self.fifStarbtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.firstStarBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(4)
            maker.height.equalTo(self.firstStarBtn.snp.width).offset(0)
            maker.width.equalTo(self.secondStarBtn.snp.width).offset(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
        self.secondStarBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.firstStarBtn.snp.right).offset(4)
            maker.height.top.equalTo(self.firstStarBtn).offset(0)
            maker.width.equalTo(self.thridStarBtn.snp.width).offset(0)
        }
        self.thridStarBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.secondStarBtn.snp.right).offset(4)
            maker.top.height.equalTo(self.secondStarBtn).offset(0)
            maker.width.equalTo(self.fourStarBtn.snp.width).offset(0)
        }
        self.fourStarBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.thridStarBtn.snp.right).offset(4)
            maker.top.height.equalTo(self.thridStarBtn).offset(0)
            maker.width.equalTo(self.fifStarbtn.snp.width).offset(0)
        }
        self.fifStarbtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.fourStarBtn.snp.right).offset(4)
            maker.top.height.equalTo(self.fourStarBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(-4)
        }
        
    }
    deinit {
        
    }
}
