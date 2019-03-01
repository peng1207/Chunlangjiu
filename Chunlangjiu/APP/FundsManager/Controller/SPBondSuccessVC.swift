//
//  SPbondSuccessVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/19.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPBondSuccessVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var imgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_bond_success")
        return view
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("返回会员中心", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickBackMember), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("查看星级卖家特权", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    var isRevoke : Bool = false
    var bondPrice : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_setupData()
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
    /// 赋值
    fileprivate func sp_setupData(){
        self.navigationItem.title = self.isRevoke ? "撤销保证金" : "交纳保证金"
        if self.isRevoke {
            self.canceBtn.setTitle("取消撤销申请", for: UIControlState.normal)
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "您的撤销保证金申请已提交成功！\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            att.append(NSAttributedString(string: "平台处理时间为1~3个工作日，请您耐心等待！\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
              att.append(NSAttributedString(string: "撤销的保证金将直接退回到您的可用余额！", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5 //大小调整
             paragraphStyle.alignment = .center
            att.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, att.length))
            tipLabel.attributedText = att
        }else{
            let att = NSMutableAttributedString()
            att.append(NSAttributedString(string: "您已成功交纳保证金，升级为星级卖家！\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            att.append(NSAttributedString(string: "交纳金额：", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
            att.append(NSAttributedString(string: "\(SP_CHINE_MONEY)\(sp_getString(string: self.bondPrice))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)]))
            let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 5 //大小调整
            paragraphStyle.alignment = .center
            att.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, att.length))
            self.tipLabel.attributedText = att
            self.canceBtn.setTitle("查看星级卖家特权", for: UIControlState.normal)
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.tipLabel)
        self.contentView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    override func sp_clickBackAction() {
        self.sp_clickBackMember()
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
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.scrollView.snp.top).offset(5)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-5)
        }
        self.imgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(34)
            maker.height.equalTo(34)
            maker.top.equalTo(self.contentView).offset(24)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(10)
            maker.right.equalTo(self.contentView).offset(-10)
            maker.top.equalTo(self.imgView.snp.bottom).offset(17)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(33)
            maker.top.equalTo(self.tipLabel.snp.bottom).offset(37)
            maker.height.equalTo(45)
            maker.width.equalTo(self.backBtn.snp.width).offset(0)
            maker.bottom.equalTo(self.contentView.snp.bottom).offset(-26)
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.canceBtn.snp.right).offset(29)
            maker.top.height.equalTo(self.canceBtn).offset(0)
            maker.right.equalTo(self.contentView).offset(-33)
        }
    }
    deinit {
        
    }
}
extension SPBondSuccessVC {
    @objc fileprivate func sp_clickBackMember(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    @objc fileprivate func sp_clickCance(){
        if self.isRevoke {
            sp_depoistCanceRequest()
        }else{
            let privilegeVC = SPBuyerPrivilegeVC()
            self.navigationController?.pushViewController(privilegeVC, animated: true)
        }
    }
}
extension SPBondSuccessVC {
    
    fileprivate func sp_depoistCanceRequest(){
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getDepositCance(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : code == SP_Request_Code_Success ? "取消撤销申请成功" : "取消撤销申请失败")
            if code == SP_Request_Code_Success{
                self?.sp_clickBackMember()
            }
            
        }
    }
    
}
