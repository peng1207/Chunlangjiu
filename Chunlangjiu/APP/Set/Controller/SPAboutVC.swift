//
//  SPAboutVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/13.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class  SPAboutVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var logoImgView : UIImageView = {
        let view = UIImageView()
        view.image = sp_getAppIcon()
        return view
    }()
    fileprivate lazy var versionLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        let infoDic : [String : Any]?  = Bundle.main.infoDictionary
        if let dic = infoDic {
            let version = dic["CFBundleShortVersionString"]
            let name = dic["CFBundleDisplayName"]
            label.text = "\(sp_getString(string: name))V\(sp_getString(string: version))"
        }
        return label
    }()
    fileprivate lazy var locationView : SPTextLabelView = {
        return sp_createView(title: "平台定位", content: "二手高端酒综合服务平台")
    }()
    fileprivate lazy var websiteView : SPTextLabelView = {
        return sp_createView(title: "访问醇狼官网", content: "www.chunlangjiu.com")
    }()
    fileprivate lazy var mailboxView : SPTextLabelView = {
        return sp_createView(title: "醇狼官方邮箱", content: "chunlang2018@sina.com")
    }()
    fileprivate lazy var telView : SPTextLabelView = {
        return sp_createView(title: "全国热线", content: "400-189-0095")
    }()
    
    fileprivate func sp_createView(title:String,content:String)->SPTextLabelView{
        let view = SPTextLabelView()
        view.titleLabel.text = title
        view.contentLabel.text = content
        view.contentLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        view.contentLabel.font = sp_getFontSize(size: 13)
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.sp_updateLeft(left: 131)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "关于醇狼"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.logoImgView)
        self.scrollView.addSubview(self.versionLabel)
        self.scrollView.addSubview(self.locationView)
        self.scrollView.addSubview(self.websiteView)
        self.scrollView.addSubview(self.mailboxView)
        self.scrollView.addSubview(self.telView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.logoImgView.snp.makeConstraints { (maker) in
            maker.size.equalTo(CGSize(width: 50, height: 50))
            maker.top.equalTo(self.scrollView).offset(38)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.versionLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(11)
            maker.right.equalTo(self.scrollView.snp.right).offset(-11)
            maker.top.equalTo(self.logoImgView.snp.bottom).offset(22)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.locationView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(50)
            maker.top.equalTo(self.versionLabel.snp.bottom).offset(50)
        }
        self.websiteView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.locationView).offset(0)
            maker.top.equalTo(self.locationView.snp.bottom).offset(0)
        }
        self.mailboxView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.locationView).offset(0)
            maker.top.equalTo(self.websiteView.snp.bottom).offset(0)
        }
        self.telView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.locationView).offset(0)
            maker.top.equalTo(self.mailboxView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
