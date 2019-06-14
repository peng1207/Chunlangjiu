//
//  SPConfrimOrderVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/6.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
//fileprivate var tableView : UITableView!

import Foundation
import SnapKit

let SP_MODE_TYPE_FASTBUY = "fastbuy"
let SP_MODE_TYPE_CART = "cart"
class SPConfirmOrderVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var payPwd : String?
    fileprivate var balanceStatus : SPBalanceStatus?
    fileprivate lazy var addressView : SPConfrimAddressView = {
        let view = SPConfrimAddressView()
        view.clickBlock = { [weak self] in
           self?.sp_clickAddressAction()
            
        }
        return view
    }()
    fileprivate lazy var footerView : SPConfrimFooterView = {
        let view = SPConfrimFooterView()
        view.clickPayBlock = { [weak self] in
            self?.sp_clickPayAction()
        }
        return view
    }()
    fileprivate lazy var bottomView : SPConfrimBtnView = {
        let view = SPConfrimBtnView()
        view.clickBlock = { [weak self] in
            self?.sp_clickSubmitAction()
        }
        return view
    }()
    fileprivate lazy var payView : SPPayView = {
        let view = SPPayView()
        view.payDataArray = confirmOrder?.payType
        view.selectBlock = {[weak self] (model ) in
            self?.confirmOrder?.selectPayModel = model
            self?.sp_dealFooterView()
            self?.sp_hidePayView()
            self?.sp_dealAuction()
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    fileprivate lazy var priceView : SPConfirmAuctionPriceView = {
        let view = SPConfirmAuctionPriceView()
        return view
    }()
    fileprivate lazy var tipsView : SPConfirmAuctionTipsView = {
        let view = SPConfirmAuctionTipsView()
        return view
    }()
    fileprivate lazy var auctionAddressView : SPConfirmAuctionAddressView = {
        let view = SPConfirmAuctionAddressView()
        view.clickBlock = { [weak self] in
            self?.sp_clickAddressAction()
        }
        return view
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .left
        label.text = "为保证竞拍成功拍品顺利送达，请确认您的收货地址"
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var submitBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("提交定金", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickSubmitAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    var confirmOrder : SPConfirmOrderModel?
    var modelType : String = SP_MODE_TYPE_CART
    var isAuction : Bool = false
    private var bounceApp = false
    override func viewDidLoad() {
        super.viewDidLoad()
        sp_showAnimation(view: self.view, title: nil)
         self.sp_setupUI()
        self.sp_sendPayListRequest()
        self.sp_sendBalanceStatusReequest()
        if isAuction {
            self.navigationItem.title = "参拍交定金"
        }else{
            self.title = "确认订单"
        }
        
        self.sp_setupData()
        if self.isAuction {
            
        }else{
            self.sp_addNotification()
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
    /// 创建UI
    override func sp_setupUI() {
        if self.isAuction {
            self.view.addSubview(self.scrollView)
            self.scrollView.addSubview(self.priceView)
            self.scrollView.addSubview(self.tipsView)
            self.scrollView.addSubview(self.auctionAddressView)
            self.scrollView.addSubview(self.tipsLabel)
            self.view.addSubview(self.submitBtn)
        }else{
            self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
            self.tableView.backgroundColor = self.view.backgroundColor
            self.tableView.rowHeight = SPConfrimTableCell_Product_Width * SP_PRODUCT_SCALE + 1.0
            self.tableView.tableFooterView = self.footerView
            self.tableView.tableHeaderView = self.addressView
            self.tableView.estimatedSectionFooterHeight = 30
            self.tableView.sectionFooterHeight = UITableViewAutomaticDimension
            self.view.addSubview(self.tableView)
            self.view.addSubview(self.bottomView)
        }
       
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        if self.isAuction {
            self.scrollView.snp.makeConstraints { (maker) in
                maker.left.right.top.equalTo(self.view).offset(0)
                maker.bottom.equalTo(self.submitBtn.snp.top).offset(0)
            }
            self.submitBtn.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.view).offset(0)
                maker.height.equalTo(60)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                } else {
                    maker.bottom.equalTo(self.view.snp.bottom).offset(0)
                }
            }
            self.priceView.snp.makeConstraints { (maker) in
                maker.width.equalTo(self.scrollView.snp.width).offset(0)
                maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
                maker.top.equalTo(self.scrollView).offset(0)
                maker.height.equalTo(175)
            }
            self.tipsView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.priceView).offset(0)
                maker.top.equalTo(self.priceView.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.auctionAddressView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.tipsView).offset(0)
                maker.top.equalTo(self.tipsView.snp.bottom).offset(10)
                maker.height.greaterThanOrEqualTo(0)
            }
            self.tipsLabel.snp.makeConstraints { (maker) in
                maker.left.equalTo(self.scrollView).offset(15)
                maker.right.equalTo(self.scrollView.snp.right).offset(-15)
                maker.top.equalTo(self.auctionAddressView.snp.bottom).offset(14)
                maker.height.greaterThanOrEqualTo(0)
                maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-14)
            }
        }else{
            self.tableView.snp.makeConstraints { (maker) in
                maker.left.top.right.equalTo(self.view).offset(0)
                maker.bottom.equalTo(self.bottomView.snp.top).offset(0)
            }
            self.bottomView.snp.makeConstraints { (maker) in
                maker.left.right.equalTo(self.view).offset(0)
                maker.height.equalTo(49)
                if #available(iOS 11.0, *) {
                    maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
                } else {
                    maker.bottom.equalTo(self.view.snp.bottom).offset(0)
                }
            }
            self.addressView.snp.makeConstraints { (maker ) in
                maker.top.equalToSuperview()
                maker.left.right.equalTo(view)
                maker.centerX.equalToSuperview()
                maker.height.greaterThanOrEqualTo(0).priority(.high)
            }
        }
       
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        if self.isAuction == false {
            self.tableView.delegate = nil
            self.tableView.dataSource = nil
        }
       
    }
}
extension SPConfirmOrderVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if let model = self.confirmOrder {
             return sp_getArrayCount(array: model.dataArray)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = self.confirmOrder {
            if section < sp_getArrayCount(array: model.dataArray){
                let shopModel = model.dataArray?[section];
                return sp_getArrayCount(array: shopModel?.productArray)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let confrimOrderCellID = "confrimOrderCellID"
        var cell : SPConfrimTableCell? = tableView.dequeueReusableCell(withIdentifier: confrimOrderCellID) as?  SPConfrimTableCell
        if cell == nil {
            cell = SPConfrimTableCell(style: UITableViewCellStyle.default, reuseIdentifier: confrimOrderCellID)
        }
        if let model = self.confirmOrder {
            if indexPath.section < sp_getArrayCount(array: model.dataArray) {
                let shopModel = model.dataArray![indexPath.section]
                if indexPath.row < sp_getArrayCount(array: shopModel.productArray){
                    cell?.productModel = shopModel.productArray?[indexPath.row]
                }
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let confirmOrderHeaderID = "confirmOrderHeaderID"
        var headerView : SPConfrimSectionHeadView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: confirmOrderHeaderID) as? SPConfrimSectionHeadView
        if headerView == nil {
            headerView = SPConfrimSectionHeadView(reuseIdentifier: confirmOrderHeaderID)
        }
         if let model = self.confirmOrder {
            if section < sp_getArrayCount(array: model.dataArray) {
                let shopModel = model.dataArray![section]
                headerView?.shopModel = shopModel
            }
        }
        return headerView!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let confirmOrderFooterID = "confirmOrderFooterID"
        var footerView : SPConfrimSectionFootView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: confirmOrderFooterID) as? SPConfrimSectionFootView
        if footerView == nil {
            footerView = SPConfrimSectionFootView(reuseIdentifier: confirmOrderFooterID)
        }
        if let model = self.confirmOrder {
            if section < sp_getArrayCount(array: model.dataArray) {
                let shopModel = model.dataArray![section]
                footerView?.shopModel = shopModel
                footerView?.isAuction = self.isAuction
            }
        }
        return footerView!
    }
}
// MARK: - action data
extension SPConfirmOrderVC {
    fileprivate func sp_dealAuction(){
        if self.isAuction {
            //  竞拍
            if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.balance.rawValue {
                sp_balancePay(orderPay: nil)
            }else{
                sp_sendAuctionRequest(price: "")
            }
        }
        
    }
    @objc fileprivate func sp_clickSubmitAction(){
        guard let addressModel = self.confirmOrder?.default_address else {
            sp_showTextAlert(tips: "请选择地址")
            return
        }
        if self.isAuction {
//            let shopModel = self.confirmOrder?.dataArray?.first
//            guard sp_getString(string: shopModel?.confrim_auction_price).count > 0 else{
//                sp_showTextAlert(tips: "请输入出价金额")
//                return
//            }
                sp_clickPayAction()
//            if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.balance.rawValue {
//                sp_balancePay(orderPay: nil)
//            }else{
//                 sp_sendAuctionRequest(price: sp_getString(string:shopModel?.confrim_auction_price))
//            }
            
           
        }else{
            guard let pay  = self.confirmOrder?.selectPayModel else {
                sp_showTextAlert(tips: "请选择支付方式")
                return
            }
            var parm = [String:Any]()
            parm.updateValue(self.modelType, forKey: "mode")
            parm.updateValue(sp_getString(string: self.confirmOrder?.md5_cart_info), forKey: "md5_cart_info")
            parm.updateValue(sp_getString(string: addressModel.addr_id), forKey: "addr_id")
            parm.updateValue(sp_getString(string: pay.app_rpc_id), forKey: "payment_type")
            parm.updateValue("online", forKey: "payment_type")
            parm.updateValue("app", forKey: "source_from")
            parm.updateValue("", forKey: "shipping_type")
            let (shipping,remaker) = sp_getShopShipping()
            parm.updateValue(sp_getString(string: shipping), forKey: "shipping_type")
            if sp_getString(string: remaker).count > 0  {
                parm.updateValue(sp_getString(string: remaker), forKey: "mark")
            }
            parm.updateValue("notuse", forKey: "invoice_type")
            sp_sendSubmitRequest(parm: parm)
        }
        
      
    }
    /// 获取每个店铺的配送方式 和备注
    ///
    /// - Returns: 配送方式
    fileprivate func sp_getShopShipping()->(shop:String,remark:String){
        if sp_getArrayCount(array: self.confirmOrder?.dataArray) > 0 {
            var shipping_type = [[String : Any]]()
            var mark = [[String:Any]]()
            for shopModel in (self.confirmOrder?.dataArray)! {
                var shipping_typeParm = [String:Any]()
                shipping_typeParm.updateValue(sp_getString(string: shopModel.shop_id), forKey: "shop_id")
                shipping_typeParm.updateValue("express", forKey: "type")
                shipping_type.append(shipping_typeParm)
                if sp_getString(string: shopModel.remark).count > 0{
                    mark.append(["shop_id":sp_getString(string: shopModel.shop_id),"memo":sp_getString(string: shopModel.remark)])
                }
            }
            return (sp_getString(string:sp_arrayValueString(shipping_type)),( sp_getArrayCount(array: mark) > 0 ? sp_getString(string: sp_arrayValueString(mark)) : ""))
        }else{
            return ("","")
        }
       
    }
    /// 点击支付方式
    fileprivate func sp_clickPayAction(){
        let appDelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelete.window?.addSubview(self.payView)
        self.payView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(appDelete.window!).offset(0)
        }
    }
    fileprivate func sp_hidePayView(){
        self.payView.removeFromSuperview()
    }
    fileprivate func sp_setupData(){
        if self.isAuction {
            self.priceView.confirmOrder = self.confirmOrder
            self.tipsView.confirmOrder = self.confirmOrder
        }
        self.sp_dealAddressView()
        sp_dealBottom()
        self.sp_dealFooterView()
    }
    /// 处理地址的数据
    fileprivate func sp_dealAddressView(){
        if self.isAuction {
            self.auctionAddressView.addressModel = self.confirmOrder?.default_address
        }else{
            self.addressView.addressModel = self.confirmOrder?.default_address
            self.tableView.sp_layoutHeaderView()
        }
     
    }
    /// 处理底部按钮
    fileprivate func sp_dealBottom(){
        if isAuction {
//            self.bottomView.auctionBtn.isHidden = false
//            let att = NSMutableAttributedString()
//            att.append(NSAttributedString(string: "支付定金", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 15),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
//            att.append(NSAttributedString(string: "(\(SP_CHINE_MONEY)\(sp_getString(string: confirmOrder?.pledge)))", attributes: [NSAttributedStringKey.font : sp_getFontSize(size: 12),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]))
//            self.bottomView.auctionBtn.setAttributedTitle(att, for: UIControlState.normal)
//            self.bottomView.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: confirmOrder?.pledge))"
        }else{
            self.bottomView.auctionBtn.isHidden = true
           self.bottomView.priceLabel.text = "\(SP_CHINE_MONEY)\(sp_getString(string: self.confirmOrder?.total?.allPayment))"
        }
       
    }
    /// 处理footer的数据
    fileprivate func sp_dealFooterView(){
        if self.isAuction {
            
        }else{
            self.footerView.confirmOrder = self.confirmOrder
            self.footerView.isAuction = self.isAuction
            self.tableView.sp_layoutFooterView()
        }
        
    }
    fileprivate func sp_clickAddressAction(){
        let addressVC = SPAddressVC()
        addressVC.title = "选择地址"
        addressVC.addressModel = self.confirmOrder?.default_address
        addressVC.selectBlock = { (model) in
            self.sp_dealAddressCompelte(model: model)
            self.sp_sendPriceRequest()
        }
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    fileprivate func sp_dealAddressCompelte(model : SPAddressModel?){
        self.confirmOrder?.default_address = model
         self.sp_dealAddressView()
    }
    fileprivate func sp_pushOrderList(isSuccess : Bool){
        SPAPPManager.sp_change(identity: "")
        if isAuction {
            NotificationCenter.default.post(name: NSNotification.Name(SP_SUBMITAUCTION_NOTIFICATION), object: nil)
        }
        if isAuction && isSuccess {
//            let orderDetVC = SPOrderDetaileVC()
//            let orderModel = SPOrderModel()
//            orderModel.auctionitem_id = self.confirmOrder?.auctionitem_id
//            let toolModel = SPOrderToolModel()
//            toolModel.orderType = .auctionType
//            orderDetVC.orderModel = orderModel
//            orderDetVC.toolModel = toolModel
//            self.navigationController?.pushViewController(orderDetVC, animated: true)
            self.navigationController?.popViewController(animated: true)
        }else{
            let orderVC = SPOrderVC()
            orderVC.orderType = isAuction ? .auctionType : .defaultType
            if isAuction {
                orderVC.orderState =  isSuccess ? .auction_ing : .paydown
            }else{
                orderVC.orderState =  isSuccess ? .deliver : .pendPay
            }
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
        
        
       
    }
}
// MARK: - notification
extension SPConfirmOrderVC {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardWillShow(obj:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_payResture(notification:)), name: NSNotification.Name(SP_PAYRESULT_NOTIFICATION), object: nil)
    }
    @objc private func sp_keyboardWillShow(obj:Notification){
        let height = sp_getKeyBoardheight(notification: obj)
        sp_updateTableLayout(height: height)
    }
    @objc private func sp_keyboardWillHide(){
        sp_updateTableLayout(height: 0)
    }
    private func sp_updateTableLayout(height:CGFloat){
        self.tableView.snp.remakeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if height > 0 {
                maker.bottom.equalTo(self.view.snp.bottom).offset(-height)
            }else{
                  maker.bottom.equalTo(self.bottomView.snp.top).offset(0)
            }
        }
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
// MARK: - request
extension SPConfirmOrderVC {
    fileprivate func sp_sendSubmitRequest(parm : [String : Any]?){
        self.requestModel.parm = parm
        self.payPwd = nil
        if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.balance.rawValue {
            sp_balancePay(orderPay: nil)
        }else{
            sp_showAnimation(view: nil, title: "提交中,请勿重复提交")
            SPAppRequest.sp_getCreateOrder(requestModel: self.requestModel) { [weak self](code , msg, orderPay, errorModel) in
                self?.sp_dealCreateComplete(code: code, msg: msg, orderPay: orderPay, errorModel: errorModel)
            }
        }
    }
    fileprivate func sp_sendAuctionRequest(price : String){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.confirmOrder?.auctionitem_id), forKey: "auctionitem_id")
        parm.updateValue(sp_getString(string: self.confirmOrder?.default_address?.addr_id), forKey: "addr_id")
//        parm.updateValue(sp_getString(string: price), forKey: "price")
        self.requestModel.parm = parm
         sp_showAnimation(view: nil, title: "提交中,请勿重复提交")
        SPAppRequest.sp_getCreateAuctionOrder(requestModel: self.requestModel) {  [weak self](code , msg, orderPay, errorModel) in
               self?.sp_dealCreateComplete(code: code, msg: msg, orderPay: orderPay, errorModel: errorModel)
        }
       
    }
    
    /// 处理 创建订单回调
    ///
    /// - Parameters:
    ///   - code: 请求码
    ///   - msg: 提示语
    ///   - orderPay: 支付需要的数据
    ///   - errorModel: 错误
    private func sp_dealCreateComplete(code :String,msg:String,orderPay:SPOrderPayModel?,errorModel:SPRequestError?){
        if code == SP_Request_Code_Success{
            guard let pay = orderPay else {
                return
            }
            if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.balance.rawValue {
               
//                sp_balancePay(orderPay: pay)
                sp_sendBalanceRequest(orderPay: pay, pwd: sp_getString(string: self.payPwd))
            }else if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.wxPay.rawValue || sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.wxPing.rawValue {
                sp_sendWXRequest(orderPay: orderPay)
            }else if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.aliPay.rawValue || sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.alipayPing.rawValue{
                sp_sendWXRequest(orderPay: orderPay)
            }else if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.upacpPing.rawValue{
                 sp_sendWXRequest(orderPay: orderPay)
            }
            else{
                sp_hideAnimation(view: nil)
            }
        }else{
            sp_hideAnimation(view: nil)
            sp_showTextAlert(tips: msg)
        }
    }
    fileprivate func sp_balancePay(orderPay:SPOrderPayModel?){
//        guard let pay = orderPay else {
//            return
//        }
        SPBalanceView.sp_show(title: "余额支付", msg: nil) { [weak self](isSuccess, pwd) in
            if isSuccess {
                self?.payPwd = pwd
                if let isAuction = self?.isAuction, isAuction == true{
                     let shopModel = self?.confirmOrder?.dataArray?.first
                      self?.sp_sendAuctionRequest(price: sp_getString(string:shopModel?.confrim_auction_price))
                }else{
                     self?.sp_dealBalance()
                }
               
            }else{
               
            }
        }
    }
    fileprivate func sp_dealBalance(){
        sp_showAnimation(view: nil, title: "提交中,请勿重复提交")
        SPAppRequest.sp_getCreateOrder(requestModel: self.requestModel) { [weak self](code , msg, orderPay, errorModel) in
            self?.sp_dealCreateComplete(code: code, msg: msg, orderPay: orderPay, errorModel: errorModel)
        }
    }
    /// 余额请求
    ///
    /// - Parameters:
    ///   - orderPay: 支付数据
    ///   - pwd: 密码
    fileprivate func sp_sendBalanceRequest(orderPay:SPOrderPayModel?,pwd:String){
        guard let pay = orderPay else {
            return
        }
        let payRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: pay.payment_id), forKey: "payment_id")
        parm.updateValue(sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id), forKey: "pay_app_id")
        parm.updateValue(sp_getString(string: pwd), forKey: "deposit_password")
        payRequest.parm = parm
        SPAppRequest.sp_getToPay(requestModel: payRequest) { [weak self](data, errorModel) in
             sp_hideAnimation(view: nil)
            if let dic = data {
                sp_showTextAlert(tips: sp_getString(string: dic[SP_Request_Msg_Key]))
                if sp_getString(string: dic[SP_Request_Errorcod_Key] ) == SP_Request_Code_Success{
                     self?.sp_pushOrderList(isSuccess: true)
                }else{
                     self?.sp_pushOrderList(isSuccess: false)
                }
            }else{
                  self?.sp_pushOrderList(isSuccess: false)
            }
        }
    }
    fileprivate func sp_sendWXRequest(orderPay:SPOrderPayModel?){
        guard let pay = orderPay else {
            return
        }
        let payRequest = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: pay.payment_id), forKey: "payment_id")
//        if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.wxPay.rawValue {
//              parm.updateValue(sp_getString(string: SPPayType.wxPing.rawValue), forKey: "pay_app_id")
//        }else if sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.aliPay.rawValue{
//              parm.updateValue(sp_getString(string: SPPayType.alipayPing.rawValue), forKey: "pay_app_id")
//        }else{
        parm.updateValue(sp_getString(string: self.confirmOrder?.selectPayModel?.app_rpc_id), forKey: "pay_app_id")
//        }
        payRequest.parm = parm
        self.bounceApp = false
        SPAppRequest.sp_getToPay(requestModel: payRequest) { [weak self](data, errorModel) in
            if sp_isDic(dic: data) {
              
                let errorCode  = sp_getString(string: data?[SP_Request_Errorcod_Key])
                if sp_getString(string: errorCode).count > 0, sp_getString(string: errorCode) != SP_Request_Code_Success {
                    self?.bounceApp = false
                    sp_hideAnimation(view: nil)
                    sp_showTextAlert(tips: "支付失败")
                    self?.sp_pushOrderList(isSuccess: false)
                }else{
                    self?.bounceApp = true
                    let payData = sp_dicValueString(data!)
                    if sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.wxPay.rawValue {
                        SPThridManager.sp_wxPay(dic: data!)
                    }else if sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.aliPay.rawValue{
                         SPThridManager.sp_aliPay(payOrder: sp_getString(string: data?["url"]))
                    }else if  sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.wxPing.rawValue ||  sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.alipayPing.rawValue ||  sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.upacpPing.rawValue{
                        if sp_getString(string: self?.confirmOrder?.selectPayModel?.app_rpc_id) == SPPayType.upacpPing.rawValue {
                             sp_hideAnimation(view: nil)
                        }
                        SPThridManager.sp_pingPay(data: payData, complete: { [weak self](status) in
                            self?.bounceApp = false
                            sp_hideAnimation(view: nil)
                            self?.sp_pushOrderList(isSuccess: sp_getString(string: status) == SP_PAY_SUCCESS ? true : false)
                        })
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
    /// 根据地址获取价格
    fileprivate func sp_sendPriceRequest(){
        guard let aModel = self.confirmOrder?.default_address else {
            return
        }
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(modelType, forKey: "mode")
        parm.updateValue(Int(sp_getString(string: aModel.addr_id)) ?? 0, forKey: "addr_id")
        parm.updateValue(sp_getShopShipping().0, forKey: "shipping")
        request.parm = parm
        SPAppRequest.sp_getTotalPrice(requestModel: request) { [weak self](code, msg, priceModel, errorModel) in
            if code == SP_Request_Code_Success{
                priceModel?.allCostFee = self?.confirmOrder?.total?.allCostFee
                self?.confirmOrder?.total = priceModel
                self?.sp_dealBottom()
                self?.sp_dealFooterView()
            }
        }
    }
    fileprivate func sp_sendPayListRequest(){
        SPAppRequest.sp_getPayList(requestModel: SPRequestModel()) { [weak self](code , list, errorModel, total ) in
            if code == SP_Request_Code_Success {
                self?.confirmOrder?.payType = list as? [SPPayModel]
                self?.payView.payDataArray = self?.confirmOrder?.payType
            }
            
        }
    }
    fileprivate func sp_sendBalanceStatusReequest(){
        SPAppRequest.sp_getBalanceStatus(requestModel: SPRequestModel()) { [weak self](code, balanceStatus, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                self?.payView.balanceStatus = balanceStatus
            }
        }
        
    }
}
