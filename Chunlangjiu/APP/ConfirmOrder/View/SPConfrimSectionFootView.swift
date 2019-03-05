//
//  SPConfirmSectionFootView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfrimSectionFootView:  UITableViewHeaderFooterView{
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var remarkLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.text = "备注"
        return label
    }()
    fileprivate lazy var remarkTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "请填写"
        textField.font = sp_getFontSize(size: 14)
         textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        textField.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: { [weak self]in
            self?.sp_dealDone()
        }, doneBlock: { [weak self] in
            self?.sp_dealDone()
        })
        return textField
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    fileprivate lazy var auctionView : UIView =  {
        let view  = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    fileprivate lazy var auctionTitleLabl : UILabel = {
        let label = UILabel()
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "出价金额", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 15)]))
        att.append(NSAttributedString(string: " \(SP_CHINE_MONEY)", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
        label.attributedText = att
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        return label
    }()
    fileprivate lazy var auctionTextField : SPTextFiled = {
        let textField = SPTextFiled()
        textField.placeholder = "请输入金额"
        textField.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        textField.font = sp_getFontSize(size: 16)
        textField.textAlignment = .right
        textField.keyboardType = UIKeyboardType.numberPad
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.inputAccessoryView = SPKeyboardTopView.sp_showView(canceBlock: {[weak self]in
            self?.sp_dealPrice()
        }, doneBlock: { [weak self] in
            self?.sp_dealPrice()
        })
        
        return textField
    }()
    fileprivate lazy var auctionLineView : UIView = {
        return sp_getLineView()
    }()
    var shopModel : SPShopModel?
    var isAuction : Bool! = false{
        didSet{
          sp_setupData()
        }
    }
    fileprivate var auctionHeight : Constraint!
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.white
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func sp_setupData(){
        self.auctionHeight.update(offset: isAuction ? 40 : 0)
        self.auctionView.isHidden = !isAuction
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "出价金额", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 15)]))
        att.append(NSAttributedString(string: " \(SP_CHINE_MONEY)", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
        if let status = Bool(sp_getString(string: shopModel?.confirm_auction_status)) , status == true {
             self.auctionTextField.placeholder = "\(SP_CHINE_MONEY)\(sp_getString(string: shopModel?.confrim_max_price).count > 0 ? sp_getString(string: shopModel?.confrim_max_price) : sp_getString(string: shopModel?.confirm_start_price))"
            att.append(NSAttributedString(string: "（出价金额需提高起拍价）", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
//             att.append(NSAttributedString(string: "（目前最高价\(SP_CHINE_MONEY)\(sp_getString(string: shopModel?.confrim_max_price).count > 0 ? sp_getString(string: shopModel?.confrim_max_price) : sp_getString(string: shopModel?.confirm_start_price))）", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
        }else{
//            self.auctionTextField.placeholder = "暗拍商品,其他出价保密"
            att.append(NSAttributedString(string: "（暗拍商品,其他出价保密）", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 12)]))
        }
        self.auctionTitleLabl.attributedText = att
       
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.tipsLabel)
        self.contentView.addSubview(self.auctionView)
        self.auctionView.addSubview(self.auctionTitleLabl)
        self.auctionView.addSubview(self.auctionTextField)
        self.auctionView.addSubview(self.auctionLineView)
        self.contentView.addSubview(self.remarkLabel)
        self.contentView.addSubview(self.remarkTextField)
        self.contentView.addSubview(self.lineView)
        self.auctionTextField.addTarget(self, action: #selector(sp_textChange), for: UIControlEvents.editingChanged)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(12)
            maker.right.equalTo(self.contentView).offset(-12)
            maker.top.equalTo(self.contentView).offset(0)
            maker.height.equalTo(0)
        }
        self.auctionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.tipsLabel.snp.bottom).offset(0)
            self.auctionHeight = maker.height.equalTo(0).constraint
        }
        self.auctionTitleLabl.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.auctionTitleLabl.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.auctionView.snp.left).offset(12)
            maker.top.bottom.equalTo(self.auctionView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.auctionTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.auctionTitleLabl.snp.right).offset(8)
            maker.right.equalTo(self.auctionView.snp.right).offset(-12)
            maker.top.bottom.equalTo(self.auctionView).offset(0)
        }
        self.auctionLineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.auctionView).offset(0)
            maker.bottom.equalTo(self.auctionView.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        self.remarkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.tipsLabel.snp.left).offset(0)
            maker.width.equalTo(80)
            maker.top.equalTo(self.auctionView.snp.bottom).offset(0)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
        self.remarkTextField.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.remarkLabel.snp.right).offset(0)
            maker.top.equalTo(self.remarkLabel.snp.top).offset(0)
            maker.height.equalTo(self.remarkLabel.snp.height).offset(0)
            maker.right.equalTo(self.contentView).offset(-12)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.remarkLabel.snp.bottom).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPConfrimSectionFootView{
    
    @objc fileprivate func  sp_textChange(){
        self.sp_dealPrice()
    }
    
    fileprivate func sp_dealDone(){
        self.shopModel?.remark = sp_getString(string: self.remarkTextField.text)
    }
    fileprivate func sp_dealPrice(){
        self.shopModel?.confrim_auction_price = sp_getString(string: self.auctionTextField.text)
    }
}
