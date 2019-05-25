//
//  SPConfirmAuctionTipsView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/25.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPConfirmAuctionTipsView:  UIView{
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var confirmOrder : SPConfirmOrderModel?{
        didSet{
            sp_setupData()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "该拍品需交纳定金\(sp_getString(string: self.confirmOrder?.pledge))。\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "建议您使用", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
          att.append(NSAttributedString(string: "余额支付、", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        if SPThridManager.sp_isInstallWX() {
             att.append(NSAttributedString(string: "微信支付、", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        }
        att.append(NSAttributedString(string: "支付宝支付", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
//        att.append(NSAttributedString(string: "、银联支付", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        att.append(NSAttributedString(string: "确保账户有足够的钱款哦！", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        self.contentLabel.attributedText = att
        
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
       self.addSubview(self.contentLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(15)
            maker.right.equalTo(self).offset(-15)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self).offset(25)
            maker.bottom.equalTo(self).offset(-39)
        }
    }
    deinit {
        
    }
}
