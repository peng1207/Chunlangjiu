//
//  SPConfirmFooterView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfrimFooterView:  UIView{
    
    fileprivate lazy var payView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickPayAction))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var payTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.text = "支付方式"
         label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    fileprivate lazy var payContentLabel : UILabel = {
        let label = UILabel()
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.font = sp_getFontSize(size: 14)
        label.textAlignment = .right
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    fileprivate lazy var productTotalPriceView : SPConfrimFooterContentView = {
        let view = SPConfrimFooterContentView()
        view.backgroundColor = UIColor.white
        view.titleLabel.text = "商品总额"
        return view
    }()
    fileprivate lazy var freeView : SPConfrimFooterContentView = {
        let view  = SPConfrimFooterContentView()
        view.backgroundColor = UIColor.white
        view.lineView.isHidden = false
        view.titleLabel.text = "运费"
        return view
    }()
    fileprivate lazy var autoPayView : SPConfrimFooterContentView = {
        let view  = SPConfrimFooterContentView()
        view.backgroundColor = UIColor.white
        view.lineView.isHidden = false
        view.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
//        view.titleLabel.text = "应付定金 （若落标，定金则原路退回）"
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "应付定金", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 15)]))
        att.append(NSAttributedString(string: "（若落标，定金则退回可用余额）", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue),NSAttributedStringKey.font:sp_getFontSize(size: 12)]))
        view.titleLabel.attributedText = att
        view.isHidden = true
        return view
    }()
    fileprivate lazy var autoTipLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.isHidden = true
        label.font = sp_getFontSize(size: 12)
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    
    fileprivate lazy var payNextImg : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "public_rightBack")
        return imageView
    }()
    fileprivate var autoHeight : Constraint!
    fileprivate var totalHeight : Constraint!
    fileprivate var freeHeight : Constraint!
    fileprivate var autoTop : Constraint!
    var confirmOrder : SPConfirmOrderModel?{
        didSet{
            self.sp_setupData()
        }
    }
    var isAuction : Bool! = false {
        didSet{
            self.sp_deal()
        }
    }
    var clickPayBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.payContentLabel.text = sp_getString(string: self.confirmOrder?.selectPayModel?.app_display_name)
        self.productTotalPriceView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: confirmOrder?.total?.allCostFee))"
        self.freeView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: confirmOrder?.total?.allPostfee).count > 0 ?sp_getString(string: confirmOrder?.total?.allPostfee) : "0.00" )"
        
        self.autoPayView.contentLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: confirmOrder?.pledge))"
    }
    fileprivate func sp_deal(){
        
        self.autoHeight.update(offset: isAuction ? 40 : 0)
        self.totalHeight.update(offset: isAuction ? 0 : 40)
        self.freeHeight.update(offset: isAuction ? 0 : 40)
        self.autoPayView.isHidden = !isAuction
        self.productTotalPriceView.isHidden = isAuction
        self.freeView.isHidden = isAuction
        self.autoTipLabel.isHidden = !isAuction
        if isAuction {
           
            let attributedString:NSMutableAttributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "说明：\n", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
            attributedString.append(NSAttributedString(string: "1.“出价金额”为竞拍叫价，叫价期间无需进行支付操作，请慎重出价；\n2.若您中标，则需支付商品货款，支付完成，定金退回至您的【可用余额】；\n3.买家中标后不支付竞拍货款，平台将有权不返还定金；\n4.竞拍结束，若落标，定金将及时退还到您的【可用余额】。\n", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5 //大小调整
            attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            
            self.autoTipLabel.attributedText = attributedString
            self.autoTop.update(offset: 10)
        }else{
            self.autoTipLabel.attributedText = nil
            self.autoTop.update(offset: 0)
        }
    }
    @objc fileprivate func sp_clickPayAction(){
        guard let block = self.clickPayBlock else {
            return
        }
        block()
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.payView)
        self.payView.addSubview(self.payTitleLabel)
        self.payView.addSubview(self.payContentLabel)
        self.payView.addSubview(self.payNextImg)
        self.addSubview(self.productTotalPriceView)
        self.addSubview(self.freeView)
        self.addSubview(self.autoPayView)
        self.addSubview(self.autoTipLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.payView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.equalTo(self.snp.top).offset(12)
            maker.height.equalTo(40)
        }
        self.payTitleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.payTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payView.snp.left).offset(12)
            maker.top.bottom.equalTo(self.payView).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.payContentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.payTitleLabel.snp.right).offset(12)
            maker.right.equalTo(self.payNextImg.snp.left).offset(-12)
            maker.top.bottom.equalTo(self.payView).offset(0)
        }
        self.payNextImg.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.payView.snp.right).offset(-12)
            maker.width.equalTo(9)
            maker.height.equalTo(17)
            maker.centerY.equalTo(self.payView.snp.centerY).offset(0)
        }
        self.productTotalPriceView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.top.equalTo(self.payView.snp.bottom).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            self.totalHeight = maker.height.equalTo(40).constraint
        }
        self.freeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.equalTo(self.productTotalPriceView.snp.bottom).offset(0)
            self.freeHeight = maker.height.equalTo(40).constraint
        }
        self.autoPayView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(0)
            maker.right.equalTo(self.snp.right).offset(0)
            maker.top.equalTo(self.freeView.snp.bottom).offset(0)
            self.autoHeight = maker.height.equalTo(40).constraint
            
        }
        self.autoTipLabel.snp.makeConstraints { (maker ) in
            maker.left.equalTo(self).offset(12)
            maker.right.equalTo(self).offset(-12)
            self.autoTop = maker.top.equalTo(self.autoPayView.snp.bottom).offset(10).constraint
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}

fileprivate class SPConfrimFooterContentView:  UIView{
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = NSTextAlignment.right
        label.preferredMaxLayoutWidth = sp_getScreenWidth()
        return label
    }()
    lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.contentLabel)
        self.addSubview(self.lineView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(12)
            maker.top.bottom.equalTo(self).offset(0)
            maker.width.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(8)
            maker.right.equalTo(self.snp.right).offset(-12)
            maker.top.bottom.equalTo(self).offset(0)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.bottom.equalTo(self.snp.bottom).offset(0)
            maker.height.equalTo(sp_lineHeight)
        }
        
    }
    deinit {
        
    }
}
