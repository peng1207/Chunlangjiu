//
//  SPRechargeTableCell.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/16.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias SPRechargeComplete = (_ model : SPPayModel?)->Void

class SPRechargeTableCell: UITableViewCell {
    
    fileprivate lazy var typeImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
    fileprivate lazy var selectBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_unselect_gray"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_select_red_cor"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickSelect), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 13)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .left
        return label
    }()
    lazy var payContentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 14)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        return label
    }()
    fileprivate lazy var lineView : UIView = {
        return sp_getLineView()
    }()
    var model : SPPayModel?{
        didSet{
            sp_setupData()
        }
    }
    var clickBlock : SPRechargeComplete?
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
        self.titleLabel.text = sp_getString(string: model?.app_display_name)
        if sp_getString(string: model?.app_rpc_id) == SPPayType.wxPay.rawValue {
            self.typeImgView.image = UIImage(named: "public_pay_wx")
        }else if sp_getString(string: model?.app_rpc_id) == SPPayType.aliPay.rawValue{
            self.typeImgView.image = UIImage(named: "public_pay_ailpy")
        }else{
            self.typeImgView.image = UIImage(named: "public_pay_balance")
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.typeImgView)
        self.contentView.addSubview(self.titleLabel)
         self.contentView.addSubview(self.payContentLabel)
        self.contentView.addSubview(self.selectBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.typeImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(21)
            maker.top.equalTo(self.contentView).offset(6)
            maker.width.equalTo(30)
            maker.height.equalTo(29)
        }
         self.titleLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.typeImgView.snp.right).offset(9)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.selectBtn.snp.left).offset(-9)
        }
        self.payContentLabel.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: UILayoutConstraintAxis.horizontal)
        self.payContentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.titleLabel.snp.right).offset(4)
            maker.top.bottom.equalTo(self.contentView).offset(0)
            maker.right.equalTo(self.selectBtn.snp.right).offset(-8)
        }
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.contentView).offset(-15)
            maker.width.equalTo(20)
            maker.height.equalTo(20)
            maker.centerY.equalTo(self.contentView).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPRechargeTableCell {
    @objc fileprivate func sp_clickSelect(){
        guard let block = self.clickBlock else {
            return
        }
        block(self.model)
    }
    func sp_isSelect(select:Bool){
        self.selectBtn.isSelected = select
    }
}

