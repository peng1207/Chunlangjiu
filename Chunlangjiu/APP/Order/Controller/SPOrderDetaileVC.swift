//
//  SPOrderDetaileVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPOrderDetaileVC: SPBaseVC {
//    fileprivate lazy var headerView : SPOrderStateView = {
//        let view = SPOrderStateView()
//        view.frame = CGRect(x: 0, y: 0, width: 0, height: sp_lineHeight)
//        view.isHidden = true
//        return view
//    }()
    fileprivate lazy var headerView : SPOrderHeaderView = {
        let view = SPOrderHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenHeight())
        view.isHidden = true
        return view
    }()
    fileprivate lazy var footerView : SPOrderFooterView = {
        let view = SPOrderFooterView()
        view.isHidden = true
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenHeight())
        view.priceView.offerView.btn.addTarget(self, action: #selector(sp_clickEditPrice), for: UIControlEvents.touchUpInside)
        return view
    }()
    fileprivate lazy var bottomView : SPOrderBottomView = {
        let view = SPOrderBottomView()
        view.clickBlock = {  [weak self](model,btnIndex) in
            SPOrderHandle.sp_dealOrder(orderModel: model, btnIndex: btnIndex, viewController: self, complete: {(isSuccess) in
                if isSuccess {
                    self?.sp_request()
                }
            })
        }
        view.isHidden = true
        return view
    }()
 
    fileprivate var tableView : UITableView!
    fileprivate var orderDetaileModel : SPOrderDetaileModel?
    fileprivate var bottomHeight : Constraint!
    var orderModel : SPOrderModel?
    var toolModel : SPOrderToolModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单详情"
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_request()
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 125
        self.tableView.beginUpdates()
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        self.tableView.endUpdates()
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.bottomView)
     
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.bottomView.snp.top).offset(0)
        }
        self.bottomView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
           self.bottomHeight = maker.height.equalTo(0).constraint
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                // Fallback on earlier versions
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        if #available(iOS 11.0, *) {
            self.headerView.snp.makeConstraints { (maker) in
                maker.width.equalTo(self.tableView)
            }
        }
       
//        self.headerView.snp.makeConstraints { (maker) in
//            maker.top.equalToSuperview()
//            maker.left.right.equalTo(view)
//            maker.centerX.equalToSuperview()
//            maker.height.greaterThanOrEqualTo(0).priority(.high)
//        }
//        self.footerView.snp.makeConstraints { (maker) in
//            maker.bottom.equalToSuperview()
//            maker.left.right.equalTo(view)
//            maker.height.greaterThanOrEqualTo(0)
//        }
    }
    deinit {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        sp_removeTimeNotification()
    }
}
extension SPOrderDetaileVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.orderDetaileModel != nil else {
            return 0
        }
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let detaile = self.orderDetaileModel else {
            return 0
        }
        return sp_getArrayCount(array: detaile.orders)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderCellID = "orderCellID"
        var cell : SPOrderTableCell? = tableView.dequeueReusableCell(withIdentifier: orderCellID) as? SPOrderTableCell
        if cell == nil {
            cell = SPOrderTableCell(style: UITableViewCellStyle.default, reuseIdentifier: orderCellID)
            cell?.showAfterSales = true
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if let detaile = self.orderDetaileModel {
            if indexPath.row < sp_getArrayCount(array: detaile.orders){
                let model = detaile.orders?[indexPath.row]
                cell?.orderItem = model
            }
        }
        cell?.afterSaleBlock = { [weak self](itemModel ) in
            self?.sp_clickAfterSale(itemModel: itemModel)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderHeaderID = "orderHeaderID"
        var headerView : SPOrderTableHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeaderID) as? SPOrderTableHeaderView
        if headerView == nil {
            headerView = SPOrderTableHeaderView(reuseIdentifier: orderHeaderID)
//            headerView?.sp_leftRightZero()
//           headerView?.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        }
        if let detaile = self.orderDetaileModel {
            headerView?.orderModel = detaile
            headerView?.orderStateLabel.text = ""
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let orderFooterID = "orderFooterID"
        var footerView : SPOrderTableFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderFooterID) as? SPOrderTableFooterView
        if footerView == nil{
            footerView = SPOrderTableFooterView(reuseIdentifier: orderFooterID)
            footerView?.sp_leftRightZero()
            footerView?.priceColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        }
        if let detaile = self.orderDetaileModel {
            footerView?.orderModel = detaile
            footerView?.sp_hiddenBtn()
//            footerView?.clickBlock = { [weak self ](model,btnIndex) in
//                SPOrderHandle.sp_dealOrder(orderModel: model, btnIndex: btnIndex, viewController: self, complete: { (isSuccess) in
//                    if isSuccess {
//                        self?.currentPage = 1
//                        self?.sp_request()
//                    }
//                })
//            }
        }
     
        return footerView
    }
}
extension SPOrderDetaileVC{
    
    fileprivate func sp_request(){
        if  SPAPPManager.sp_isBusiness() {
            if self.toolModel?.orderType == SPOrderType.shopSaleType {
                sp_sendShopAfterSales()
            }else{
                if self.toolModel?.status == .userApplyRefund {
                    sp_sendCance()
                }else{
                     sp_sendShopDetaile()
                }
            }
           
        }else{
            if self.toolModel?.orderType == SPOrderType.afterSaleType{
                sp_sendAfterSalesRequest()
            }else if self.toolModel?.orderType == SPOrderType.auctionType{
                sp_sendAuction()
            }
            else{
                sp_sendRequest()
            }
        }
    }
    
    /// 获取普通订单详情
    fileprivate func sp_sendRequest(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        parm.updateValue(order.tid, forKey: "tid")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getOrderDetaile(requestModel: self.requestModel) { [weak self](code, detaile, errorModel) in
            self?.sp_dealRequest(code: code, detaile: detaile, errorModel: errorModel)
        }
    }
    /// 发送商家订单详情
    fileprivate func sp_sendShopDetaile(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        parm.updateValue("*", forKey: "fields")
        parm.updateValue(order.tid ?? 0 , forKey: "tid")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getShopOrderDet(requestModel: self.requestModel) { [weak self](code , detaile, errorModel) in
            self?.sp_dealRequest(code: code , detaile: detaile, errorModel: errorModel)
        }
    }
    /// 发送申请售后的订单详情
    fileprivate func sp_sendAfterSalesRequest(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: order.aftersales_bn), forKey: "aftersales_bn")
        parm.updateValue(sp_getString(string: order.oid), forKey: "oid")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getAfterSalesDet(requestModel: self.requestModel) { [weak self](code, detaile, errorModel) in
             self?.sp_dealRequest(code: code , detaile: detaile, errorModel: errorModel)
        }
    }
    fileprivate func sp_sendShopAfterSales(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String:Any]()
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        parm.updateValue(sp_getString(string: order.aftersales_bn), forKey: "aftersales_bn")
        parm.updateValue(sp_getString(string: order.oid), forKey: "oid")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getShopAfterSalesDet(requestModel: self.requestModel) { [weak self](code, detaile, errorModel) in
            self?.sp_dealRequest(code: code , detaile: detaile, errorModel: errorModel)
        }
        
    }
    fileprivate func sp_sendAuction(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: order.auctionitem_id), forKey: "auctionitem_id")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getAuctionOrderDet(requestModel: self.requestModel) { [weak self](code, detaile, errorModel) in
              self?.sp_dealRequest(code: code , detaile: detaile, errorModel: errorModel)
        }
    }
    private func sp_sendCance(){
        guard let order = self.orderModel else {
            return
        }
        sp_showAnimation(view: self.view, title: nil)
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: order.cancel_id), forKey: "cancel_id")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getCanceDet(requestModel: self.requestModel) {  [weak self](code , detaile, errorModel) in
               self?.sp_dealRequest(code: code , detaile: detaile, errorModel: errorModel)
        }
    }
    private func sp_dealRequest(code:String,detaile : SPOrderDetaileModel?,errorModel : SPRequestError?){
        if code == SP_Request_Code_Success,detaile != nil{
            self.orderDetaileModel = detaile
            self.sp_setupData()
            self.tableView.isHidden = false

        }else{
            self.tableView.isHidden = true
        }
        sp_hideAnimation(view: self.view)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.tableView.reloadData()
        self.headerView.isHidden = false
        self.footerView.isHidden = false
        self.headerView.detaileModel = self.orderDetaileModel
        self.footerView.detaileModel = self.orderDetaileModel
     
        self.bottomView.orderDetaile = self.orderDetaileModel
        let bottomIsHidden = SPOrderBtnManager.sp_dealDetBtn(orderModel: self.orderDetaileModel)
        self.bottomView.isHidden = bottomIsHidden
        self.bottomHeight.update(offset: bottomIsHidden ? 0 : 44)
        if sp_getString(string: orderDetaileModel?.status) == SP_WAIT_BUYER_PAY ||  (sp_getString(string: orderDetaileModel?.status) == SP_AUCTION_0 && sp_getString(string: orderDetaileModel?.type) == SP_AUCTION ) || (sp_getString(string: orderDetaileModel?.status) == SP_AUCTION_1 && sp_getString(string: orderDetaileModel?.type) == SP_AUCTION) || (sp_getString(string: orderDetaileModel?.type) == SP_AUCTION && sp_getString(string: orderDetaileModel?.status) == SP_AUCTION_2 && sp_getString(string: orderDetaileModel?.trade_ststus) == SP_WAIT_BUYER_PAY){
             sp_addTimeNotification()
        }
        self.tableView.sp_layoutHeaderView()
        self.tableView.sp_layoutFooterView()
        
    }
}
// MARK: - action
extension SPOrderDetaileVC {
    fileprivate func sp_clickAfterSale(itemModel : SPOrderItemModel?){
        if sp_getString(string: itemModel?.aftersales_status) != SP_WAIT_SELLER_AGREE {
            let appleVC = SPOrderApplyRefundVC()
            appleVC.itemModel = itemModel
            appleVC.orderModel = self.orderDetaileModel
            self.navigationController?.pushViewController(appleVC, animated: true)
        }
    }
    @objc fileprivate func sp_clickEditPrice(){
        guard let order = self.orderDetaileModel else {
            return
        }
        SPOrderHandle.sp_auctionEditPrice(order: order, viewController: self) { (isSuccess) in
            if isSuccess{
                self.sp_request()
            }
        }
    }
}
extension SPOrderDetaileVC{
    fileprivate func sp_addTimeNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_time(notification:)), name: Notification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
    }
    fileprivate func sp_removeTimeNotification(){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_time(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
        if let det = self.orderDetaileModel {
            det.sp_set(s: second)
            sp_mainQueue {
                self.headerView.detaileModel = det
                self.tableView.sp_layoutHeaderView()
            }
           
//            if det.second <= 0 {
//                sp_request()
//            }
        }
    }
}
