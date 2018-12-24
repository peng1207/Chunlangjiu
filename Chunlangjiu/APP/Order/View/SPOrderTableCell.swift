//
//  SPOrderTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPOrderClickAfterSaleComplet = (_ orderItemModel : SPOrderItemModel?) -> Void
class SPOrderTableCell: UITableViewCell {
     lazy var productView : SPOrderProductView = {
        let view = SPOrderProductView()
        view.afterSaleBtn.addTarget(self, action: #selector(sp_clickAfterSale), for: UIControlEvents.touchUpInside)
        return view
    }()
    /// 是否展示申请售后的按钮
    var showAfterSales : Bool = false {
        didSet{
            self.productView.showAfterSales = showAfterSales
        }
    }
    var orderItem : SPOrderItemModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var afterSaleBlock : SPOrderClickAfterSaleComplet?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.sp_setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
       self.productView.orderItem = orderItem
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.productView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPOrderTableCell{
    @objc fileprivate func sp_clickAfterSale(){
        guard let block = self.afterSaleBlock else {
            return
        }
        block(self.orderItem)
    }
}
import UIKit
import SnapKit
class SPOrderProductView  :  UIView{
    fileprivate lazy var productImageView : UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var maxPriceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.isHidden = true
        return label
    }()
    fileprivate lazy var specLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .right
        return label
    }()
   lazy var lineView : UIView = {
        return sp_getLineView()
    }()
     lazy var afterSaleBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("申请售后", for: UIControlState.normal)
        btn.setTitle("处理中", for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 14)
       
        return btn
    }()
    /// 是否展示申请售后的按钮
    var showAfterSales : Bool = false
    var orderItem : SPOrderItemModel?{
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
        self.productImageView.sp_cache(string: sp_getString(string: orderItem?.pic_path), plImage: sp_getDefaultImg())
        self.titleLabel.text = sp_getString(string: orderItem?.title)
        if sp_getString(string: orderItem?.auctionitem_id).count > 0 {
            self.numLabel.isHidden = true
            self.specLabel.isHidden = true
            let mAtt = NSMutableAttributedString()
            mAtt.append(NSAttributedString(string: "起拍价：", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            mAtt.append(NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: orderItem?.starting_price))", attributes:[NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
          
            self.priceLabel.attributedText = mAtt
            
            let maxAtt = NSMutableAttributedString()
            maxAtt.append(NSAttributedString(string: "最高出价：", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 13),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            if let status = Bool(sp_getString(string: orderItem?.auction_status)) , status == false{
                 maxAtt.append(NSAttributedString(string: "保密出价", attributes:[NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
            }else{
                 maxAtt.append(NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: orderItem?.max_price))", attributes:[NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
            }
            
           
            self.maxPriceLabel.attributedText = maxAtt
            self.maxPriceLabel.isHidden = false
        }else{
            self.priceLabel.attributedText = NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: orderItem?.price))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)])
            self.specLabel.text = sp_getString(string: orderItem?.spec_nature_info)
             self.numLabel.text = "x \(sp_getString(string: orderItem?.num))"
            self.numLabel.isHidden = false
            self.specLabel.isHidden = false
            self.maxPriceLabel.isHidden = true
        }
       
       
        if self.showAfterSales {
            
            
            if sp_getString(string: orderItem?.status) == SP_TRADE_FINISHED,let refund_enabled = self.orderItem?.refund_enabled , refund_enabled == true {
                self.afterSaleBtn.isHidden = false
                if sp_getString(string: orderItem?.aftersales_status) == SP_WAIT_SELLER_AGREE || sp_getString(string: orderItem?.aftersales_status) == SP_WAIT_SELLER_CONFIRM_GOODS || sp_getString(string: orderItem?.aftersales_status) == SP_WAIT_BUYER_RETURN_GOODS || sp_getString(string: orderItem?.aftersales_status) == SP_REFUNDING{
                    self.afterSaleBtn.isSelected = true
                }else{
                    self.afterSaleBtn.isSelected = false
                }
                if sp_getString(string: orderItem?.aftersales_status) == SP_SELLER_REFUSE_BUYER || sp_getString(string: orderItem?.aftersales_status) == SP_ReFUND_SUCCESS{
                    self.afterSaleBtn.isHidden = true
                }else{
                    self.afterSaleBtn.isHidden = false
                }
            }else{
                self.afterSaleBtn.isHidden = true
            }
        }else{
            self.afterSaleBtn.isHidden = true
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.productImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.maxPriceLabel)
        self.addSubview(self.specLabel)
        self.addSubview(self.numLabel)
        self.addSubview(self.afterSaleBtn)
        self.addSubview(self.lineView)
        self.lineView.isHidden = true
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.productImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.top.equalTo(self).offset(13)
            maker.bottom.equalTo(self).offset(-13)
            maker.width.equalTo(self.productImageView.snp.height).offset(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.right).offset(7)
            maker.top.equalTo(self).offset(12)
            maker.right.equalTo(self).offset(-19)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.left).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.maxPriceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.priceLabel.snp.left).offset(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
            maker.top.equalTo(self.priceLabel.snp.bottom).offset(3)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.specLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.priceLabel.snp.right).offset(12)
            maker.centerY.equalTo(self.priceLabel.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.titleLabel.snp.right).offset(0)
        }
        self.numLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.numLabel.snp.makeConstraints { (maker) in
            maker.width.greaterThanOrEqualTo(0)
            maker.right.equalTo(self.snp.right).offset(-18)
            maker.bottom.equalTo(self.snp.bottom).offset(-8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.afterSaleBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.numLabel.snp.left).offset(-8)
            maker.bottom.equalTo(self.snp.bottom).offset(-5)
            maker.width.equalTo(80)
            maker.height.equalTo(20)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.productImageView.snp.left).offset(0)
            maker.right.equalTo(self.numLabel.snp.right).offset(0)
            maker.bottom.equalTo(self).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
    }
    deinit {
        
    }
}

