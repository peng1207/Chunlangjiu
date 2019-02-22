//
//  SPRevokeBondTipVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/2/19.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPRevokeBondTipVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var revokeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("撤销", for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickRevoke), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var noRevokeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("不撤销", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickNoRevoke), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var contentTipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .center
        label.text = "您确定需要撤销保证金吗？"
        return label
    }()
    fileprivate lazy var tipImgView : UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "public_revoke")
        return view
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
//        label.text = "撤销保证金后：\n1、您的卖家账户变成普通卖家，失去星级卖家的相关特权；\n2、您的撤销申请经平台审核后，保证金将从冻结金额转入账户余额， 您即可进行资金提现；撤销申请时间约为1~3个工作日；\n3、如您的撤销申请审核失败，请致电400-0000-000咨询原因，感谢您的理解与支持。\n"
        
        let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5 //大小调整
        let att = NSMutableAttributedString()
        att.append(NSAttributedString(string: "撤销保证金后：\n1、您的卖家账户变成普通卖家，失去星级卖家的相关特权；\n2、您的撤销申请经平台审核后，保证金将从冻结金额转入账户余额， 您即可进行资金提现；撤销申请时间约为1~3个工作日；\n3、如您的撤销申请审核失败，请致电400-788-9550咨询原因，感谢您的理解与支持。\n", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)]))
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
        self.navigationItem.title = "撤销保证金"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(self.tipImgView)
        self.contentView.addSubview(self.contentTipLabel)
        self.scrollView.addSubview(self.tipLabel)
        self.view.addSubview(self.revokeBtn)
        self.view.addSubview(self.noRevokeBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.revokeBtn.snp.top).offset(-10)
        }
        self.revokeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(43)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-52)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-52)
            }
            maker.width.equalTo(self.noRevokeBtn.snp.width).offset(0)
            maker.height.equalTo(45)
        }
        self.noRevokeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.revokeBtn.snp.right).offset(29)
            maker.bottom.height.equalTo(self.revokeBtn).offset(0)
            maker.right.equalTo(self.view.snp.right).offset(-43)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.scrollView).offset(5)
            maker.height.equalTo(120)
            maker.centerX.equalTo(self.view.snp.centerX).offset(0)
        }
        self.tipImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(34)
            maker.height.equalTo(34)
            maker.top.equalTo(self.contentView.snp.top).offset(33)
            maker.centerX.equalTo(self.contentView.snp.centerX).offset(0)
        }
        self.contentTipLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.contentView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            maker.top.equalTo(self.tipImgView.snp.bottom).offset(17)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(24)
            maker.right.equalTo(self.scrollView).offset(-24)
            maker.top.equalTo(self.contentView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
        
    }
    deinit {
        
    }
}
extension SPRevokeBondTipVC {
    
    @objc fileprivate func sp_clickRevoke(){
        
        let alertController = UIAlertController(title: "温馨提示", message: "您确定是要撤销保证金，您将无法享用海量特权", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "撤销", style: UIAlertActionStyle.default, handler: { [weak self](action) in
            self?.sp_revoke()
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    /// 跳到申请成功界面
    fileprivate func sp_pushSuccessVC(){
        let successVC = SPBondSuccessVC()
        successVC.isRevoke = true
        self.navigationController?.pushViewController(successVC, animated: true)
    }
    @objc fileprivate func sp_clickNoRevoke(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SPRevokeBondTipVC{
    fileprivate func sp_revoke(){
        sp_showAnimation(view: self.view, title: "正在提交中...")
        SPFundsRequest.sp_getDepositRefund(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : sp_getString(string: code) == SP_Request_Code_Success ? "提交撤销申请成功":"提交撤销申请失败")
            if code == SP_Request_Code_Success {
                self?.sp_pushSuccessVC()
            }
        }
    }
}
