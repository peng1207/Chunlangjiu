//
//  SPBalanceVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPBalanceVC: SPBaseVC {
    fileprivate lazy var btnView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy var cashBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提现", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickCash), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var rechargeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("充值", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
         btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickRecharge), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 5)
        return view
    }()
    fileprivate lazy var useLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var useTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "可用金额"
        return label
    }()
    fileprivate lazy var frozenLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        return label
    }()
    fileprivate lazy var frozenTitleLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        label.textAlignment = .center
        label.text = "冻结金额"
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
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.btnView)
        self.contentView.addSubview(self.useLabel)
        self.contentView.addSubview(self.useTitleLabel)
        self.contentView.addSubview(self.frozenLabel)
        self.contentView.addSubview(self.frozenTitleLabel)
        self.btnView.addSubview(self.cashBtn)
        self.btnView.addSubview(self.rechargeBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.top.equalTo(self.view).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.useLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.contentView).offset(11)
            maker.top.equalTo(self.contentView).offset(28)
            maker.height.greaterThanOrEqualTo(0)
            maker.width.equalTo(self.frozenLabel.snp.width).offset(0)
        }
        self.frozenLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.useLabel.snp.right).offset(11)
            maker.right.equalTo(self.contentView.snp.right).offset(-11)
            maker.top.equalTo(self.useLabel.snp.top).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.useTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.useLabel).offset(0)
            maker.top.equalTo(self.useLabel.snp.bottom).offset(16)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView).offset(-16)
        }
        self.frozenTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.frozenLabel).offset(0)
            maker.top.equalTo(self.frozenLabel.snp.bottom).offset(16)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.contentView).offset(-16)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
            maker.height.equalTo(65)
        }
        self.cashBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.btnView).offset(25)
            maker.top.equalTo(self.btnView).offset(10)
            maker.bottom.equalTo(self.btnView.snp.bottom).offset(-10)
            maker.width.equalTo(self.rechargeBtn.snp.width).offset(0)
        }
        self.rechargeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.cashBtn.snp.right).offset(25)
            maker.bottom.top.equalTo(self.cashBtn).offset(0)
            maker.right.equalTo(self.btnView).offset(-25)
        }
    }
    deinit {
        
    }
}
extension SPBalanceVC {
    @objc fileprivate func sp_clickCash(){
        let cashVC = SPCashVC()
        self.navigationController?.pushViewController(cashVC, animated: true)
    }
    @objc fileprivate func sp_clickRecharge(){
        let rechargeVC = SPRechargeVC()
        rechargeVC.navigationItem.title = "充值"
        self.navigationController?.pushViewController(rechargeVC, animated: true)
    }
    
}
