//
//  SPOrderListVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/28.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit

class SPOrderListVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPOrderModel]?
    fileprivate var currentPage : Int = 1
    var toolModel : SPOrderToolModel? 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_request()
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 70
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.noData);
        self.tableView.sp_headerRefesh {[weak self] () in
            self?.currentPage = 1
            self?.sp_request()
        }
        self.tableView.sp_footerRefresh { [weak self] () in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                 self?.sp_request()
            }
        }
        self.sp_addConstraint()
    }
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
            //            self.tableView.isHidden = false
        }else{
            self.noData.text = "您还没有相关订单!"
            self.noData.isHidden = false
            //            self.tableView.isHidden = true
        }
        self.tableView.sp_stopFooterRefesh()
        self.tableView.sp_stopHeaderRefesh()
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
       
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
}
extension SPOrderListVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let orderModel  = self.dataArray?[section]
            return sp_getArrayCount(array: orderModel?.order) > 0 ? 1 : 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model : SPOrderModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
        }
        
        if sp_getArrayCount(array: model?.order) > 1 {
            let orderImgCellID = "orderImgCellID"
            var imgCell : SPOrderImgeTableCell? = tableView.dequeueReusableCell(withIdentifier: orderImgCellID) as? SPOrderImgeTableCell
            if imgCell == nil {
                imgCell = SPOrderImgeTableCell(style: UITableViewCellStyle.default, reuseIdentifier: orderImgCellID)
            }
            imgCell?.model = model
            return imgCell!
        }
        
        let orderCellID = "orderCellID"
        var cell : SPOrderTableCell? = tableView.dequeueReusableCell(withIdentifier: orderCellID) as? SPOrderTableCell
        if cell == nil {
            cell = SPOrderTableCell(style: UITableViewCellStyle.default, reuseIdentifier: orderCellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
              let orderModel  = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: orderModel?.order){
                let orderItemModel = orderModel?.order?[indexPath.row]
                cell?.orderItem = orderItemModel
            }
            if indexPath.row == sp_getArrayCount(array: orderModel?.order) - 1 {
                cell?.productView.lineView.isHidden = true
            }else{
               cell?.productView.lineView.isHidden = false
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 59
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let orderHeaderID = "orderHeaderID"
        var headerView : SPOrderTableHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderHeaderID) as? SPOrderTableHeaderView
        if headerView == nil {
            headerView = SPOrderTableHeaderView(reuseIdentifier: orderHeaderID)
        }
        if section < sp_getArrayCount(array: self.dataArray) {
             let orderModel  = self.dataArray?[section]
            headerView?.orderModel = orderModel
        }
        headerView?.clickBlock = { [weak self](model) in
            self?.sp_clickHeader(orderModel: model)
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let orderFooterID = "orderFooterID"
        var footerView : SPOrderTableFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: orderFooterID) as? SPOrderTableFooterView
        if footerView == nil{
            footerView = SPOrderTableFooterView(reuseIdentifier: orderFooterID)
        }
        if section < sp_getArrayCount(array: self.dataArray) {
            let orderModel  = self.dataArray?[section]
            footerView?.orderModel = orderModel
            
            footerView?.clickBlock = { [weak self ](model,btnIndex) in
                SPOrderHandle.sp_dealOrder(orderModel: model, btnIndex: btnIndex, viewController: self, complete: { (isSuccess) in
                    if isSuccess {
                        self?.currentPage = 1
                        self?.sp_request()
                    }
                })
            }
        }
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray){
            let detaileVC = SPOrderDetaileVC()
            detaileVC.orderModel = self.dataArray?[indexPath.section]
            detaileVC.toolModel = self.toolModel
            self.navigationController?.pushViewController(detaileVC, animated: true)
        }
    }
    
}
extension SPOrderListVC {
    fileprivate func sp_request(){
        if SPAPPManager.sp_isBusiness() {
            if self.toolModel?.orderType == SPOrderType.shopSaleType{
                sp_sendShopAfterSales()
            }else{
                
                if self.toolModel?.status == .userApplyRefund{
                    sp_sendCance()
                }else{
                    sp_sendShopOrderRequest()
                }
                
            }
           
        }else{
            if self.toolModel?.orderType == SPOrderType.afterSaleType {
                sp_sendAfterSalesRequest()
            }else if self.toolModel?.orderType == SPOrderType.auctionType{
                sp_sendAuction()
            }
            else{
                sp_sendRequest()
            }
        }

    }
    /// 发送买家普通订单
    fileprivate func sp_sendRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        let state = sp_getRequestStatues(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
           parm.updateValue(sp_getString(string:state ), forKey: "status")
        }

        self.requestModel.parm = parm
        SPOrderRequest.sp_getOrderList(requestModel: self.requestModel) { [weak self](code, list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
        
    }
    /// 发送买家 申请售后退货的请求
    fileprivate func sp_sendAfterSalesRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        let state = sp_getRequestStatues(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
            parm.updateValue(sp_getString(string:state ), forKey: "status")
        }
        let progress = sp_progress(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
            parm.updateValue(sp_getString(string: progress), forKey: "progress")
        }
        self.requestModel.parm = parm
        SPOrderRequest.sp_getAfterSalesList(requestModel: self.requestModel) { [weak self](code, list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    /// 发送商家的订单列表
    fileprivate func sp_sendShopOrderRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        let state = sp_getRequestStatues(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
            parm.updateValue(sp_getString(string:state ), forKey: "status")
        }
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        parm.updateValue("*", forKey: "fields")
          self.requestModel.parm = parm
        SPOrderRequest.sp_getShopOrderList(requestModel: self.requestModel) { [weak self](code , list, errorModel, total) in
             self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    /// 发送商家售后订单列表
    fileprivate func sp_sendShopAfterSales(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        let state = sp_getRequestStatues(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
            parm.updateValue(sp_getString(string:state ), forKey: "status")
        }
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        parm.updateValue("*", forKey: "fields")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getShopAfterSales(requestModel: self.requestModel) { [weak self](code, list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_sendAuction(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        let state = sp_getRequestStatues(toolModel: self.toolModel)
        if sp_getString(string: state).count > 0 {
            parm.updateValue(sp_getString(string:state ), forKey: "status")
        }
        self.requestModel.parm = parm
        SPOrderRequest.sp_getAuctionOrderList(requestModel: self.requestModel) { [weak self](code , list , errorModel, total) in
             self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_sendCance(){
        var parm = [String : Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        self.requestModel.parm = parm
        SPOrderRequest.sp_getCanceList(requestModel: self.requestModel) { [weak self](code ,list, errorModel, total) in
              self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealRequest(code :String , list :[Any]? ,errorModel : SPRequestError? ,total:Int){
        if code == SP_Request_Code_Success {
            if self.currentPage <= 1 {
                self.dataArray?.removeAll()
            }
            if let array : [SPOrderModel] = self.dataArray,let l : [SPOrderModel] = list as? [SPOrderModel] {
                self.dataArray = array + l
            }else{
                self.dataArray = list as? [SPOrderModel]
            }
            
            self.tableView.reloadData()
          
        }else{
            if self.currentPage >  1 {
                self.currentPage = self.currentPage - 1
            }
        }
        self.sp_dealNoData()
    }
    
}
// MARK: - actiok data
extension SPOrderListVC{
   
    fileprivate func sp_clickHeader(orderModel : SPOrderModel?){
        guard let model = orderModel else {
            return
        }
        let shopVC = SPShopHomeVC()
        let shopModel = SPShopModel()
        shopModel.shop_name = model.shopname
        shopModel.shop_id = model.shop_id
        shopVC.shopModel = shopModel
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
}
