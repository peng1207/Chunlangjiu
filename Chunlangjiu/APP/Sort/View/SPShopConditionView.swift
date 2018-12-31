//
//  SPShopConditionView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/30.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPShopConditionView:  UIView{
    
    fileprivate lazy var defualtBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("综合", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDefault), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var salesBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("销量", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSales), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var auctionBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("竞拍", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickAuction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var priceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("价格区间", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickPrice), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var conditionFilterView : SPConditionFilterView! = {
        let view = SPConditionFilterView()
        view.selectCompete = { [weak self](model) in
            self?.sp_dealFilter(model: model)
        }
        view.hiddenComplete = { [weak self]() in
            self?.priceBtn.isSelected = false
        }
        return view
    }()
    var selectprice : SPPriceRange?{
        didSet{
            if let type = selectprice?.type , type != SPPirceRangeType.all {
                self.priceBtn.setTitle(sp_getString(string:selectprice?.showPrice).count > 0  ? sp_getString(string: selectprice?.showPrice) : "价格区间", for: UIControlState.normal)
            }else{
                self.priceBtn.setTitle("价格区间", for: UIControlState.normal)
            }
        }
    }
    var priceArray : [SPPriceRange]?
     var defaultBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
        sp_sendPriceRange()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.defualtBtn)
        self.addSubview(self.salesBtn)
        self.addSubview(self.auctionBtn)
        self.addSubview(self.priceBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.defualtBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.equalTo(self.salesBtn.snp.width).offset(0)
        }
        self.salesBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.defualtBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.defualtBtn).offset(0)
            maker.width.equalTo(self.auctionBtn).offset(0)
        }
        self.auctionBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.salesBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.salesBtn).offset(0)
            maker.width.equalTo(self.priceBtn).offset(0)
          
        }
        self.priceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.auctionBtn.snp.right).offset(0)
            maker.top.bottom.equalTo(self.auctionBtn).offset(0)
            maker.right.equalTo(self.snp.right).offset(-30)
            
        }
    }
    deinit {
        
    }
}
extension SPShopConditionView {
    @objc fileprivate func sp_clickDefault(){
        self.defualtBtn.isSelected = !self.defualtBtn.isSelected
        sp_removeFilter()
    }
    @objc fileprivate func sp_clickSales(){
          self.salesBtn.isSelected = !self.salesBtn.isSelected
        sp_removeFilter()
    }
    @objc fileprivate func sp_clickAuction(){
          self.auctionBtn.isSelected = !self.auctionBtn.isSelected
        sp_removeFilter()
    }
    @objc fileprivate func sp_clickPrice(){
        self.priceBtn.isSelected = true
        sp_show(selectModel: self.selectprice, list: self.priceArray)
    }
    fileprivate func sp_show(selectModel : Any?,list : [Any]?){
        self.conditionFilterView.dataAraay = list
        self.conditionFilterView.selectModel = selectModel
        self.conditionFilterView.sp_reload()
        if self.conditionFilterView?.superview == nil {
            self.superview?.addSubview(self.conditionFilterView)
            self.conditionFilterView?.snp.makeConstraints({ (maker) in
                maker.left.right.equalTo(self.superview!).offset(0)
                maker.top.equalTo(self.snp.bottom).offset(0)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo((self.superview?.safeAreaLayoutGuide.snp.bottom)!).offset(0)
                } else {
                    // Fallback on earlier versions
                    maker.bottom.equalTo((self.superview?.snp.bottom)!).offset(0)
                }
            })
        }
    }
    fileprivate func sp_dealFilter(model : Any?){
        self.selectprice = model as? SPPriceRange
         sp_dealDefaultBlock()
        sp_removeFilter()
    }
    fileprivate func sp_removeFilter(){
        self.priceBtn.isSelected = false
         self.conditionFilterView.removeFromSuperview()
    }
    fileprivate func sp_dealDefaultBlock(){
        guard let block = self.defaultBlock else {
            return
        }
        block()
    }
    fileprivate func sp_sendPriceRange(){
        var list = [SPPriceRange]()
        list.append(SPPriceRange.sp_init(maxPrice: "", minPrice: "",type: SPPirceRangeType.all))
        list.append(SPPriceRange.sp_init(maxPrice: "999", minPrice: nil,type: SPPirceRangeType.range900))
        list.append(SPPriceRange.sp_init(maxPrice: "2999", minPrice: "1000",type: SPPirceRangeType.range2999))
        list.append(SPPriceRange.sp_init(maxPrice: "4999", minPrice: "3000",type: SPPirceRangeType.range4999))
        list.append(SPPriceRange.sp_init(maxPrice: "9999", minPrice: "5000",type: SPPirceRangeType.range9999))
        list.append(SPPriceRange.sp_init(maxPrice: nil, minPrice: "10000",type: SPPirceRangeType.range10000))
        self.priceArray = list
    }
}
