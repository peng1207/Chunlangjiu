//
//  SPFansListHeadView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/14.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPFansListHeadView:  UIView{
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var numtitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "粉丝数量"
        return label
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var priceTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "累计总佣金"
        return label
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.text = "佣金直接进入您的账户余额"
        label.textAlignment = .right
        return label
    }()
    var fansModel : SPFansModel?{
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
        self.numLabel.text = sp_getString(string: self.fansModel?.fans_sum).count > 0 ?sp_getString(string: self.fansModel?.fans_sum) : "0"
        self.priceLabel.text = sp_getString(string: self.fansModel?.commission_sum).count > 0 ? sp_getString(string: self.fansModel?.commission_sum) : "0.00"
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.numLabel)
        self.contentView.addSubview(self.numtitleLabel)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.priceTitleLabel)
        self.addSubview(self.tipLabel)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self).offset(-10)
            maker.top.equalTo(self).offset(5)
            maker.height.equalTo(80)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(5)
            maker.top.equalTo(self.contentView).offset(23)
            maker.width.equalTo(self.priceLabel.snp.width).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.numLabel.snp.right).offset(5)
            maker.top.equalTo(self.numLabel).offset(0)
            maker.right.equalTo(self.contentView).offset(-5)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.numtitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.numLabel).offset(0)
            maker.top.equalTo(self.numLabel.snp.bottom).offset(13)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.priceTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.priceLabel).offset(0)
            maker.top.equalTo(self.numtitleLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self).offset(-29)
            maker.left.equalTo(self).offset(29)
            maker.top.equalTo(self.contentView.snp.bottom).offset(7)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.snp.bottom).offset(-5)
        }
    }
    deinit {
        
    }
}
