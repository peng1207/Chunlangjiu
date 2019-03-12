//
//  SPPersionCompanyAuthInfoView.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/9.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class SPPersonCompanyAuthInfoView:  UIView{
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.text = "企业认证资料"
        return label
    }()
    fileprivate lazy var companyNameView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "企业名称"
        view.sp_nextImg(isHidden: true)
        return view
    }()
    fileprivate lazy var nameView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "法人名称"
        view.sp_nextImg(isHidden: true)
        return view
    }()
    fileprivate lazy var timeView : SPPersonalSelectView = {
        let view = SPPersonalSelectView()
        view.titleLabel.text = "成立时间"
        view.sp_nextImg(isHidden: true)
        return view
    }()
    fileprivate lazy var addressView : SPPersonalAdaptationView = {
        let view = SPPersonalAdaptationView()
        view.titleLabel.text = "经营地址"
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sp_setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func sp_setupData(){
        self.companyNameView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.company_name)
        self.nameView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.representative)
      
        if   let time =  Int(sp_getString(string: SPAPPManager.instance().memberModel?.establish_date)) {
            self.timeView.contentLabel.text = sp_getString(string: SPDateManager.sp_dateString(to: SPDateManager.sp_date(to: TimeInterval(exactly: time))))
        }else {
            self.timeView.contentLabel.text = ""
        }
        
       
//        self.addressView.contentLabel.text = sp_getString(string: SPAPPManager.instance().memberModel?.company_area)
       
    }
    /// 添加UI
    fileprivate func sp_setupUI(){
        self.addSubview(self.titleLabel)
        self.addSubview(self.companyNameView)
        self.addSubview(self.nameView)
        self.addSubview(self.timeView)
//        self.addSubview(self.addressView)
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self).offset(22)
            maker.right.equalTo(self).offset(-17)
            maker.height.equalTo(36)
            maker.top.equalTo(self).offset(0)
        }
        self.companyNameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self).offset(0)
            maker.height.equalTo(40)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(0)
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.companyNameView).offset(0)
            maker.top.equalTo(self.companyNameView.snp.bottom).offset(0)
        }
        self.timeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
             maker.bottom.equalTo(self.snp.bottom).offset(0)
        }
//        self.addressView.snp.makeConstraints { (maker) in
//            maker.left.right.equalTo(self.timeView).offset(0)
//            maker.height.greaterThanOrEqualTo(0)
//            maker.top.equalTo(self.timeView.snp.bottom).offset(0)
//            maker.bottom.equalTo(self.snp.bottom).offset(0)
//        }
    }
    deinit {
        
    }
}
