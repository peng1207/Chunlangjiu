//
//  SPShopProductVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit


class SPShopProductVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPProductModel]?
    fileprivate lazy var timeBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("时间", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.sp_border(color: SPColorForHexString(hex: SP_HexColor.color_666666.rawValue), width: sp_lineHeight)
        btn.sp_cornerRadius(cornerRadius: 3)
        btn.addTarget(self, action: #selector(sp_clickTime), for: UIControlEvents.touchUpInside)
        return btn
    }()
    var type : SP_Product_Type = SP_Product_Type.sale
    fileprivate var selectDate : Date?
    fileprivate var currentPage : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_sendRequest()
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
        self.view.addSubview(self.timeBtn)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.sp_headerRefesh {[weak self] in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        self.tableView.sp_footerRefresh { [weak self]in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendRequest()
            }
        }
        self.view.addSubview(self.tableView)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "没有找到相关的商品"
            self.view.bringSubview(toFront: self.noData)
        }
        sp_mainQueue {
            self.tableView.reloadData()
            self.tableView.sp_stopFooterRefesh()
            self.tableView.sp_stopHeaderRefesh()
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.timeBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.view).offset(5)
            maker.height.equalTo(20)
            maker.width.equalTo(75)
            maker.right.equalTo(self.view).offset(-22)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.timeBtn.snp.bottom).offset(5)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
    }
    deinit {
        
    }
}
extension SPShopProductVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "shopProductCellID"
        var cell : SPShopProductTableCell? = tableView.dequeueReusableCell(withIdentifier: cellID) as? SPShopProductTableCell
        if cell == nil {
            cell = SPShopProductTableCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.productModel = self.dataArray?[indexPath.row]
        }
        cell?.clickBlock = { [weak self] (type,model)in
            self?.sp_dealBtnClickComplete(type: type, model: model)
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
              return  sp_getRowHeight(model:self.dataArray?[indexPath.row] )
        }else{
            return 0
        }
      
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            sp_pushDet(model: self.dataArray?[indexPath.row])
        }
    }
    
    /// 获取每行的高度
    ///
    /// - Parameter model: 商品数据
    /// - Returns: 高度
    fileprivate func sp_getRowHeight(model : SPProductModel?)->CGFloat{
        guard let productModel = model else {
            return 0
        }
        var height : CGFloat = 125 + 10
        if sp_getString(string: productModel.approve_status) == SP_Product_Type.warehouse.rawValue {
            if sp_getScreenWidth() < 375 {
                height = height + 30
            }
        }
        return height
    }
    
}
extension SPShopProductVC {
    
    fileprivate func sp_pushDet(model : SPProductModel? ){
        let detVC = SPShopProductDetVC()
        detVC.item_id = model?.item_id
        self.navigationController?.pushViewController(detVC, animated: true)
    }
    fileprivate func sp_pushAdd(model : SPProductModel?){
        let addVC = SPProductAddVC()
        addVC.edit = true
        addVC.item_id = sp_getString(string: model?.item_id)
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    fileprivate func sp_pushSetAuctionVC(model : SPProductModel?){
        let vc = SPSetAuctionProductVC()
        vc.model = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_lookReason(model : SPProductModel?){
        
    }
    
    @objc fileprivate func sp_clickTime(){
        SPDatePicker.sp_show(datePickerMode: UIDatePicker.Mode.date, minDate: nil, maxDate:Date()) { [weak self](date) in
            self?.selectDate = date
            self?.currentPage = 1
            self?.sp_sendRequest()
            self?.sp_dealDate()
        }
    }
    fileprivate func sp_dealDate(){
        self.timeBtn.setTitle(SPDateManager.sp_dateString(to: self.selectDate), for: UIControlState.normal)
        self.timeBtn.snp.updateConstraints { (maker) in
            maker.width.equalTo(100)
        }
    }
    
    /// 处理cell按钮点击回调
    ///
    /// - Parameters:
    ///   - type: 点击类型
    ///   - model: 数据
    fileprivate func sp_dealBtnClickComplete(type:SP_Product_Cell_Btn_Type,model : SPProductModel?){
        switch type {
        case .lookDet:
            sp_pushDet(model: model)
        case .edit:
            sp_pushAdd(model: model)
        case .setAuction:
            sp_pushSetAuctionVC(model: model)
        case .lower:
            sp_sendLowerRequest(model: model)
        case .upper:
            sp_sendUpperRequesst(model: model)
        case .reason:
            sp_lookReason(model: model)
        
        }
    }
    
    
}
extension SPShopProductVC {
    fileprivate func sp_sendRequest(){
        if self.type == .auction_ing || self.type == .auction_end {
            sp_sendAuctionRequest()
        }else{
             sp_sendProductRequest()
        }
    }
    
    fileprivate func sp_sendProductRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.type.rawValue), forKey: "status")
        parm.updateValue(self.currentPage, forKey: "pages_no")
        parm.updateValue(10, forKey: "page_size")
        if let date = self.selectDate {
            let day = SPDateManager.sp_dateString(to: date)
            sp_log(message: "\(day)")
            
            parm.updateValue(Int(SPDateManager.sp_timeInterval(to: "\(day) 00:00:00")), forKey: "created_time")
        }
        self.requestModel.parm = parm
        SPProductRequest.sp_getShopProductList(requestModel: self.requestModel) { [weak self](code, list, errorModel, totalPage) in
            self?.sp_dealComplete(code: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    fileprivate func sp_sendAuctionRequest(){
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.type.rawValue), forKey: "status")
        parm.updateValue(self.currentPage, forKey: "pages_no")
        parm.updateValue(10, forKey: "page_size")
        if let date = self.selectDate {
            let day = SPDateManager.sp_dateString(to: date)
            sp_log(message: "\(day)")
            parm.updateValue(Int(SPDateManager.sp_timeInterval(to: "\(day) 00:00:00")), forKey: "created_time")
        }
        self.requestModel.parm = parm
        SPProductRequest.sp_getShopProductAuctionList(requestModel: self.requestModel) { [weak self](code, list, errorModel, totalPage) in
              self?.sp_dealComplete(code: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    
    /// 处理 请求列表回调
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - list: 数量
    ///   - errorModel: 错误model
    ///   - totalPage: 总页数
    fileprivate func sp_dealComplete(code : String, list : [Any]?,errorModel : SPRequestError? , totalPage : Int) {
        if  code == SP_Request_Code_Success {
            if self.currentPage == 1 {
                self.dataArray?.removeAll()
            }
            if let array :  [SPProductModel] = self.dataArray ,let l : [SPProductModel] = list as? [SPProductModel]{
                self.dataArray = array + l
                if self.currentPage > 1 && sp_getArrayCount(array: l) <= 0 {
                    self.currentPage = self.currentPage - 1
                    if self.currentPage < 1 {
                        self.currentPage = 1
                    }
                }
            }else{
                self.dataArray = list as? [SPProductModel]
            }
            
        }
        
        sp_dealNoData()
    }
    /// 发送下架请求
    ///
    /// - Parameter model: 数据源
    fileprivate func sp_sendLowerRequest(model: SPProductModel?){
        guard let productModel = model else {
            return
        }
        var parm = [String : Any]()
        if let item_id = productModel.item_id {
            parm.updateValue(item_id, forKey: "item_id")
        }
        parm.updateValue("tostock", forKey: "type")
        let request = SPRequestModel()
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPProductRequest.sp_getShopChangeProductStatus(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : code == SP_Request_Code_Success ? "下架成功" : "下架失败")
            if code ==  SP_Request_Code_Success{
                self?.sp_removeProduct(mdoel: productModel)
                self?.sp_dealNoData()
            }
        }
    }
    /// 发送上架请求
    ///
    /// - Parameter model:数据源
    fileprivate func sp_sendUpperRequesst(model : SPProductModel?){
        guard let productModel = model else {
            return
        }
        var parm = [String : Any]()
        if let item_id = productModel.item_id {
            parm.updateValue(item_id, forKey: "item_id")
        }
        parm.updateValue("tosale", forKey: "type")
        let request = SPRequestModel()
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPProductRequest.sp_getShopChangeProductStatus(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? msg : code == SP_Request_Code_Success ? "上架成功" : "上架失败")
            
            if code ==  SP_Request_Code_Success{
                self?.sp_removeProduct(mdoel: productModel)
                self?.sp_dealNoData()
            }
        }
    }
    fileprivate func sp_removeProduct(mdoel : SPProductModel?){
        guard let tempModel = mdoel else {
            return
        }
        if sp_getArrayCount(array: self.dataArray) > 0  {
            var data = [SPProductModel]()
            for productModel in self.dataArray!{
                if productModel.item_id != tempModel.item_id {
                    data.append(productModel)
                }
            }
            self.dataArray = data
            sp_dealNoData()
        }
        
      
    }
    
}
