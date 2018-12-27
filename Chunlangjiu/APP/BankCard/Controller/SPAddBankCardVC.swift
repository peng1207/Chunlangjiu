//
//  SPAddBankCardVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/11.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPAddBankCardVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var nameView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "姓名"
        view.textFiled.placeholder = "请输入姓名"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var cardView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "身份证"
        view.textFiled.placeholder = "请输入身份证号码"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var bankCardView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "银行卡号"
        view.textFiled.placeholder = "请输入银行卡号"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var openView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "开户行"
        view.placeholder = "请选择开户行"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var areaView : SPAddressSelectView = {
        let view = SPAddressSelectView()
        view.titleLabel.text = "开户支行"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var subbranchView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.textFiled.placeholder = "请输入支行"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var phoneView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "手机号"
        view.textFiled.placeholder = "请输入银行预留手机号"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var codeView : SPAddressEditView = {
        let view = SPAddressEditView()
        view.titleLabel.text = "验证码"
        view.textFiled.placeholder = "请输入验证码"
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var doneBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("确定绑定", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 5)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickDone), for: UIControlEvents.touchUpInside)
        return btn
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
        self.navigationItem.title = "添加银行卡"
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.doneBtn)
        self.scrollView.addSubview(self.nameView)
        self.scrollView.addSubview(self.cardView)
        self.scrollView.addSubview(self.bankCardView)
        self.scrollView.addSubview(self.openView)
        self.scrollView.addSubview(self.areaView)
        self.scrollView.addSubview(self.subbranchView)
        self.scrollView.addSubview(self.codeView)
        self.scrollView.addSubview(self.phoneView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.doneBtn.snp.top).offset(-10)
        }
        self.doneBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view.snp.right).offset(-10)
            maker.height.equalTo(40)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
        }
        self.nameView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.scrollView.snp.top).offset(10)
            maker.height.equalTo(50)
        }
        self.cardView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.nameView).offset(0)
            maker.top.equalTo(self.nameView.snp.bottom).offset(0)
        }
        self.bankCardView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.cardView).offset(0)
            maker.top.equalTo(self.cardView.snp.bottom).offset(10)
        }
        self.openView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.bankCardView).offset(0)
            maker.top.equalTo(self.bankCardView.snp.bottom).offset(0)
        }
        self.areaView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.openView).offset(0)
            maker.top.equalTo(self.openView.snp.bottom).offset(0)
        }
        self.subbranchView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.areaView).offset(0)
            maker.top.equalTo(self.areaView.snp.bottom).offset(0)
        }
        self.phoneView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.subbranchView).offset(0)
            maker.top.equalTo(self.subbranchView.snp.bottom).offset(10)
        }
        self.codeView.snp.makeConstraints { (maker) in
            maker.left.right.height.equalTo(self.phoneView).offset(0)
            maker.top.equalTo(self.phoneView.snp.bottom).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPAddBankCardVC {
    @objc fileprivate func sp_clickDone(){
        
    }
    
}