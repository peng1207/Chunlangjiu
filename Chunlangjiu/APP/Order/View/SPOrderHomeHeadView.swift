//
//  SPOrderHomeHeadView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/12/24.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPOrderHomeHeadComplete = (_ view : SPOrderHomeHeadView ,_ index : Int)->Void
class SPOrderHomeHeadView: UIView {
    
    fileprivate lazy var orderBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("商品订单", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.isSelected = true
        btn.addTarget(self, action: #selector(sp_clickOrder), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var auctionBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("竞拍订单", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickAuthOrder), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    var clickBlock : SPOrderHomeHeadComplete?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.orderBtn)
        self.addSubview(self.auctionBtn)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.orderBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.auctionBtn.snp.width).offset(0)
        }
        self.auctionBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.orderBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.orderBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        sp_updateLineLayout()
    }
    fileprivate func sp_updateLineLayout(isFirst : Bool = true){
        self.lineView.snp.remakeConstraints { (maker) in
            if isFirst {
                   maker.centerX.equalTo(self.orderBtn.snp.centerX).offset(0)
            }else{
                   maker.centerX.equalTo(self.auctionBtn.snp.centerX).offset(0)
            }
            maker.width.equalTo(60)
            maker.height.equalTo(1)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPOrderHomeHeadView{
    func sp_getWhich()-> Int{
        return self.orderBtn.isSelected ? 0 : 1
    }
    @objc fileprivate func sp_clickOrder(){
        sp_updateLineLayout()
        sp_dealBtnDefault()
        sp_dealComplete(index: 0)
        self.orderBtn.isSelected = true
    }
    @objc fileprivate func sp_clickAuthOrder(){
        sp_updateLineLayout(isFirst: false)
        sp_dealBtnDefault()
        sp_dealComplete(index: 1)
        self.auctionBtn.isSelected = true
    }
    
    fileprivate func sp_dealComplete(index : Int){
        guard let block = self.clickBlock else {
            return
        }
        block(self,index)
    }
    
    fileprivate func sp_dealBtnDefault(){
        self.orderBtn.isSelected = false
        self.auctionBtn.isSelected = false
    }
    
    
}
