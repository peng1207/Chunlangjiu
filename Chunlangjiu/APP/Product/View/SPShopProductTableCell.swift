//
//  SPShopProductTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPShopProductCellBtnComplete = (_ type : SP_Product_Cell_Btn_Type,_ model : SPProductModel?)->Void

class SPShopProductTableCell: UITableViewCell {
    fileprivate lazy var cellView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var timeLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    fileprivate lazy var labelView : SPLabelView = {
        let view = SPLabelView()
        return view
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var lookDetBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("查看详情", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickLookDet), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var reasonBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("查看原因", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 7.5)
        btn.titleLabel?.font = sp_getFontSize(size: 10)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickReason), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var editorBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("编辑", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 7.5)
        btn.titleLabel?.font = sp_getFontSize(size: 10)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickEdit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("修改", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.isHidden = true
                btn.addTarget(self, action: #selector(sp_clickEdit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var upperBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("上架", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.isHidden = true
                btn.addTarget(self, action: #selector(sp_clickUpper), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var lowerBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("下架", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.isHidden = true
                btn.addTarget(self, action: #selector(sp_clickLower), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var setAuctionBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("设置为竞拍商品", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.titleLabel?.font = sp_getFontSize(size: 13)
        btn.isHidden = true
                btn.addTarget(self, action: #selector(sp_clickSetAuction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var auctionImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_auction_end")
        view.isHidden = true
        return view
    }()
    fileprivate var titleTop : Constraint!
    fileprivate var labelHeight : Constraint!
    fileprivate var labelTop : Constraint!
    var productModel : SPProductModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var clickBlock : SPShopProductCellBtnComplete?
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
        self.titleLabel.text = sp_getString(string: self.productModel?.title)
        self.iconImgView.sp_cache(string: sp_getString(string: self.productModel?.image_default_id), plImage: sp_getDefaultImg())
        self.labelView.listArray = self.productModel?.sp_getLabel()
        if sp_getArrayCount(array: self.labelView.listArray) > 0 {
            self.labelTop.update(offset: 9)
            self.labelHeight.update(offset: 15)
        }else{
            self.labelTop.update(offset: 0)
            self.labelHeight.update(offset: 0)
        }
        sp_setAllBtnHidden()
        self.tipsLabel.attributedText = nil
        self.auctionImgView.isHidden = true
        if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.sale.rawValue {
            self.lowerBtn.isHidden = false
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.warehouse.rawValue {
            self.editBtn.isHidden = false
            self.upperBtn.isHidden = false
            self.setAuctionBtn.isHidden = false
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.review_pending.rawValue {
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "审核状态：", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 11)]))
             att.append(NSAttributedString(string: "审核中", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 11)]))
            self.tipsLabel.attributedText = att
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.revice_refuse.rawValue {
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "审核状态：", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 11)]))
            att.append(NSAttributedString(string: "驳回", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 11)]))
            self.tipsLabel.attributedText = att
            self.reasonBtn.isHidden = false
            self.editorBtn.isHidden = false
        }
        if let auctionState = self.productModel?.isAuction , auctionState == true {
            self.sp_setAllBtnHidden()
           if sp_getString(string: productModel?.status) == SP_Product_Auction_Status.active.rawValue {
                // 竞拍还没结束
                 self.titleTop.update(offset: 8)
                 self.lookDetBtn.isHidden = false
                if let second = self.productModel?.second {
                    let date : (day:String,hour : String,minue : String,second : String) = sp_change(second: second)
                    let timeAtt = NSMutableAttributedString()
                    timeAtt.append(NSAttributedString(string: "距离结束：", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "\(sp_getString(string: date.day))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "天", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 9),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "\(sp_getString(string: date.hour))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "时", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 9),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "\(sp_getString(string: date.minue))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "分", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 9),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "\(sp_getString(string: date.second))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
                     timeAtt.append(NSAttributedString(string: "秒", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 9),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
                    self.timeLabel.attributedText = timeAtt
                    self.timeLabel.isHidden = false
                }
                
            }else if sp_getString(string: productModel?.status) == SP_Product_Auction_Status.stop.rawValue{
                self.timeLabel.attributedText = nil
                self.auctionImgView.isHidden = false
                 self.timeLabel.isHidden = true
                // 竞拍结束
                self.titleTop.update(offset: 0)
           }else {
                self.timeLabel.attributedText = nil
                self.auctionImgView.isHidden = true
                self.timeLabel.isHidden = true
                // 竞拍未开始
                self.titleTop.update(offset: 0)
            }
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "最高出价：", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 13)]))
            if sp_getString(string: productModel?.max_price).count > 0 {
                 att.append(NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: productModel?.max_price))", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
            }else{
                 att.append(NSAttributedString(string: "暂无出价", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
            }
           
            self.tipsLabel.attributedText = att
            sp_layoutTips(isAuction: true)
        }else{
            self.timeLabel.attributedText = nil
             self.timeLabel.isHidden = true
            self.titleTop.update(offset: 0)
            sp_layoutTips(isAuction: false)
        }
    }
    fileprivate func sp_layoutTips(isAuction : Bool){
        self.tipsLabel.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            if isAuction {
                 maker.top.equalTo(self.labelView.snp.bottom).offset(12)
            }else {
                maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
            }
           
        }
    }
    /// 设置所有的按钮隐藏
    fileprivate func sp_setAllBtnHidden(){
        self.lowerBtn.isHidden = true
        self.lookDetBtn.isHidden = true
        self.editBtn.isHidden = true
        self.upperBtn.isHidden = true
        self.reasonBtn.isHidden = true
        self.setAuctionBtn.isHidden = true
        self.editorBtn.isHidden = true
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.iconImgView)
        self.cellView.addSubview(self.timeLabel)
        self.cellView.addSubview(self.titleLabel)
        self.cellView.addSubview(self.labelView)
        self.cellView.addSubview(self.tipsLabel)
        self.cellView.addSubview(self.lowerBtn)
        self.cellView.addSubview(self.lookDetBtn)
        self.cellView.addSubview(self.auctionImgView)
        self.cellView.addSubview(self.editBtn)
        self.cellView.addSubview(self.upperBtn)
        self.cellView.addSubview(self.reasonBtn)
        self.cellView.addSubview(self.editorBtn)
        self.cellView.addSubview(self.setAuctionBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.cellView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.contentView).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-10)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cellView.snp.left).offset(12)
            maker.top.equalTo(self.cellView.snp.top).offset(12)
            maker.width.height.equalTo(100)
        }
        self.timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.iconImgView.snp.right).offset(12)
            maker.right.equalTo(self.cellView.snp.right).offset(-12)
            maker.top.equalTo(self.iconImgView.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.timeLabel).offset(0)
            self.titleTop = maker.top.equalTo(self.timeLabel.snp.bottom).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.labelView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
           self.labelHeight = maker.height.equalTo(15).constraint
           self.labelTop = maker.top.equalTo(self.titleLabel.snp.bottom).offset(10).constraint
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.labelView.snp.bottom).offset(12)
        }
        self.lookDetBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(75)
            maker.height.equalTo(20)
            maker.bottom.equalTo(self.cellView.snp.bottom).offset(-8)
            maker.right.equalTo(self.cellView.snp.right).offset(-12)
        }
        self.reasonBtn.snp.makeConstraints { (maker) in
           
            if sp_isLargeScreen() {
                 maker.right.equalTo(editorBtn.snp.left).offset(-10)
                 maker.width.equalTo(60)
            }else{
                 maker.right.equalTo(editorBtn.snp.left).offset(-5)
                 maker.width.equalTo(50)
            }
           
            maker.height.equalTo(15)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
        }
        self.editorBtn.snp.makeConstraints { (maker) in
            if sp_isLargeScreen() {
                maker.right.equalTo(self.cellView.snp.right).offset(-11);
                maker.width.equalTo(39)
            }else{
                maker.right.equalTo(self.cellView.snp.right).offset(-6);
                maker.width.equalTo(35)
            }
           
            maker.height.equalTo(15)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
        }
        self.editBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.tipsLabel.snp.left).offset(0)
            maker.width.equalTo(50)
            maker.height.equalTo(20)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
        }
        self.upperBtn.snp.makeConstraints { (maker) in
            maker.width.height.bottom.equalTo(self.editBtn).offset(0)
            maker.left.equalTo(self.editBtn.snp.right).offset(11)
        }
        self.setAuctionBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
            maker.height.equalTo(20)
            if sp_isLargeScreen() {
                maker.left.equalTo(self.upperBtn.snp.right).offset(11)
                maker.bottom.equalTo(self.upperBtn.snp.bottom).offset(0)
            }else{
                maker.right.equalTo(self.cellView.snp.right).offset(-12)
                maker.bottom.equalTo(self.cellView.snp.bottom).offset(-5)
            }
        }
        self.lowerBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.height.equalTo(20)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
            maker.right.equalTo(self.cellView.snp.right).offset(-12)
        }
        self.auctionImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(68)
            maker.height.equalTo(51)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
            maker.right.equalTo(self.cellView.snp.right).offset(-11)
        }
    }
    deinit {
        
    }
}
extension SPShopProductTableCell {
    
    @objc fileprivate func sp_clickEdit(){
        sp_dealComplete(tyep: SP_Product_Cell_Btn_Type.edit)
    }
    @objc fileprivate func sp_clickLower(){
        sp_dealComplete(tyep: SP_Product_Cell_Btn_Type.lower)
    }
    @objc fileprivate func sp_clickUpper(){
        sp_dealComplete(tyep: SP_Product_Cell_Btn_Type.upper)
    }
    @objc fileprivate func sp_clickLookDet(){
        sp_dealComplete(tyep: SP_Product_Cell_Btn_Type.lookDet)
    }
    @objc fileprivate func sp_clickReason(){
        sp_dealComplete(tyep: SP_Product_Cell_Btn_Type.reason)
    }
    @objc fileprivate func sp_clickSetAuction(){
        sp_dealComplete(tyep: .setAuction)
    }
    fileprivate func sp_dealComplete(tyep : SP_Product_Cell_Btn_Type){
        guard let block = self.clickBlock else {
            return
        }
        block(tyep,self.productModel)
    }
}
