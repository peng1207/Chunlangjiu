//
//  SPBondVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPBondVC: SPBaseVC {
    
    fileprivate lazy var btnView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("缴纳保证金", for: UIControlState.normal)
        btn.setTitle("撤销保证金", for: UIControlState.selected)
        btn.setTitle("撤销保证金中", for: UIControlState.disabled)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.selected)
        btn.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)), for: UIControlState.normal)
        btn.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)), for: UIControlState.selected)
         btn.setBackgroundImage(UIImage.sp_getImageWithColor(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)), for: UIControlState.disabled)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var canceBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("取消", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickCance), for: UIControlEvents.touchUpInside)
        btn.isHidden = true
        return btn
    }()
    fileprivate lazy var priceLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "保证金金额"
        return label
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
       
        label.numberOfLines = 0
        return label
    }()
    fileprivate var model : SPDepositModel?
    fileprivate var canceWidth : Constraint!
    fileprivate var canceRight : Constraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_sendRequest()
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
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.btnView)
        self.scrollView.addSubview(self.contentView)
        self.scrollView.addSubview(self.tipsLabel)
        self.btnView.addSubview(self.submitBtn)
        self.btnView.addSubview(self.canceBtn)
        self.contentView.addSubview(self.priceLabel)
        self.contentView.addSubview(self.titleLabel)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.btnView.snp.top).offset(0)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(65)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.btnView).offset(10)
            maker.right.equalTo(self.canceBtn.snp.left).offset(-6)
            maker.centerY.equalTo(self.btnView.snp.centerY).offset(0)
            maker.height.equalTo(45)
        }
        self.canceBtn.snp.makeConstraints { (maker) in
            self.canceWidth = maker.width.equalTo(0).constraint
            maker.height.equalTo(self.submitBtn.snp.height).offset(0)
            maker.centerY.equalTo(self.btnView.snp.centerY).offset(0)
           self.canceRight = maker.right.equalTo(self.btnView.snp.right).offset(-4).constraint
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView).offset(-10)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.height.equalTo(80)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.priceLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.contentView.snp.top).offset(28)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.titleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.top.equalTo(self.priceLabel.snp.bottom).offset(8)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(24)
            maker.right.equalTo(self.scrollView.snp.right).offset(-24)
            maker.top.equalTo(self.contentView.snp.bottom).offset(23)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPBondVC {
    
    @objc fileprivate func sp_clickSubmit(){
        if self.submitBtn.isSelected {
            let revokeVC = SPRevokeBondTipVC()
            self.navigationController?.pushViewController(revokeVC, animated: true)
        }else{
            let rechargeVC = SPRechargeVC()
            rechargeVC.navigationItem.title = "缴纳保证金"
            rechargeVC.isBond = true
            rechargeVC.price = sp_getString(string: self.model?.deposit)
            self.navigationController?.pushViewController(rechargeVC, animated: true)
        }
       
    }
    @objc fileprivate func sp_clickCance(){
        sp_depoistCanceRequest()
    }
    fileprivate func sp_dealData(){
        self.priceLabel.text = sp_getString(string: self.model?.deposit)
        if sp_getString(string: self.model?.deposit_status) == "0" {
            // 没有缴纳
            self.submitBtn.isSelected = false
            self.submitBtn.isEnabled = true
            self.titleLabel.text = "保证金金额（未交纳）"
             self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 10.0
            paragraphStyle.firstLineHeadIndent = 0
            let att = NSMutableAttributedString(string: "保证金交纳说明：\n1、保证金交纳成功后，用户即可成为星级卖家，尊享海量特权。\n2、卖家升级为星级卖家，可无限发布商品，发布的商品享有优先排序功能。\n3、此操作成功后，需要短信提示。")
            att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle ,NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)], range: NSRange(location: 0, length: att.length))
            self.tipsLabel.attributedText = att
            self.canceWidth.update(offset: 0)
            self.canceRight.update(offset: -4)
            self.canceBtn.isHidden = true
        }else if sp_getString(string: self.model?.deposit_status) == "2"{
            // 正在撤销中
            self.submitBtn.isEnabled = false
            self.titleLabel.text = "保证金金额（撤销中）"
            self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 10.0
            paragraphStyle.firstLineHeadIndent = 0
            let att = NSMutableAttributedString(string: "撤销保证金后：\n1、您的卖家账户变成普通卖家，失去星级卖家的相关特权；\n2、您的撤销申请经平台审核后，保证金将从冻结金额转入账户余额， 您即可进行资金提现；撤销申请时间约为1~3个工作日；\n3、如您的撤销申请审核失败，请致电400-0000-000咨询原因，感谢您的理解与支持。")
            att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle ,NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)], range: NSRange(location: 0, length: att.length))
            self.tipsLabel.attributedText = att
            self.tipsLabel.attributedText = att
            self.canceWidth.update(offset: 93)
            self.canceRight.update(offset: -10)
            self.canceBtn.isHidden = false
        }
        else{
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 10.0
            paragraphStyle.firstLineHeadIndent = 0
            let att = NSMutableAttributedString(string: "保证金交纳权益：\n1、您已成为星级卖家，尊享海量特权。\n2、可无限发布商品。\n3、发布的商品享有优先排序功能。")
            att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle ,NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)], range: NSRange(location: 0, length: att.length))
            self.tipsLabel.attributedText = att
            self.titleLabel.text = "保证金金额（已交纳）"
            self.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
            self.submitBtn.isSelected = true
            self.submitBtn.isEnabled = true
            self.tipsLabel.attributedText = att
            self.canceWidth.update(offset: 0)
            self.canceRight.update(offset: -4)
            self.canceBtn.isHidden = true
        }
    }
    
}

extension SPBondVC {
    /// 获取保证金信息
    fileprivate func sp_sendRequest(){
        SPFundsRequest.sp_getDepostit(requestModel: self.requestModel) { [weak self](code , msg, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.model = model
                self?.sp_dealData()
            }
            
        }
    }
    
    /// 取消申请撤销保证金
    fileprivate func sp_depoistCanceRequest(){
        let request = SPRequestModel()
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getDepositCance(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : code == SP_Request_Code_Success ? "取消撤销申请成功" : "取消撤销申请失败")
            if code == SP_Request_Code_Success{
                sp_showAnimation(view: self?.view, title: nil)
                self?.sp_sendRequest()
            }
            
        }
    }
    fileprivate func sp_sendDeleteRequest(){
        
    }
}
