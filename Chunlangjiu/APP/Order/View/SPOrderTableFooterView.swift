//
//  SPOrderTableFooterView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPOrderFooterClickComplete = (_ orderModel : SPOrderModel?,_ btnIndex : Int)-> Void

class SPOrderTableFooterView:  UITableViewHeaderFooterView{
    
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 12)
        return label
    }()
    
    fileprivate lazy  var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消订单", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("去付款", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy  var lineView : UIView = {
        return sp_getLineView()
    }()
    var orderModel : SPOrderModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPOrderFooterClickComplete?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.priceLabel.text = "共\(sp_getString(string: orderModel?.totalItem))件商品,合计：\(SP_CHINE_MONEY)\(sp_getString(string: orderModel?.payment))"
        let cance : (canceIsHidden : Bool,canceText : String) = SPOrderBtnManager.sp_dealCanceState(orderModel: self.orderModel)
        let done : (doneIsHidden : Bool, doneText: String) = SPOrderBtnManager.sp_dealDoneState(orderModel: self.orderModel)
        self.canceBtn.isHidden = cance.canceIsHidden
        self.canceBtn.setTitle(sp_getString(string: cance.canceText), for: UIControlState.normal)
        self.doneBtn.isHidden = done.doneIsHidden
        self.doneBtn.setTitle(sp_getString(string: done.doneText), for: UIControlState.normal)
    
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.doneBtn)
        self.contentView.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(8)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.canceBtn.snp.left).offset(-8)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.height.equalTo(30)
            maker.centerY.equalTo(self.contentView.snp.centerY).offset(0)
            maker.width.equalTo(80)
            maker.right.equalTo(self.doneBtn.snp.left).offset(-10)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-8)
            maker.height.equalTo(self.canceBtn.snp.height).offset(0)
            maker.width.equalTo(self.canceBtn.snp.width).offset(0)
            maker.centerY.equalTo(self.canceBtn.snp.centerY).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}
extension SPOrderTableFooterView {
    @objc fileprivate func sp_clickCance(){
        sp_dealComplete(btnIndex: 1)
    }
    @objc fileprivate func sp_clickDone(){
        self.sp_dealComplete(btnIndex: 0)
    }
    fileprivate func sp_dealComplete(btnIndex : Int){
        guard let block  = self.clickBlock else {
            return
        }
        block(self.orderModel,btnIndex)
    }
}
