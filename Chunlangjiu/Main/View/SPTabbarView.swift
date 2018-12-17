//
//  SPTabbarView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/22.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

/// 点击回调
typealias SPTabbarClickComplete = (_ index : Int) -> Void

/// 首页的位置
let SP_TAB_INDEX = 0
/// 分类（全部的位置）
let SP_TAB_SORT = 1

/// 竞拍的位置
let SP_TAB_AUCTION = SP_ISSHOW_AUCTION ? 2 : 5
/// 购物车的位置
let SP_TAB_SHOPCART = SP_ISSHOW_AUCTION ? 3 : 2
/// 我的位置
let SP_TAB_MINE = SP_ISSHOW_AUCTION ? 4 : 3
/// tabbar的总数量
let SP_TAB_COUNT = SP_ISSHOW_AUCTION ? 5 : 4

class SPTabbarView:  UIView{
    
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    
    fileprivate lazy var indexBtn : UIButton = {
        let btn = self.sp_setupBtn(title: "首页",image: UIImage(named: "tabbar_index"),selectImg: UIImage(named: "tabbar_index_select"))
        btn.addTarget(self, action: #selector(sp_clickIndexAction), for: UIControlEvents.touchUpInside)
        btn.isSelected = true
        return btn
    }()
    fileprivate lazy var sortBtn : UIButton = {
        let btn = self.sp_setupBtn(title: "全部",image: UIImage(named: "tabbar_sort"),selectImg: UIImage(named: "tabbar_sort_select"))
        btn.addTarget(self, action: #selector(sp_clickSortAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var shopCartBtn : UIButton = {
        let btn = self.sp_setupBtn(title: "购物车",image: UIImage(named: "tabbar_shopcart"),selectImg: UIImage(named: "tabbar_shopcart_select"))
        btn.addTarget(self, action: #selector(sp_clickShopCartAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var mineBtn :  UIButton = {
        let btn = self.sp_setupBtn(title: "我的",image: UIImage(named: "tabbar_mine"),selectImg: UIImage(named: "tabbar_mine_select"))
        btn.addTarget(self, action: #selector(sp_clickMineAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var auctionBtn : UIButton = {
        let btn = self.sp_setupBtn(title: "竞拍", image: UIImage(named: "tabbar_auction"),selectImg: UIImage(named: "tabbar_auction_select"))
        btn.sp_cornerRadius(cornerRadius: 31)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.addTarget(self, action: #selector(sp_clickAuctionAction), for: UIControlEvents.touchUpInside)
        btn.backgroundColor = UIColor.white
        return btn
    }()
    
    fileprivate func sp_setupBtn(title:String,image:UIImage?,selectImg:UIImage?) -> UIButton {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle(title, for: UIControlState.normal)
        btn.setImage(image, for: UIControlState.normal)
        btn.setImage(selectImg, for: UIControlState.selected)
          btn.setImage(selectImg, for: UIControlState.highlighted)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
//        btn.setBackgroundImage(UIImage.sp_getImageWithColor(color: UIColor.white), for: UIControlState.normal)
        
//        btn.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.1)), for: UIControlState.selected)
        sp_setBtnEdgeInsets(btn: btn)
        return btn
    }
    fileprivate func sp_setBtnEdgeInsets(btn :  UIButton){
        let image  = btn.imageView?.image
        let offset :  CGFloat = 5
        var titleHeight : CGFloat = 0
        var titleWidth : CGFloat = 0
        if let titleLabel = btn.titleLabel {
            let size = titleLabel.intrinsicContentSize
            titleHeight = size.height
            titleWidth = size.width
        }
        var imgH : CGFloat = 0
        var imgW : CGFloat = 0
        if let img  = image {
            imgH = img.size.height
            imgW = img.size.width
        }
        
        
        
        btn.imageEdgeInsets =  UIEdgeInsets(top: -titleHeight - offset, left: 0, bottom: 0, right: -titleWidth)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imgW, bottom: -imgH - offset, right: 0)
      
    }
    var clickComplete : SPTabbarClickComplete?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_addNotificaton()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.indexBtn)
        self.addSubview(self.sortBtn)
       
        self.addSubview(self.shopCartBtn)
        self.addSubview(self.mineBtn)
        self.addSubview(self.lineView)
        if SP_ISSHOW_AUCTION {
             self.addSubview(self.auctionBtn)
        }
       
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.indexBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.sortBtn.snp.width).offset(0)
        }
        self.sortBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.indexBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.shopCartBtn.snp.width).offset(0)
        }
        if SP_ISSHOW_AUCTION {
            self.auctionBtn.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.sortBtn.snp.right).offset(0)
                maker.bottom.equalTo(self.snp.bottom).offset(0)
                maker.top.equalTo(self.snp.top).offset(0)
                maker.width.equalTo(self.shopCartBtn.snp.width).offset(0)
//                maker.height.equalTo((SP_TABBAR_HEIGHT + 2))
//                maker.width.equalTo(self.auctionBtn.snp.height).offset(0)
            }
        }
        
        self.shopCartBtn.snp.makeConstraints { (maker) in
            if SP_ISSHOW_AUCTION{
                  maker.left.equalTo(self.auctionBtn.snp.right).offset(0)
            }else{
                 maker.left.equalTo(self.sortBtn.snp.right).offset(0)
            }
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.mineBtn.snp.width).offset(0)
        }
        self.mineBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopCartBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        sp_removeNotification()
    }
}
//MARK: - action
extension SPTabbarView {
    
    fileprivate func sp_dealComplete(index : Int){
        guard let complete = self.clickComplete else {
            return
        }
        complete(index)
    }
    @objc fileprivate func sp_clickIndexAction(){
        self.sp_dealBtnSelected(index: SP_TAB_INDEX)
        self.sp_dealComplete(index: SP_TAB_INDEX)
        SPThridManager.sp_index()
    }
    @objc fileprivate func sp_clickSortAction(){
        self.sp_dealBtnSelected(index: SP_TAB_SORT)
        self.sp_dealComplete(index: SP_TAB_SORT)
        SPThridManager.sp_all()
    }
    @objc fileprivate func sp_clickAuctionAction(){
        self.sp_dealBtnSelected(index: SP_TAB_AUCTION)
        self.sp_dealComplete(index: SP_TAB_AUCTION)
        SPThridManager.sp_auction()
    }
    @objc fileprivate func sp_clickShopCartAction(){
        self.sp_dealBtnSelected(index: SP_TAB_SHOPCART)
        self.sp_dealComplete(index: SP_TAB_SHOPCART)
        SPThridManager.sp_shopCart()
    }
    @objc fileprivate func sp_clickMineAction(){
        self.sp_dealBtnSelected(index: SP_TAB_MINE)
        self.sp_dealComplete(index: SP_TAB_MINE)
        SPThridManager.sp_mine()
    }
    fileprivate func sp_dealBtnSelected(index : Int){
        self.indexBtn.isSelected = false
        self.shopCartBtn.isSelected = false
        self.mineBtn.isSelected = false
        self.sortBtn.isSelected = false
        self.auctionBtn.isSelected = false
        if  index == SP_TAB_INDEX {
            self.indexBtn.isSelected = true
        }else if index == SP_TAB_SORT{
            self.sortBtn.isSelected = true
        }else if index == SP_TAB_AUCTION {
            self.auctionBtn.isSelected = true
        }else if index == SP_TAB_SHOPCART {
            self.shopCartBtn.isSelected = true
        }else if index == SP_TAB_MINE {
            self.mineBtn.isSelected = true
        }
    }
 
    func sp_setAllBtnEdgeInsets(){
        self.sp_setBtnEdgeInsets(btn: self.indexBtn)
        self.sp_setBtnEdgeInsets(btn: self.sortBtn)
        self.sp_setBtnEdgeInsets(btn: self.auctionBtn)
        self.sp_setBtnEdgeInsets(btn: self.shopCartBtn)
        self.sp_setBtnEdgeInsets(btn: self.mineBtn)
    }
}
// MARK: - notification
extension SPTabbarView {
    fileprivate func sp_addNotificaton(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_tabbar(notification:)), name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: nil)
    }
    fileprivate func sp_removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    @objc fileprivate func sp_tabbar(notification:Notification){
        let dic : [String : Any]?  = notification.object as? [String : Any]
        if sp_isDic(dic:dic) {
            let index : String = sp_getString(string: dic?["index"])
            let i = Int(index)
            if i! < SP_TAB_COUNT {
                self.sp_dealBtnSelected(index: i!)
                self.sp_dealComplete(index: i!)
            }
            
        }
    }
}
