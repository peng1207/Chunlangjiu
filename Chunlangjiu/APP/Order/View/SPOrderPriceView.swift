//
//  SPOrderPriceView.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/30.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPOrderPriceView:  UIView{
    
    fileprivate lazy var totalView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "商品总额："
        return view
    }()
    fileprivate lazy var freeView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "配送费："
        return view
    }()
     lazy var offerView : SPOrderRightView = {
        let view = SPOrderRightView()
        view.titleLabel.text = "当前我的出价："
        view.isHidden = true
        view.btn.isHidden = false
        view.btn.setTitle("  修改出价  ", for: UIControlState.normal)
        
        return view
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var paymemntLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate var payMementHeight : Constraint!
    fileprivate var totalTop  : Constraint!
    fileprivate var totalHeight : Constraint!
    fileprivate var freeTop : Constraint!
    fileprivate var freeHeight : Constraint!
    fileprivate var offerTop : Constraint!
    fileprivate var offerHeight : Constraint!
    fileprivate var lineTop : Constraint!
    var detaileModel : SPOrderDetaileModel?{
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
        if   sp_getString(string: detaileModel?.auctionitem_id).count > 0 {
            self.totalView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.starting_price))"
            if let status = Bool(sp_getString(string: detaileModel?.auction_status)) ,  status == false{
                 self.freeView.contentLabel.text = "保密出价"
            }else{
                 self.freeView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.max_price))"
            }
            self.offerView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.original_bid))"
            self.offerView.isHidden = false
            self.totalView.isHidden = false
            self.freeView.isHidden = false
            self.totalView.titleLabel.text = "商品起拍价："
            self.freeView.titleLabel.text = "当前最高出价："
            self.offerTop.update(offset: 8)
            self.offerHeight.update(offset: 16)
            var isPay = false
            if let isP = Bool(sp_getString(string: detaileModel?.is_pay)), isP == true{
                isPay = true
            }
            
            let payAtt = NSMutableAttributedString()
            let payTitle = NSAttributedString(string: isPay ? "已付定金：" :"应付定金：", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)])
            payAtt.append(payTitle)
            let payValue = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.pledge))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 16),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)])
            payAtt.append(payValue)
            self.paymemntLabel.attributedText = payAtt
            if sp_getString(string: detaileModel?.status) == SP_AUCTION_0 || sp_getString(string: detaileModel?.status) == SP_AUCTION_1{
                self.offerView.btn.isHidden = false
            }else{
                self.offerView.btn.isHidden = true
            }
        }else{
            var isAs = false
            if let isA =   self.detaileModel?.sp_isAfterSales(), isA == true {
                isAs = true
                self.totalTop.update(offset: 0)
                self.totalHeight.update(offset: 0)
                self.freeTop.update(offset: 0)
                self.freeHeight.update(offset: 0)
                self.lineTop.update(offset: 0)
            }else{
                self.totalTop.update(offset: 13)
                self.totalHeight.update(offset: 16)
                self.freeTop.update(offset: 8)
                self.freeHeight.update(offset: 16)
                self.lineTop.update(offset: 15)
            }
            
            self.totalView.isHidden = isAs
            self.freeView.isHidden = isAs
            self.lineView.isHidden = isAs
            
            self.offerView.isHidden = true
            self.totalView.titleLabel.text = "商品总额："
            self.freeView.titleLabel.text = "配送费："
             self.offerTop.update(offset: 0)
            self.totalView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.total_fee))"
            self.freeView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.post_fee))"
            
            let payAtt = NSMutableAttributedString()
            let payTitle = NSAttributedString(string: isAs ? "退款金额：" :"实付金额：", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)])
            payAtt.append(payTitle)
            let payValue = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: detaileModel?.payment))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 16),NSAttributedStringKey.foregroundColor: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)])
            payAtt.append(payValue)
            self.paymemntLabel.attributedText = payAtt
        }
        
        
      
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.totalView)
        self.addSubview(self.freeView)
        self.addSubview(self.offerView)
        self.addSubview(self.paymemntLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.totalView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.totalTop = maker.top.equalTo(self).offset(13).constraint
            self.totalHeight = maker.height.equalTo(16).constraint
        }
        self.freeView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.totalView).offset(0)
            self.freeTop = maker.top.equalTo(self.totalView.snp.bottom).offset(8).constraint
            self.freeHeight = maker.height.equalTo(16).constraint
        }
        self.offerView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            self.offerTop = maker.top.equalTo(self.freeView.snp.bottom).offset(0).constraint
            self.offerHeight = maker.height.equalTo(0).constraint
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
           self.lineTop = maker.top.equalTo(self.offerView.snp.bottom).offset(15).constraint
        }
        self.paymemntLabel.snp.makeConstraints { (maker) in
             maker.right.equalTo(self).offset(-10)
            maker.top.equalTo(self.lineView.snp.bottom).offset(0)
            self.payMementHeight = maker.height.equalTo(44).constraint
            maker.left.equalTo(self.snp.left).offset(22)
            maker.bottom.equalTo(self).offset(0)
        }
    }
    deinit {
        
    }
}
