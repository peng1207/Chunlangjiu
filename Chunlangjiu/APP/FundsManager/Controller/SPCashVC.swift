//
//  SPCashVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPCashVC: SPBaseVC {
    
    fileprivate lazy var bankCardView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "银行卡"
        view.placeholder = "请选择银行卡"
        view.selectBlock = { [weak self] in
            self?.sp_clickBankCard()
        }
        return view
    }()
    fileprivate lazy var priceView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "提现金额"
        view.textFiled.placeholder = "最多可提"
        view.lineView.isHidden = true
        return view
    }()
    fileprivate lazy var tipLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "*单笔提现金额最大为50000.00元"
        return label
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确认提现", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
//        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.selected)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_clickSubmit), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 5)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
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
        self.navigationItem.title = "提现"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.bankCardView)
        self.scrollView.addSubview(self.priceView)
        self.scrollView.addSubview(self.submitBtn)
        self.scrollView.addSubview(self.tipLabel)
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
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(50)
        }
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.bankCardView.snp.bottom).offset(5)
            maker.height.equalTo(50)
        }
        self.tipLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(21)
            maker.right.equalTo(self.scrollView.snp.right).offset(-21)
            maker.top.equalTo(self.priceView.snp.bottom).offset(11)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.submitBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.tipLabel.snp.bottom).offset(40)
            maker.height.equalTo(40)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-10)
        }
    }
    deinit {
        
    }
}
extension SPCashVC {
    @objc fileprivate func sp_clickSubmit(){
        
    }
    fileprivate func sp_clickBankCard(){
        let bankCardVC = SPBankCardVC()
        bankCardVC.selectBlock = { [weak self] (model) in
            self?.sp_dealSelect(model:model)
        }
        self.navigationController?.pushViewController(bankCardVC, animated: true)
    }
    fileprivate func sp_dealSelect(model : SPBankCardModel?){
        self.bandkCardModel = model
//        self.bankCardView.content = sp_getString(string: self.bandkCardModel.)
    }
}
