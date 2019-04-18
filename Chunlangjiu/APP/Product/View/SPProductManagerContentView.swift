//
//  SPProductManagerContentView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPProductClickComplete = (_ type : Int)->Void

class SPProductManagerContentView:  UIView{
    
    fileprivate lazy var saleView : SPShopProductManagerView = {
        let view = SPShopProductManagerView()
        view.titleLabel.text = "在售商品"
        view.iconImgView.image = UIImage(named: "publick_product_sale")
        return view
    }()
    fileprivate lazy var warehouseView : SPShopProductManagerView = {
        let view = SPShopProductManagerView()
        view.titleLabel.text = "仓库商品"
        view.iconImgView.image = UIImage(named: "public_product_warehouse")
        return view
    }()
    fileprivate lazy var reviewView : SPShopProductManagerView = {
        let view = SPShopProductManagerView()
        view.titleLabel.text = "审核商品"
        view.sp_updateTitle(top: 19)
        view.iconImgView.image = UIImage(named: "public_product_review")
        return view
    }()
    fileprivate lazy var auctionView : SPShopProductManagerView = {
        let view = SPShopProductManagerView()
        view.titleLabel.text = "竞拍商品"
         view.sp_updateTitle(top: 19)
        view.iconImgView.image = UIImage(named: "public_product_auction")
        view.isHidden = SP_ISSHOW_AUCTION ? false : true
        return view
    }()
    
    fileprivate lazy var hLineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var vLineView : UIView = {
        return sp_getLineView()
    }()
    var clickBlock : SPProductClickComplete?
    var countModel : SPMineCountModel?{
        didSet{
            self.sp_setupData()
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
        self.saleView.numLabel.text = sp_getString(string: SPMineData.sp_getCount(to: SPMineType.saleProduct, countModel: countModel ,isShowZero: true))
        self.reviewView.numLabel.text = sp_getString(string: SPMineData.sp_getCount(to: SPMineType.reviewProduct, countModel: countModel ,isShowZero: true))
        self.warehouseView.numLabel.text = sp_getString(string: SPMineData.sp_getCount(to: SPMineType.warehouseProduct, countModel: countModel ,isShowZero: true))
        self.auctionView.numLabel.text = sp_getString(string: SPMineData.sp_getCount(to: SPMineType.auctionProduct, countModel: countModel ,isShowZero: true))
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.saleView)
        self.addSubview(self.reviewView)
        self.addSubview(self.warehouseView)
        self.addSubview(self.auctionView)
        self.addSubview(self.hLineView)
        self.addSubview(self.vLineView)
        self.sp_addConstraint()
        sp_addTap(action: #selector(sp_clickSale), view: self.saleView)
        sp_addTap(action: #selector(sp_clickReview), view: self.reviewView)
        sp_addTap(action: #selector(sp_clickWarehouse), view: self.warehouseView)
        sp_addTap(action: #selector(sp_clickAuction), view: self.auctionView)
    }
    
    fileprivate func sp_addTap(action : Selector,view : UIView){
        let tap = UITapGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(tap)
    }
    
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.saleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.equalTo(self).offset(0)
            maker.height.equalTo(95)
            maker.width.equalTo(self.warehouseView.snp.width).offset(0)
        }
        self.warehouseView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.saleView.snp.right).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.height.equalTo(self.saleView).offset(0)
           
        }
        self.reviewView.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.saleView).offset(0)
            maker.top.equalTo(self.saleView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.warehouseView).offset(0)
            maker.top.equalTo(self.reviewView.snp.top).offset(0)
        }
        self.hLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.saleView.snp.bottom).offset(0)
        }
        self.vLineView.snp.makeConstraints { (maker) in
            maker.width.equalTo(sp_lineHeight)
            maker.centerX.equalTo(self).offset(0)
            maker.top.equalTo(self.saleView).offset(0)
            maker.bottom.equalTo(self.reviewView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPProductManagerContentView {
    
    @objc fileprivate func sp_clickSale(){
        sp_dealComplete(type: SPMineType.saleProduct.rawValue)
    }
    @objc fileprivate func sp_clickAuction(){
         sp_dealComplete(type: SPMineType.auctionProduct.rawValue )
    }
    @objc fileprivate func sp_clickWarehouse(){
         sp_dealComplete(type: SPMineType.warehouseProduct.rawValue)
    }
    @objc fileprivate func sp_clickReview(){
         sp_dealComplete(type: SPMineType.reviewProduct.rawValue)
    }
    
    fileprivate func sp_dealComplete(type:Int){
        guard let block = self.clickBlock else {
            return
        }
        block(type)
    }
    
}
