//
//  SPOrderBottomView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/31.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderBottomView:  UIView{
    
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消订单", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("去付款", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var orderDetaile : SPOrderDetaileModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPOrderFooterClickComplete?
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
        let cance : (canceIsHidden : Bool,canceText : String) = SPOrderBtnManager.sp_dealCanceState(orderModel: self.orderDetaile)
        let done : (doneIsHidden : Bool, doneText: String) = SPOrderBtnManager.sp_dealDoneState(orderModel: self.orderDetaile)
        self.canceBtn.isHidden = cance.canceIsHidden
        self.canceBtn.setTitle(sp_getString(string: cance.canceText), for: UIControlState.normal)
        self.doneBtn.isHidden = done.doneIsHidden
        self.doneBtn.setTitle(sp_getString(string: done.doneText), for: UIControlState.normal)
     
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.canceBtn)
        self.addSubview(self.doneBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.doneBtn.snp.left).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(110)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(110)
        }
    }
    deinit {
        
    }
}
extension SPOrderBottomView {
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
        block(self.orderDetaile,btnIndex)
    }
}
