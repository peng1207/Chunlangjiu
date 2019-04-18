//
//  SPProductTipView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/30.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPProductTipView:  UIView{
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 18)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.text = "醇狼提示"
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "尊敬的用户，您现在还是普通卖家，\n只能发布3件商品，交纳2000元保证金，\n升级成为星级卖家，享海量特权！"
        return label
    }()
    fileprivate lazy var noBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("暂时不考虑", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickNo), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var upgradeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("升级星级卖家", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickUpgrade), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var canceBlock : SPBtnClickBlock?
    fileprivate var doneBlock : SPBtnClickBlock?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func sp_show(title:String?,canceComplete:SPBtnClickBlock?=nil,doneComplete:SPBtnClickBlock?=nil){
        let view = SPProductTipView()
        view.canceBlock = canceComplete
        view.doneBlock = doneComplete
        if sp_getString(string: title).count > 0 {
            view.contentLabel.text = sp_getString(string: title)
        }
        view.backgroundColor =  SPColorForHexString(hex: SP_HexColor.color_333333.rawValue).withAlphaComponent(0.3)
        let appDeleage : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDeleage.window?.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDeleage.window!).offset(0)
        }
    }
    
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.contentLabel)
        self.contentView.addSubview(self.noBtn)
        self.contentView.addSubview(self.upgradeBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(10)
            maker.right.equalTo(self.snp.right).offset(-10)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.greaterThanOrEqualTo(sp_getstatusBarHeight())
            maker.bottom.lessThanOrEqualTo(-SP_TABBAR_HEIGHT)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.contentView).offset(28)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(49)
            maker.right.equalTo(self.contentView).offset(-49)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(35)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.noBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(40)
            maker.top.equalTo(self.contentLabel.snp.bottom).offset(24)
            maker.width.equalTo(self.upgradeBtn).offset(0)
            maker.height.equalTo(30)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-26)
        }
        self.upgradeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.noBtn.snp.right).offset(50)
            maker.top.bottom.equalTo(self.noBtn).offset(0)
            maker.right.equalTo(self.contentView).offset(-40)
        }
    }
    deinit {
        
    }
}
extension SPProductTipView {
    /// 点击不考虑
    @objc fileprivate func sp_clickNo(){
        guard let block = self.canceBlock else {
            return
        }
        block()
        sp_remove()
    }
    /// 点击升级
    @objc fileprivate func sp_clickUpgrade(){
        guard let block = self.doneBlock else {
            return
        }
        block()
        sp_remove()
    }
    /// 移除view
    fileprivate func sp_remove(){
        self.removeFromSuperview()
    }
    
}
