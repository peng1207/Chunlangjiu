//
//  SPConfirmAuctionPriceView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/25.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfirmAuctionPriceView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        label.text = "定金"
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .left
        label.text = "竞拍结束后，交纳的定金将退回到您的【可用余额】"
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        let view =  sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    var confirmOrder : SPConfirmOrderModel?{
        didSet{
            sp_setupData()
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
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "\(SP_CHINE_MONEY) ", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 18),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
        att.append(NSAttributedString(string: sp_getString(string: self.confirmOrder?.pledge), attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 36),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
        self.priceLabel.attributedText = att
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        self.addSubview(self.titleLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.lineView)
        self.addSubview(self.tipsLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(14)
            maker.top.equalTo(self).offset(71)
            maker.width.greaterThanOrEqualTo(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-22)
            maker.top.equalTo(self).offset(60)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.greaterThanOrEqualTo(self.titleLabel.snp.right).offset(8)
        }
        self.lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(15)
            maker.right.equalTo(self).offset(-15)
            maker.height.equalTo(sp_lineHeight)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(43)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(16)
            maker.right.equalTo(self).offset(-16)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.lineView.snp.bottom).offset(16)
        }
    }
    deinit {
        
    }
}
