//
//  SPRechargeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/15.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPRechargeVC: SPBaseVC {
    fileprivate lazy var headerView : SPRechargeHeaderView = {
        let view = SPRechargeHeaderView()
        return view
    }()
    fileprivate lazy var footerView : SPRechargeFooterView = {
        let view = SPRechargeFooterView()
        view.clickBlock = { [weak self] in
            self?.sp_clickDone()
        }
        return view
    }()
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPPayModel]?
    fileprivate var selectPay : SPPayModel?
    fileprivate var payPwd : String?
    fileprivate var balanceStatus : SPBalanceStatus?
    private var bounceApp = false
    /// 是否 缴纳保证金
    var isBond : Bool = false
    var price : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.tableView.sp_layoutHeaderView()
        self.tableView.sp_layoutFooterView()
        sp_setupData()
        sp_addNotification()
        if self.isBond {
            if sp_getString(string: self.price).count == 0 {
                 sp_sendGetBondRequest()
            }
        }
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
        var data = [SPPayModel]()
        if SPThridManager.sp_isInstallWX() {
             let wxModel = SPPayModel()
            wxModel.app_display_name = "微信"
              wxModel.app_rpc_id = SPPayType.wxPing.rawValue
            data.append(wxModel)
        }
       
        let aliPayModel = SPPayModel()
        aliPayModel.app_display_name = "支付宝"
      aliPayModel.app_rpc_id = SPPayType.alipayPing.rawValue
        data.append(aliPayModel)
        
//        let unpacpModel = SPPayModel()
//        unpacpModel.app_display_name = "银联"
//        unpacpModel.app_rpc_id = SPPayType.upacpPing.rawValue
//        data.append(unpacpModel)
        
        if isBond {
            let blanceModel = SPPayModel()
            blanceModel.app_display_name = "余额"
            blanceModel.app_rpc_id = SPPayType.balance.rawValue
            data.insert(blanceModel, at: 0)
            sp_showAnimation(view: self.view, title: nil)
            sp_sendBalanceStatusReequest()
        }
      
        self.dataArray = data
        self.tableView.reloadData()
        if self.isBond {
            self.headerView.priceView.textFiled.text = sp_getString(string: self.price)
            self.headerView.priceView.textFiled.isEnabled = false
        }else{
            self.headerView.priceView.textFiled.isEnabled = true
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = self.headerView
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
               maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPRechargeVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rechargeCellID = "rechargeCellID"
        var cell : SPRechargeTableCell? = tableView.dequeueReusableCell(withIdentifier: rechargeCellID) as? SPRechargeTableCell
        if cell == nil {
            cell = SPRechargeTableCell(style: UITableViewCellStyle.default, reuseIdentifier: rechargeCellID)
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let payModel = self.dataArray?[indexPath.row]
            cell?.model = payModel
            cell?.payContentLabel.text = ""
            if let pay = self.selectPay , let model = cell?.model{
                if sp_getString(string: pay.app_rpc_id) == sp_getString(string:  model.app_rpc_id) {
                    cell?.sp_isSelect(select: true)
                }else{
                    cell?.sp_isSelect(select: false)
                }
            }else{
                 cell?.sp_isSelect(select: false)
            }
            if sp_getString(string: payModel?.app_rpc_id) == SPPayType.balance.rawValue{
                if let status = self.balanceStatus {
                    if let isPwd : Bool = status.password , isPwd == false{
                        cell?.payContentLabel.text = "(没有设置密码)"
                    }
                    
                }
            }
            
            cell?.clickBlock = { [weak self] (model) in
                self?.selectPay = model
                self?.tableView.reloadData()
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let payModel = self.dataArray?[indexPath.row]
            
            if sp_getString(string: payModel?.app_rpc_id) == SPPayType.balance.rawValue {
                if let status = self.balanceStatus {
                    if let isPwd : Bool = status.password , isPwd == false{
                        sp_showTextAlert(tips: "没有设置密码")
                        tableView.reloadData()
                        sp_clickNoPwd()
                        return
                    }
                }
            }
            
            self.selectPay = payModel
            tableView.reloadData()
        }
    }
    
}
extension SPRechargeVC {
    fileprivate func sp_clickDone(){
        if self.selectPay == nil {
            sp_showTextAlert(tips: "请选择支付方式")
            return
        }
        if self.isBond == false , sp_getString(string: self.headerView.priceView.textFiled.text ).count == 0{
            sp_showTextAlert(tips: "请输入充值金额")
            return
        }
        sp_hideKeyboard()
        if self.isBond {
            if sp_getString(string: self.selectPay?.app_rpc_id) == SPPayType.balance.rawValue {
                SPBalanceView.sp_show(title: "余额支付", msg: nil) { [weak self](isSuccess, pwd) in
                    if isSuccess {
                        self?.payPwd = pwd
                        self?.sp_sendBondRequest()
                    }else{
                        
                    }
                }
            }else{
                self.sp_sendBondRequest()
            }
            
        }else{
           
           sp_sendRechargeRequest()
        }
        
    }
    fileprivate func sp_clickNoPwd(){
        let payPwdVC = SPPayPwdVC()
        self.navigationController?.pushViewController(payPwdVC, animated: true)
    }
}
extension SPRechargeVC {
    
    /// 发起充值的请求
    fileprivate func sp_sendRechargeRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.headerView.priceView.textFiled.text), forKey: "money")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getRechargeCreate(requestModel: self.requestModel) {  [weak self](code, msg, payModel, errorModel) in
             self?.sp_dealBondrequest(code: code, msg: msg, payModel: payModel, errorModel: errorModel)
        }
        
    }
    
    /// 发起保证金的请求
    fileprivate func sp_sendBondRequest(){
        let parm = [String : Any]()
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getDepositCreate(requestModel: self.requestModel) { [weak self](code, msg, payModel, errorModel) in
            self?.sp_dealBondrequest(code: code, msg: msg, payModel: payModel, errorModel: errorModel)
        }
    }
  
    fileprivate func sp_dealBondrequest(code: String,msg:String,payModel:SPOrderPayModel?,errorModel : SPRequestError? ){
        if code == SP_Request_Code_Success {
            self.sp_sendTopayRequest(payModel: payModel)
        }else{
            sp_hideAnimation(view: self.view)
            sp_showTextAlert(tips: msg)
        }
    }
    
    fileprivate func sp_sendTopayRequest(payModel : SPOrderPayModel?){
        let payRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string:payModel?.payment_id), forKey: "payment_id")
//        if sp_getString(string:self.selectPay?.app_rpc_id) == SPPayType.wxPay.rawValue {
//            parm.updateValue(sp_getString(string: SPPayType.wxPing.rawValue), forKey: "pay_app_id")
//        }else if sp_getString(string: self.selectPay?.app_rpc_id) == SPPayType.aliPay.rawValue{
//            parm.updateValue(sp_getString(string: SPPayType.alipayPing.rawValue), forKey: "pay_app_id")
//        }else{
            parm.updateValue(sp_getString(string: self.selectPay?.app_rpc_id), forKey: "pay_app_id")
//        }
        if sp_getString(string: self.selectPay?.app_rpc_id) == SPPayType.balance.rawValue{
            parm.updateValue(sp_getString(string: self.payPwd), forKey: "deposit_password")
        }
        payRequest.parm = parm
        
        SPAppRequest.sp_getToPay(requestModel: payRequest) { [weak self](data, errorModel) in
            sp_hideAnimation(view: self?.view)
            if sp_isDic(dic: data) {
                let errorCode  = sp_getString(string: data?[SP_Request_Errorcod_Key])
                if sp_getString(string: errorCode).count > 0, sp_getString(string: errorCode) != SP_Request_Code_Success {
                    self?.bounceApp = false
                    sp_hideAnimation(view: nil)
                    let msg = sp_getString(string: data?["msg"])
                    sp_showTextAlert(tips: msg.count > 0 ? msg :  "支付失败")
                    self?.sp_pushOrderList(isSuccess: false)
                }else{
                   
                    if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.wxPay.rawValue || sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.aliPay.rawValue {
                        self?.bounceApp = true
                        if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.wxPay.rawValue{
                             SPThridManager.sp_wxPay(dic: data!)
                        }else if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.aliPay.rawValue{
                             SPThridManager.sp_aliPay(payOrder: sp_getString(string: data?["url"]))
                        }

                    }else if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.wxPing.rawValue || sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.alipayPing.rawValue || sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.upacpPing.rawValue {
                        let payData = sp_dicValueString(data!)
                        if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.upacpPing.rawValue {
                            sp_hideAnimation(view: nil)
                        }
                        SPThridManager.sp_pingPay(data: payData, complete: { [weak self](status) in
                            self?.bounceApp = false
                            sp_hideAnimation(view: nil)
                            self?.sp_pushOrderList(isSuccess: sp_getString(string: status) == SP_PAY_SUCCESS ? true : false)
                        })
                    }else if sp_getString(string: self?.selectPay?.app_rpc_id) == SPPayType.balance.rawValue {
                       self?.sp_pushOrderList(isSuccess: true)
                    }
                }
            }else{
                self?.bounceApp = false
                sp_hideAnimation(view: nil)
                sp_showTextAlert(tips: "支付失败")
                self?.sp_pushOrderList(isSuccess: false)
            }
            
        }
    }
    fileprivate func sp_pushOrderList(isSuccess : Bool){
        if isSuccess {
            if self.isBond {
                let successVC = SPBondSuccessVC()
                successVC.bondPrice = self.price
                self.navigationController?.pushViewController(successVC, animated: true)
            }else{
                 self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    /// 获取保证金金额请求
    fileprivate func sp_sendGetBondRequest(){
        sp_showAnimation(view: self.view, title: nil)
        SPFundsRequest.sp_getDepostit(requestModel: self.requestModel) { [weak self](code , msg, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.headerView.priceView.textFiled.text = sp_getString(string: model?.deposit)
            }
        }
    }
    fileprivate func sp_sendBalanceStatusReequest(){
        SPAppRequest.sp_getBalanceStatus(requestModel: SPRequestModel()) { [weak self](code, balanceStatus, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                 self?.balanceStatus = balanceStatus
                 self?.tableView.reloadData()
            }
        }
        
    }
}
extension SPRechargeVC {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_payResture(notification:)), name: NSNotification.Name(SP_PAYRESULT_NOTIFICATION), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(sp_payPwdNotification), name: NSNotification.Name(SP_PAYPWD_SUCCESS_NOTIFICATION), object: nil)
    }
    @objc private func sp_payPwdNotification(){
        sp_showAnimation(view: self.view, title: nil)
        self.sp_sendBalanceStatusReequest()
    }
    /// 支付结果回调
    ///
    /// - Parameter notification: 支付结果
    @objc private func sp_payResture(notification:Notification){
        if sp_isDic(dic: notification.object) {
            let payResultDic : [String :Any] = notification.object as! [String : Any]
            let payType = sp_getString(string: payResultDic[SP_PAY_TYPE_KEY])
            let payState = sp_getString(string: payResultDic[SP_PAY_STATUES_KEY])
            let client = payResultDic[SP_PAY_CLIENT_KEY]
            sp_dealPay(state: payState, payType: payType,client: (client != nil))
        }
    }
    private func sp_dealPay(state : String,payType : String,client : Bool){
        if sp_getString(string: state).count > 0 &&  sp_getString(string: payType).count > 0  {
            self.bounceApp = false
            sp_hideAnimation(view: nil)
            self.sp_pushOrderList(isSuccess: state == SP_PAY_SUCCESS ? true : false)
            
        }else{
            if self.bounceApp && client {
                sp_hideAnimation(view: nil)
                self.sp_pushOrderList(isSuccess: false)
            }
            self.bounceApp = false
        }
    }
}
