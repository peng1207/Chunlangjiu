//
//  SPSetVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPSetVC: SPBaseVC {
    
    fileprivate var tableView : UITableView!
    fileprivate lazy var dataArray : [Array<SPSetModel>]! = {
        return SPSetData.sp_getSetData()
    }()
    fileprivate lazy var logoutBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("退出登录", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.addTarget(self, action: #selector(sp_logout), for: UIControlEvents.touchUpInside)
        btn.sp_cornerRadius(cornerRadius: 25)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "设置"
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 40
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.logoutBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.logoutBtn.snp.top).offset(0)
        }
        self.logoutBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(50)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-10)
            }
            
        }
    }
    deinit {
        
    }
}

extension SPSetVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray){
            return sp_getArrayCount(array: self.dataArray[section])
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setCellID = "setCellID"
        var cell : UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: setCellID)
        if  cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: setCellID)
            cell?.selectionStyle = .none
            cell?.accessoryType =  UITableViewCell.AccessoryType.disclosureIndicator
            cell?.textLabel?.font = sp_getFontSize(size: 15)
            cell?.textLabel?.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let array = self.dataArray[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: array){
                let model : SPSetModel = array[indexPath.row]
                cell?.textLabel?.text = sp_getString(string: model.title)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let array = self.dataArray[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: array){
                let model : SPSetModel = array[indexPath.row]
                switch model.type {
                case .loginPwd?:
                    sp_pushLoginPwd()
                case .auth?:
                    sp_pushAuth()
                case .about?:
                    sp_pushAbout()
                case .address?:
                    sp_pushAddress()
                case .info?:
                    sp_pushInfo()
                case .bankCard?:
                    sp_pushBankCard()
                case .agreement?:
                    sp_pushAgreement()
                case .payPwd?:
                    sp_pushPayPwd()
                default:
                    sp_log(message: "没有找到")
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
}
// MARK: - action
extension SPSetVC {
    @objc fileprivate func sp_logout(){
        sp_logoutRequest()
        SPAPPManager.sp_dealLogout()
//        sp_mainQueue { [weak self]in
//            self?.navigationController?.popToRootViewController(animated: true)
//        }
    }
    fileprivate func sp_logoutRequest(){
        let request = SPRequestModel()
        SPAppRequest.sp_getLogout(requestModel: request) { (code, msg, errorModel) in
            
        }
    }
    fileprivate func sp_pushLoginPwd(){
        let loginPwdVC = SPLoginPwdVC()
        self.navigationController?.pushViewController(loginPwdVC, animated: true)
    }
    fileprivate func sp_pushPayPwd(){
        let payPwdVC = SPPayPwdVC()
        self.navigationController?.pushViewController(payPwdVC, animated: true)
    }
    fileprivate func sp_pushBankCard(){
        let bankCard = SPBankCardVC()
        self.navigationController?.pushViewController(bankCard, animated: true)
    }
    fileprivate func sp_pushInfo(){
        let vc = SPPersonalInfoVC()
        self.navigationController?.pushViewController(vc, animated: true)
//        if SPAPPManager.sp_isBusiness() {
//            sp_pushWebVC(url: "\(SP_GER_SELLERINFO_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "会员资料")
//        }else{
//            sp_pushWebVC(url: "\(SP_GET_USER_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "会员资料")
//        }
    }
    fileprivate func sp_pushWebVC(url : String,title:String? = nil){
        let webVC = SPWebVC()
        webVC.url = URL(string: url)
        webVC.title = title
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    fileprivate func sp_pushAuth(){
        let authVC = SPAuthHomeVC()
        self.navigationController?.pushViewController(authVC, animated: true)
    }
    fileprivate func sp_pushAgreement(){
        let webVC = SPWebVC()
        webVC.url = URL(string: SP_GET_USER_WEB_URL)
        webVC.title = "用户协议"
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    fileprivate func sp_pushAbout(){
        let aboutVC = SPAboutVC()
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    fileprivate func sp_pushAddress(){
        let addressVC = SPAddressVC()
        addressVC.title = "地址列表"
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
}
