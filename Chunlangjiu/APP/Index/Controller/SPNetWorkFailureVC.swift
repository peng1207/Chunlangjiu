//
//  SPNetWorkFailureVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/22.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPNetWorkFailureVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0;
        label.text = "您的设备未启用移动网络或Wi-Fi网络"
        return label
    }()
    fileprivate lazy var contentLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0;
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "如需要连接到互联网，可以参照以下方法：\n", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "在设备的", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "“设置”", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: "-", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "“Wi-Fi网络”", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: "设置面板中选择一个可用的Wi-Fi热点接入。", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "\n在设备的", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "“设置”", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: "中启用", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "蜂窝数据", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        att.append(NSAttributedString(string: "(启用后运营商可能会收取数据通信费用)。", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        att.append(NSAttributedString(string: "\n\n如果您已接入Wi-Fi网络：\n请检查您所连接的Wi-Fi热点是否已接入互联网，或该热点是否已允许您的设备访问互联网。", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let infoDic : [String : Any]?  = Bundle.main.infoDictionary
        var name = ""
        if let dic = infoDic {
            let version = dic["CFBundleShortVersionString"]
            name = sp_getString(string: dic["CFBundleDisplayName"])
        }
        att.append(NSAttributedString(string: "\n\n如果您已开启蜂窝移动数据：\n请检查蜂窝移动网络是否允许“\(sp_getString(string: name))”访问移动网络", attributes: [NSAttributedStringKey.font: sp_getFontSize(size: 14),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 //大小调整
        att.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, att.length))
        label.attributedText = att
        return label
    }()
    
    
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
        self.navigationItem.title = "网络出现问题"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.contentLabel)
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
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(15)
            maker.right.equalTo(self.scrollView).offset(-15)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.scrollView).offset(20)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.contentLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.titleLabel).offset(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
