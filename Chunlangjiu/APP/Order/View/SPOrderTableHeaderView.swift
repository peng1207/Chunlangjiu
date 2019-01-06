//
//  SPOrderTableHeaderView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import UIKit
import SnapKit
typealias SPOrderHeaderComplete = (_ orderModel : SPOrderModel?)->Void
class SPOrderTableHeaderView:  UITableViewHeaderFooterView{
    
    fileprivate lazy var shopView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var shopLogoImageView : UIImageView = {
            let imageView = UIImageView()
        imageView.sp_cornerRadius(cornerRadius: 15)
        return imageView
    }()
    fileprivate lazy var shopNameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    
    lazy var orderStateLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return label
    }()
    lazy var deleteBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_delete_gray"), for: UIControlState.normal)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickDelete), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var lineView : UIView = {
        return sp_getLineView()
    }()
    var orderModel : SPOrderModel? {
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPOrderHeaderComplete?
    var clickDeleteBlock : SPOrderHeaderComplete?
    fileprivate var leftConstraint : Constraint!
    fileprivate var rightConstraint : Constraint!
    fileprivate var deleteRight : Constraint!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickAction))
        self.addGestureRecognizer(tap)
         self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_leftRightZero(){
        self.leftConstraint.update(offset: 0)
        self.rightConstraint.update(offset: 0)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.shopLogoImageView.sp_cache(string: sp_getString(string: self.orderModel?.shop_logo), plImage:  sp_getLogoImg())
        self.shopNameLabel.text = "\(sp_getString(string: orderModel?.shopname)) >"
        self.orderStateLabel.text = sp_getString(string: orderModel?.status_desc)
    }
    /// 处理删除按钮
    func sp_dealDelete(){
        let isShow = SPOrderBtnManager.sp_showDelete(orderModel: orderModel)
        self.deleteBtn.isHidden = isShow ? false : true
        self.deleteRight.update(offset: isShow ? -5 : 18)
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.shopView)
        self.shopView.addSubview(self.shopLogoImageView)
        self.shopView.addSubview(self.shopNameLabel)
        self.shopView.addSubview(self.orderStateLabel)
        self.shopView.addSubview(self.deleteBtn)
        self.shopView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shopView.snp.makeConstraints { (maker) in
           self.leftConstraint = maker.left.equalTo(self.contentView).offset(10).constraint
           self.rightConstraint = maker.right.equalTo(self.contentView).offset(-10).constraint
            maker.bottom.equalTo(self.contentView).offset(0)
            maker.height.equalTo(50)
        }
        self.shopLogoImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopView).offset(10)
            maker.width.height.equalTo(30)
            maker.centerY.equalTo(self.shopView.snp.centerY).offset(0)
        }
        self.shopNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopLogoImageView.snp.right).offset(14)
            maker.top.bottom.equalTo(self.shopView).offset(0)
            maker.right.lessThanOrEqualTo(self.orderStateLabel.snp.left).offset(-8)
        }
        self.orderStateLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.orderStateLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.deleteBtn.snp.left).offset(-8)
            maker.top.bottom.equalTo(self.shopView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.deleteBtn.snp.makeConstraints { (maker) in
            self.deleteRight = maker.right.equalTo(self.shopView).offset(18).constraint
            maker.width.equalTo(18)
            maker.height.equalTo(17)
            maker.centerY.equalTo(self.shopView).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            
            maker.left.right.bottom.equalTo(self.shopView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPOrderTableHeaderView {
    @objc fileprivate func sp_clickAction(){
        guard let block = self.clickBlock else {
            return
        }
        block(self.orderModel)
    }
    @objc fileprivate func sp_clickDelete(){
        guard let block = self.clickDeleteBlock else {
            return
        }
        block(self.orderModel)
    }
}
