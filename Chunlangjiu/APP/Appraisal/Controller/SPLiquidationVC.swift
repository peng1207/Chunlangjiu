//
//  SPLiquidationVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/4/23.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class  SPLiquidationVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "如何快速变现？"
        return label
    }()
    fileprivate lazy var firstView : UIView = {
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "选择鉴定师进行在线估价", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        let view = sp_setupContentView(title: "在线估价", content: att)
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var secondView : UIView = {
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "平台将在24小时之内与您联系，注意保持手机畅通\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
         att.append(NSAttributedString(string: "您可拨打全国热线“", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
         att.append(NSAttributedString(string: "400-189-0095", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
        att.append(NSAttributedString(string: "”或添加客服微信“", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
         att.append(NSAttributedString(string: "chunlang9", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
         att.append(NSAttributedString(string: "”联系客服", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 10),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: att.length))
        let view = sp_setupContentView(title: "平台联系", content: att)
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var thirdView : UIView = {
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "平台会尽快安排该城市鉴定师进行名酒回收服务，请您耐心等待。", attributes: [NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue),NSAttributedStringKey.font : sp_getFontSize(size: 10)]))
        let view = sp_setupContentView(title: "上门服务", content: att)
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var firstLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.text = "1"
        label.sp_cornerRadius(cornerRadius: 6)
        return label
    }()
    fileprivate lazy var secondLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.text = "2"
        label.sp_cornerRadius(cornerRadius: 6)
        return label
    }()
    fileprivate lazy var thirdLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 10)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.text = "3"
        label.sp_cornerRadius(cornerRadius: 6)
        return label
    }()
    fileprivate lazy var firstLineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
    }()
    fileprivate lazy var secondLineView : UIView = {
        let view = sp_getLineView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        return view
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
        self.navigationItem.title = "快速变现"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.titleLabel)
        self.scrollView.addSubview(self.firstView)
        self.scrollView.addSubview(self.secondView)
        self.scrollView.addSubview(self.thirdView)
        self.scrollView.addSubview(self.firstLabel)
        self.scrollView.addSubview(self.secondLabel)
        self.scrollView.addSubview(self.thirdLabel)
        self.scrollView.addSubview(self.firstLineView)
        self.scrollView.addSubview(self.secondLineView)
        self.sp_addConstraint()
    }
    fileprivate func sp_setupContentView(title :String ,content : NSAttributedString)->UIView{
        let view = UIView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.font = sp_getFontSize(size: 13)
        titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        let contentLabel = UILabel()
        contentLabel.attributedText = content
        contentLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(view).offset(18)
            maker.right.equalTo(view).offset(-18)
            maker.top.equalTo(view).offset(9)
            maker.height.greaterThanOrEqualTo(0)
        }
        contentLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(titleLabel).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(view.snp.bottom).offset(-12)
        }
        
        return view
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
            maker.width.equalTo(self.scrollView.snp.width).offset(-20)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.scrollView.snp.top).offset(29)
        }
        self.firstView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(78)
            maker.right.equalTo(self.scrollView.snp.right).offset(-78)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.titleLabel.snp.bottom).offset(28)
        }
        self.secondView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.firstView).offset(0)
            maker.top.equalTo(self.firstView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.thirdView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.secondView).offset(0)
            maker.top.equalTo(self.secondView.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-28)
        }
        self.firstLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(47)
            maker.width.height.equalTo(12)
            maker.top.equalTo(self.firstView.snp.top).offset(4)
        }
        self.secondLabel.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.firstLabel).offset(0)
            maker.top.equalTo(self.secondView.snp.top).offset(4)
        }
        self.thirdLabel.snp.makeConstraints { (maker) in
            maker.left.width.height.equalTo(self.secondLabel).offset(0)
            maker.top.equalTo(self.thirdView.snp.top).offset(4)
        }
        self.firstLineView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.firstLabel.snp.centerX).offset(0)
            maker.width.equalTo(sp_lineHeight)
            maker.top.equalTo(self.firstLabel.snp.bottom).offset(0)
            maker.bottom.equalTo(self.secondLabel.snp.top).offset(0)
        }
        self.secondLineView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.firstLineView).offset(0)
            maker.centerX.equalTo(self.firstLineView.snp.centerX).offset(0)
            maker.top.equalTo(self.secondLabel.snp.bottom).offset(0)
            maker.bottom.equalTo(self.thirdLabel.snp.top).offset(0)
        }
        
    }
    deinit {
        
    }
}
