//
//  SPRevokeBondVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/17.
//  Copyright © 2019 Chunlang. All rights reserved.
//
// 撤销保证金

import Foundation
import SnapKit
class SPRevokeBondVC : SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var bankCardView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "银行卡"
        view.placeholder = "请选择银行卡"
        view.selectBlock = { [weak self] in
            self?.sp_clickBankCard()
        }
        return view
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = 10.0
        paragraphStyle.firstLineHeadIndent = 0
        let att = NSMutableAttributedString(string: "温馨提示:\n1.撤销保证金后，您不再是星级用户，无法享用海量特权.\n2.撤销保证金后，您已经发布的商品会自动下架.\n3.撤销保证金后，您最多只能发布3款商品.\n")
       att.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle ,NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_666666.rawValue)], range: NSRange(location: 0, length: att.length))
        label.attributedText = att
 
        return label
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("撤销保证金", for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
     fileprivate var bandkCardModel : SPBankCardModel?
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
        self.scrollView.addSubview(self.bankCardView)
        self.scrollView.addSubview(self.tipLabel)
        self.scrollView.addSubview(self.submitBtn)
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
        self.bankCardView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView).offset(10)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(12)
            maker.top.equalTo(self.bankCardView.snp.bottom).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-12)
            maker.height.greaterThanOrEqualTo(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(20)
            maker.right.equalTo(self.scrollView.snp.right).offset(-20)
            maker.height.equalTo(40)
            maker.top.equalTo(self.tipLabel.snp.bottom).offset(30)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPRevokeBondVC {
    fileprivate func sp_clickBankCard(){
        let bankCardVC = SPBankCardVC()
        bankCardVC.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model:model)
        }
        self.navigationController?.pushViewController(bankCardVC, animated: true)
    }
    fileprivate func sp_dealSelect(model : SPBankCardModel?){
        self.bandkCardModel = model
        self.bankCardView.content = sp_getString(string: self.bandkCardModel?.card).replaceBankCard()
    }
    @objc fileprivate func sp_clickSubmit(){
        let alertController = UIAlertController(title: "温馨提示", message: "您确定是要撤销保证金，您将无法享用海量特权", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "撤销", style: UIAlertActionStyle.default, handler: { [weak self](action) in
            self?.sp_revoke()
        }))
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        self.present(alertController, animated: true, completion: nil)
       
    }
    fileprivate func sp_revoke(){
        if self.bandkCardModel == nil {
            sp_showTextAlert(tips: "请选择银行卡")
            return
        }
        sp_sendRequest()
    }
}

extension SPRevokeBondVC {
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        if let bankCardId = self.bandkCardModel?.bank_id {
            parm.updateValue(bankCardId, forKey: "bank_id")
        }
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: "正在提交中...")
        SPFundsRequest.sp_getDepositRefund(requestModel: self.requestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: msg)
            if code == SP_Request_Code_Success {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
