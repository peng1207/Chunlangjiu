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
    fileprivate lazy var lableView : SPLabelView = {
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
        view.image = UIImage(named: "public_unwinningbid")
        view.isHidden = true
        return view
    }()
    fileprivate var titleTop : Constraint!
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
        self.lableView.listArray = self.productModel?.sp_getLabel()
        sp_setAllBtnHidden()
        self.tipsLabel.attributedText = nil
        if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.sale.rawValue {
            self.lowerBtn.isHidden = false
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.warehouse.rawValue {
            self.editBtn.isHidden = false
            self.upperBtn.isHidden = false
            self.setAuctionBtn.isHidden = false
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.review_pending.rawValue {
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "审核状态：", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 13)]))
             att.append(NSAttributedString(string: "审核中", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
            self.tipsLabel.attributedText = att
        }else if sp_getString(string: self.productModel?.approve_status) == SP_Product_Type.revice_refuse.rawValue {
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "审核状态：", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 13)]))
            att.append(NSAttributedString(string: "审核驳回", attributes: [NSAttributedStringKey.foregroundColor :SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
            self.tipsLabel.attributedText = att
            self.reasonBtn.isHidden = false
        }
        if let auctionState = self.productModel?.isAuction , auctionState == true {
            self.titleTop.update(offset: 9)
        }else{
            self.titleTop.update(offset: 0)
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
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.cellView)
        self.cellView.addSubview(self.iconImgView)
        self.cellView.addSubview(self.timeLabel)
        self.cellView.addSubview(self.titleLabel)
        self.cellView.addSubview(self.lableView)
        self.cellView.addSubview(self.tipsLabel)
        self.cellView.addSubview(self.lowerBtn)
        self.cellView.addSubview(self.lookDetBtn)
        self.cellView.addSubview(self.auctionImgView)
        self.cellView.addSubview(self.editBtn)
        self.cellView.addSubview(self.upperBtn)
        self.cellView.addSubview(self.reasonBtn)
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
        self.lableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.equalTo(15)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(10)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.iconImgView.snp.bottom).offset(0)
        }
        self.lookDetBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(75)
            maker.height.equalTo(20)
            maker.bottom.equalTo(self.cellView.snp.bottom).offset(-8)
            maker.right.equalTo(self.cellView.snp.right).offset(-12)
        }
        self.reasonBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.cellView.snp.right).offset(-12)
            maker.width.equalTo(60)
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
            if sp_getScreenWidth() >= 375 {
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
