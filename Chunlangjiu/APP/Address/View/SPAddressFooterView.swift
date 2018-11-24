//
//  SPAddressFooterView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/17.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

typealias SPAddressDeleteBlock = (_ model : SPAddressModel?) -> Void
typealias SPAddressSelectBlock = (_ model : SPAddressModel?) -> Void

class SPAddressFooterView:  UITableViewHeaderFooterView{
    
    fileprivate lazy var footerView : SPAddressDefautView = {
        let view = SPAddressDefautView()
        view.backgroundColor = UIColor.white
        return view
    }()
    var addressModel : SPAddressModel?{
        didSet{
         self.sp_setupData()
        }
    }
    var selectBlock : SPAddressSelectBlock?
    var deleteBlock : SPAddressDeleteBlock?
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 赋值
    fileprivate func sp_setupData(){
        if let a = self.addressModel {
            self.footerView.selectBtn.isSelected = a.def_addr == 1 ? true : false
        }else{
             self.footerView.selectBtn.isSelected = false
        }
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.contentView.addSubview(self.footerView)
        self.footerView.selectBtn.addTarget(self, action: #selector(sp_clickSelectAction), for: UIControlEvents.touchUpInside)
        self.footerView.deleteBtn.addTarget(self, action: #selector(sp_clickDeleteAction), for: UIControlEvents.touchUpInside)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.footerView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.contentView).offset(0)
            maker.height.equalTo(44)
        }
        
    }
    deinit {
        
    }
}

import UIKit
import SnapKit
class SPAddressDefautView:  UIView{
    
     lazy var selectBtn : UIButton  = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "address_set_default_normal"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "address_set_default_select"), for: UIControlState.selected)
        btn.setTitle("设置为默认地址", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 12)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSelectAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
     lazy var deleteBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "address_delete"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickDeleteAction), for: UIControlEvents.touchUpInside)
        return btn
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
        self.addSubview(self.selectBtn)
        self.addSubview(self.deleteBtn)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.selectBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.snp.left).offset(10)
            maker.width.height.greaterThanOrEqualTo(0)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
      
        self.deleteBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.snp.right).offset(-23)
            maker.width.equalTo(21)
            maker.height.equalTo(21)
            maker.centerY.equalTo(self.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAddressDefautView {
    @objc fileprivate func sp_clickSelectAction(){
        self.selectBtn.isSelected = !self.selectBtn.isSelected
    }
    @objc fileprivate func sp_clickDeleteAction(){
        
    }
    
}
extension SPAddressFooterView {
    @objc fileprivate func sp_clickSelectAction(){
        guard let block = self.selectBlock else {
            return
        }
        block(self.addressModel)
    }
    @objc fileprivate func sp_clickDeleteAction(){
        guard let block = self.deleteBlock else {
            return
        }
        block(self.addressModel)
    }
    
}
