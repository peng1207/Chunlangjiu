//
//  SPProductDetaileBottomView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/21.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

enum SPProductDetaileBtnType {
    case msg
    case collection
    case shopcart
    case intoShopcart
    case buy
    case editPrice
}

typealias SPProductDBBlock = (_ btn : UIButton, _ type : SPProductDetaileBtnType)-> Void

class SPProductDetaileBottomView:  UIView{
    
    fileprivate lazy var msgBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_callphone"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickMsgAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var collectionBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_collect_gray"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "mine_collect"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickCollectionAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var shopCartBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "tabbar_shopcart"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickShopCartAction), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    fileprivate lazy var intoShopCartBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ff9600.rawValue)
        btn.setTitle("加入购物车", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickIntoShopCartAction), for: UIControlEvents.touchUpInside)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        return btn
    }()
    fileprivate lazy var buyBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("立即购买", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBuyAction), for: UIControlEvents.touchUpInside)
       
        return btn
    }()
    fileprivate lazy var countLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = sp_getFontSize(size: 10)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textColor = UIColor.white
        label.sp_cornerRadius(cornerRadius: 8)
        return label
    }()
    fileprivate lazy var editPriceBtn : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitle("立即出价", for: UIControlState.normal)
        btn.setTitle("修改出价", for: UIControlState.selected)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickEditPriceAction), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    fileprivate lazy var auctionLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.numberOfLines = 2
        label.isHidden = true
        label.textAlignment = .right
        return label
    }()
    var clickBlock : SPProductDBBlock?
    var detaileModel : SPProductDetailModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var countModel : SPShopCarCount? {
        didSet{
            if let isAuction = detaileModel?.item?.isAuction , isAuction == true{
                self.countLabel.isHidden = true
            }else if detaileModel == nil{
                self.countLabel.isHidden = true
            }
            else{
                if let m = countModel {
                    if m.number > 0 {
                        self.countLabel.isHidden = false
                    }else{
                        self.countLabel.isHidden = true
                    }
                }else{
                    self.countLabel.isHidden = true
                }
            }
            
          
            
            self.countLabel.text = sp_getString(string: countModel?.number)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.intoShopCartBtn.isHidden = false
        self.buyBtn.isHidden = false
        self.editPriceBtn.isHidden = true
        self.auctionLabel.isHidden = true
       
        if let model = self.detaileModel {
           
            
            if  let isAuction = model.item?.isAuction , isAuction == true {
                self.intoShopCartBtn.isHidden = true
                self.buyBtn.isHidden = true
                self.editPriceBtn.isHidden = false
                self.auctionLabel.isHidden = false
                self.shopCartBtn.isHidden = true
                let att = NSMutableAttributedString()
                if let isCheck : Bool = Bool(sp_getString(string: self.detaileModel?.item?.check)), isCheck == true{
                    
//                   self.editPriceBtn.isSelected = true
                    if let isPay : Bool = Bool(sp_getString(string: self.detaileModel?.item?.is_pay)),isPay == true{
                        self.editPriceBtn.setTitle("修改出价", for: UIControlState.normal)
                        att.append(NSAttributedString(string: "已付定金", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                    }else{
                        self.editPriceBtn.setTitle("去付定金", for: UIControlState.normal)
                          att.append(NSAttributedString(string: "未付定金", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                    }
                }else{
                    self.editPriceBtn.setTitle("立即出价", for: UIControlState.normal)
//                    self.editPriceBtn.isSelected = false
                      att.append(NSAttributedString(string: "应付定金", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                }
                att.append(NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: self.detaileModel?.item?.pledge))", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                self.auctionLabel.attributedText = att
            }else{
                self.shopCartBtn.isHidden = false
            }
           
            if let isCollect : Bool = Bool(sp_getString(string: model.item?.is_collect)), isCollect == true {
                self.collectionBtn.isSelected = true
            }else{
                self.collectionBtn.isSelected = false
            }
        }else{
             self.collectionBtn.isSelected = false
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.msgBtn)
        self.addSubview(self.collectionBtn)
        self.addSubview(self.shopCartBtn)
        self.sp_addLineViewToBtn(btn: self.msgBtn)
        self.sp_addLineViewToBtn(btn: self.collectionBtn)
        self.sp_addLineViewToBtn(btn: self.shopCartBtn)
        self.addSubview(self.countLabel)
        self.addSubview(self.intoShopCartBtn)
        self.addSubview(self.buyBtn)
        self.addSubview(self.auctionLabel)
        self.addSubview(self.editPriceBtn)
        self.sp_addConstraint()
    }
    /// 添加线条到btn上
    ///
    /// - Parameter btn: 按钮
    fileprivate func sp_addLineViewToBtn(btn:UIButton){
        let lineView = sp_getLineView()
        btn.addSubview(lineView)
        lineView.snp.makeConstraints { (maker) in
            maker.right.top.bottom.equalTo(btn).offset(0)
            maker.width.equalTo(sp_lineHeight)
        }
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.msgBtn.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(53)
        }
        self.collectionBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.msgBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(53)
        }
        self.shopCartBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.collectionBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.collectionBtn.snp.width).offset(0)
        }
        self.countLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopCartBtn.snp.right).offset(-20)
            maker.top.equalTo(self.shopCartBtn.snp.top).offset(0)
            maker.width.equalTo(16)
            maker.height.equalTo(16)
        }
        self.intoShopCartBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.shopCartBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.buyBtn.snp.width).offset(0)
        }
        self.buyBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.intoShopCartBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
        }
        self.editPriceBtn.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.buyBtn).offset(0)
        }
        self.auctionLabel.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.intoShopCartBtn).offset(0)
            maker.right.equalTo(self.intoShopCartBtn.snp.right).offset(-5)
        }
    }
    deinit {
        
    }
}
extension SPProductDetaileBottomView {
    
    func sp_setCollectRes(){
        self.collectionBtn.isSelected = !self.collectionBtn.isSelected
    }
    
    @objc fileprivate func sp_clickMsgAction(){
        self.sp_dealComplete(btn: self.msgBtn, type: SPProductDetaileBtnType.msg)
    }
    @objc fileprivate func sp_clickCollectionAction(){
        self.collectionBtn.isSelected = !self.collectionBtn.isSelected
        sp_dealComplete(btn: self.collectionBtn, type: SPProductDetaileBtnType.collection)
    }
    @objc fileprivate func sp_clickShopCartAction(){
        sp_dealComplete(btn: self.shopCartBtn, type: SPProductDetaileBtnType.shopcart)
    }
    @objc fileprivate func sp_clickIntoShopCartAction(){
        sp_dealComplete(btn: self.intoShopCartBtn, type: SPProductDetaileBtnType.intoShopcart)
    }
    @objc fileprivate func sp_clickBuyAction(){
        sp_dealComplete(btn: self.buyBtn, type: SPProductDetaileBtnType.buy)
    }
    @objc fileprivate func sp_clickEditPriceAction(){
        sp_dealComplete(btn: self.editPriceBtn, type: SPProductDetaileBtnType.editPrice)
    }
    fileprivate func sp_dealComplete(btn:UIButton,type:SPProductDetaileBtnType){
        guard let block  = self.clickBlock else {
            return
        }
        block(btn,type)
    }
}
