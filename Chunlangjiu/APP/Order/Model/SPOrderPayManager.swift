//
//  SPOrderPayManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPOrderPayManager : NSObject {
    private var bounceApp = false
    private var payPwd :String?
    fileprivate var balanceStatus : SPBalanceStatus?{
        didSet{
            self.payView.balanceStatus = balanceStatus
        }
    }
    var orderModel : SPOrderModel?
    var complete : SPOrderHandleComplete?
    fileprivate lazy var payView : SPPayView = {
        let view = SPPayView()
        
        view.selectBlock = { (model ) in
            self.sp_dealPaySelect(mode: model)
            self.sp_hidePayView()
        }
        view.noPwdBlock = {
            self.sp_clickNoPwd()
        }
        return view
    }()
    fileprivate var payDataArray : [SPPayModel]? {
        didSet{
            self.payView.payDataArray = payDataArray
        }
    }
    override init() {
        super.init()
        sp_addNotification()
    }
    func sp_payRequest(){
        sp_showAnimation(view: nil, title: nil)
        SPAppRequest.sp_getBalanceStatus(requestModel: SPRequestModel()) { (code, balanceStatus, errorModel) in
            if code == SP_Request_Code_Success {
                self.balanceStatus = balanceStatus
            }
            SPAppRequest.sp_getPayList(requestModel: SPRequestModel()) { (code , list, errorModel, total ) in
                sp_hideAnimation(view: nil)
                if code == SP_Request_Code_Success {
                    self.payDataArray = list as? [SPPayModel]
                    self.sp_clickPayAction()
                }else{
                    sp_showTextAlert(tips: "支付失败")
                    self.sp_dealComplete(isSuccess: false)
                }
            }
        }
      
        
    }
    fileprivate func sp_hidePayView(){
        self.payView.removeFromSuperview()
    }
    
    /// 点击支付方式
    fileprivate func sp_clickPayAction(){
        let appDelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelete.window?.addSubview(self.payView)
        self.payView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDelete.window!).offset(0)
        }
    }
    
    private func sp_dealPaySelect(mode : SPPayModel?){
        guard let payModel = mode else {
            return
        }
        if sp_getString(string: payModel.app_rpc_id) == SPPayType.balance.rawValue {
            sp_showBalance(mode: payModel)
        }else{
             sp_crearePayRequest(selectPayModel: payModel)
        }
       
    }
    private func sp_showBalance(mode : SPPayModel?){
        guard let payModel = mode else {
            return
        }
        SPBalanceView.sp_show(title: "余额支付", msg: nil) { [weak self](isSuccess, pwd) in
            if isSuccess {
                self?.payPwd = pwd
                self?.sp_crearePayRequest(selectPayModel: payModel)
            }else{
                
            }
        }
    }
    
    fileprivate func sp_crearePayRequest(selectPayModel:SPPayModel){
        sp_showAnimation(view: nil, title: "支付中")
        
        if sp_getString(string: orderModel?.type) == SP_AUCTION ,sp_getString(string: orderModel?.status) == SP_AUCTION_0{
            let payModel = SPOrderPayModel()
            payModel.payment_id = sp_getString(string: orderModel?.payment_id)
            self.sp_sendWXRequest(selectPayModel: selectPayModel, payModel: payModel)
        }else{
            let request = SPRequestModel()
            var parm = [String:Any]()
            parm.updateValue(self.orderModel?.tid ?? 0, forKey: "tid")
            request.parm = parm
            SPOrderRequest.sp_getCreatePay(requestModel: request) { (code, msg, payModel, errorModel) in
                if code == SP_Request_Code_Success {
                    if sp_getString(string: selectPayModel.app_rpc_id ) == SPPayType.wxPay.rawValue || sp_getString(string: selectPayModel.app_rpc_id ) == SPPayType.wxPing.rawValue{
                        self.sp_sendWXRequest(selectPayModel: selectPayModel, payModel: payModel)
                    }else if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.aliPay.rawValue || sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.alipayPing.rawValue{
                        self.sp_sendWXRequest(selectPayModel: selectPayModel, payModel: payModel)
                    }else if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.balance.rawValue {
                        self.sp_sendWXRequest(selectPayModel: selectPayModel, payModel: payModel)
                    }else if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.upacpPing.rawValue{
                        self.sp_sendWXRequest(selectPayModel: selectPayModel, payModel: payModel)
                    }else{
                        sp_hideAnimation(view: nil)
                    }
                    
                }else{
                    sp_hideAnimation(view: nil)
                    sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "支付失败")
                }
            }
        }
    }
    
    fileprivate func sp_sendWXRequest(selectPayModel:SPPayModel,payModel : SPOrderPayModel?){
        guard let pay = payModel else {
             sp_hideAnimation(view: nil)
            return
        }
        let payRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string:pay.payment_id), forKey: "payment_id")
//        if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.wxPay.rawValue {
//            parm.updateValue(sp_getString(string: SPPayType.wxPing.rawValue), forKey: "pay_app_id")
//        }else if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.aliPay.rawValue{
//            parm.updateValue(sp_getString(string: SPPayType.alipayPing.rawValue), forKey: "pay_app_id")
//        }else{
           parm.updateValue(sp_getString(string:selectPayModel.app_rpc_id), forKey: "pay_app_id")
//        }
        if sp_getString(string: selectPayModel.app_rpc_id) == SPPayType.balance.rawValue {
            parm.updateValue(sp_getString(string: self.payPwd), forKey: "deposit_password")
        }
        payRequest.parm = parm
        self.bounceApp = false
        SPAppRequest.sp_getToPay(requestModel: payRequest) { (data, errorModel) in
            if sp_isDic(dic: data){
                let errorCode  = sp_getString(string: data?[SP_Request_Errorcod_Key])
                if sp_getString(string: errorCode).count > 0 , sp_getString(string: errorCode) != SP_Request_Code_Success {
                    self.bounceApp = false
                    sp_hideAnimation(view: nil)
                    let msg = sp_getString(string: data?[SP_Request_Msg_Key])
                    
                    sp_showTextAlert(tips:  sp_getString(string: msg).count > 0 ?  msg : "支付失败")
                    self.sp_dealComplete(isSuccess: false)
                }else{
                    if (selectPayModel.app_rpc_id == SPPayType.wxPay.rawValue){
                        self.bounceApp = true
                        SPThridManager.sp_wxPay(dic: data!)
                    }else if (selectPayModel.app_rpc_id == SPPayType.aliPay.rawValue){
                        self.bounceApp = true
                        SPThridManager.sp_aliPay(payOrder: sp_getString(string: data?["url"]))
                    }else if selectPayModel.app_rpc_id == SPPayType.wxPing.rawValue || selectPayModel.app_rpc_id == SPPayType.alipayPing.rawValue || selectPayModel.app_rpc_id == SPPayType.upacpPing.rawValue {
                        if  selectPayModel.app_rpc_id == SPPayType.upacpPing.rawValue {
                             sp_hideAnimation(view: nil)
                        }
                        self.bounceApp = true
                     
                        let payData = sp_dicValueString(data!)
                        SPThridManager.sp_pingPay(data: payData, complete: { (status) in
                            self.bounceApp = false
                            sp_hideAnimation(view: nil)
                            self.sp_dealComplete(isSuccess: sp_getString(string: status) == SP_PAY_SUCCESS ? true : false)
                        })
                    }else if selectPayModel.app_rpc_id == SPPayType.balance.rawValue{
                        sp_hideAnimation(view: nil)
                        self.sp_dealComplete(isSuccess: true)
                    }
                }
            }else{
                self.bounceApp = false
                sp_hideAnimation(view: nil)
                sp_showTextAlert(tips: "支付失败")
                self.sp_dealComplete(isSuccess: false)
            }
        }
    }
   
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_payResture(notification:)), name: NSNotification.Name(SP_PAYRESULT_NOTIFICATION), object: nil)
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
        sp_hideAnimation(view: nil)
        if sp_getString(string: state).count > 0 &&  sp_getString(string: payType).count > 0  {
            self.bounceApp = false
            sp_hideAnimation(view: nil)
            sp_dealComplete(isSuccess: true)
        }else{
            if self.bounceApp && client {
                sp_hideAnimation(view: nil)
            }
            self.bounceApp = false
            sp_dealComplete(isSuccess: false)
        }
    }
    
    fileprivate func  sp_dealComplete(isSuccess: Bool){
        guard let block = self.complete else {
            return
        }
        if isSuccess {
            SPOrderHandle.sp_dealOrderNotificaton(orderModel: orderModel)
        }
        block(isSuccess)
        sp_remove()
    }
    fileprivate func sp_remove(){
         NotificationCenter.default.removeObserver(self)
        self.payView.removeFromSuperview()
        self.payView.selectBlock = nil
    }
    fileprivate func sp_clickNoPwd(){
          sp_remove()
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appdelegate.window?.rootViewController
        if tabbarController is SPMainVC {
            let tabBar : SPMainVC = tabbarController as! SPMainVC
            let nav : UINavigationController? = tabBar.viewControllers![tabBar.selectedIndex] as? UINavigationController
            if nav != nil {
               let payPwdVC = SPPayPwdVC()
                nav?.pushViewController(payPwdVC, animated: true)
            }
        }

       
    }
    deinit {
       
    }
    
}
