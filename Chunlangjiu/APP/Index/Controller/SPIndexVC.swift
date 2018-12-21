//
//  SPIndexVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 首页
import Foundation
import UIKit
import SnapKit
class SPIndexVC: SPBaseVC {
    fileprivate lazy var tableHeaderView : SPIndexHeaderView = {
        let view  = SPIndexHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: 0)
        view.iconView.selectblock = { [weak self](model) in
            self?.sp_dealIconSelect(model: model)
        }
        view.brandView.selectBlock = { [weak self](model) in
            self?.sp_dealBrandSelect(model: model)
            SPThridManager.sp_brand()
        }
        view.bannerView.selectBlock = { [weak self](row) in
            self?.sp_dealBannerSelect(row: row)
            SPThridManager.sp_banner()
        }
        return view
    }()
    fileprivate lazy var titleView : SPIndexTitleView =  {
        let view = SPIndexTitleView()
          let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickCityAction))
        view.showCityView.addGestureRecognizer(tap)
        view.msgBtn.addTarget(self, action: #selector(sp_clickMsgAction), for: UIControlEvents.touchUpInside)
        view.searchView.didClickBlock = { () -> Bool  in
            self.sp_clickSearch()
            return false
        }
        return view
    }()
    fileprivate var pushVC : Bool = false
    fileprivate  var tableView : UITableView!
    fileprivate var dataArray : [SPIndexGoods]! = [SPIndexGoods]()
    fileprivate var currentPage : Int = 1
    fileprivate var indexModel : SPIndexModel?
    fileprivate var isScroll : Bool! = false
    fileprivate var isEditPrice : Bool! = false
    fileprivate lazy var auctionGood : SPIndexGoods = {
        return SPIndexGoods.sp_init(type: SP_AUCTION)
    }()
    fileprivate lazy var defaultGood : SPIndexGoods = {
        return SPIndexGoods.sp_init(type: nil)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
        self.sp_sendRequest()
        self.sp_sendGoodRequest()
        self.tableView.sp_layoutHeaderView()
        self.sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: self.pushVC ? true : false)
        self.pushVC = false
        if self.isEditPrice {
            self.currentPage = 1
            sp_sendGoodRequest()
        }
        self.isEditPrice = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.titleView)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableHeaderView = self.tableHeaderView
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
//        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.sp_headerRefesh { [weak self]() in
            self?.currentPage = 1
            self?.sp_sendGoodRequest()
            self?.sp_sendRequest()
        }
        self.tableView.sp_footerRefresh { [weak self]() in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendGoodRequest()
            }
        }
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.titleView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(SP_NAVGIT_HEIGHT + sp_getstatusBarHeight())
            maker.top.equalTo(self.view).offset(0)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.titleView.snp.bottom).offset(0)
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
              maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
               maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.tableHeaderView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.left.right.equalTo(view)
             maker.centerX.equalToSuperview()
            maker.height.greaterThanOrEqualTo(0).priority(.high)
        }
    }
    deinit {
        
    }
}
extension SPIndexVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let indexGood = self.dataArray?[section]
            return sp_getArrayCount(array: indexGood?.dataArray)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let indexGood = self.dataArray?[indexPath.section]
            if sp_getString(string: indexGood?.type) == SP_AUCTION{
                let indexACellId = "indexACellId"
                var cell : SPIndexATableCell? = tableView.dequeueReusableCell(withIdentifier: indexACellId) as? SPIndexATableCell
                if cell == nil{
                    cell = SPIndexATableCell(style: UITableViewCellStyle.default, reuseIdentifier: indexACellId)
                }
                if indexPath.row < sp_getArrayCount(array: indexGood?.dataArray) {
                    cell?.auctionView.productModel = indexGood?.dataArray?[indexPath.row]
                }
                return cell!
            }else{
                let indexDCellID = "indexDCellID"
                var cell :  SPIndexDTableCell? = tableView.dequeueReusableCell(withIdentifier: indexDCellID) as? SPIndexDTableCell
                if cell == nil{
                    cell = SPIndexDTableCell(style: UITableViewCellStyle.default, reuseIdentifier: indexDCellID)
                }
                if indexPath.row < sp_getArrayCount(array: indexGood?.dataArray) {
                    
                    cell?.productModel = indexGood?.dataArray?[indexPath.row]
                }
                return cell!
            }
        }else{
            let noIndexDataCellID = "noIndexDataCellID"
            var cell = tableView.dequeueReusableCell(withIdentifier: noIndexDataCellID)
            if cell == nil{
                cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: noIndexDataCellID)
            }
            return cell!
        }
        
 
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let indexGood = self.dataArray?[indexPath.section]
            if sp_getString(string: indexGood?.type) == SP_AUCTION{
                return SPIndexATableCell_Product_Width + 15.0 + 11.0
            }else{
                 return SPIndexDTableCell_Product_Width + 15.0 + 11.0
            }
        }else{
            return  0
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SPIndexSectionDHeaderView_Title_Height
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < sp_getArrayCount(array: self.dataArray) {
            let indexGood = self.dataArray?[section]
            if sp_getString(string: indexGood?.type) == SP_AUCTION{
                return 10
            }else{
                return 0.01
            }
        }else{
            return  0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section < sp_getArrayCount(array: self.dataArray){
             let indexGood = self.dataArray?[section]
            if sp_getString(string: indexGood?.type) == SP_AUCTION{
                let indexAHeaderId = "indexAHeaderId"
                var headerView : SPIndexSectionAHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: indexAHeaderId) as? SPIndexSectionAHeaderView
                if headerView == nil {
                    headerView = SPIndexSectionAHeaderView(reuseIdentifier: indexAHeaderId)
                }
                headerView?.titleLabel.text = sp_getString(string: indexGood?.name)
                return headerView
            }else{
                let indexDHeaderId = "indexDHeaderId"
                var headerView : SPIndexSectionDHeaderView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: indexDHeaderId) as? SPIndexSectionDHeaderView
                if headerView == nil {
                    headerView = SPIndexSectionDHeaderView(reuseIdentifier: indexDHeaderId)
                }
                headerView?.titleLabel.text = sp_getString(string: indexGood?.name)
                headerView?.imageView.backgroundColor = UIColor.yellow
                return headerView
            }
        }else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section > sp_getArrayCount(array: self.dataArray) {
             let indexGood = self.dataArray?[section]
            if sp_getString(string: indexGood?.type) == SP_AUCTION{
                let indexAFooterId = "indexAFooterId"
                var footerView : UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: indexAFooterId)
                if footerView == nil{
                    footerView = UITableViewHeaderFooterView(reuseIdentifier: indexAFooterId)
                }
                footerView?.contentView.backgroundColor = self.view.backgroundColor
                return footerView
            }
            
        }
        return nil
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let indexGood = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: indexGood?.dataArray){
                let model = indexGood?.dataArray?[indexPath.row]
                let productDetaileVC = SPProductDetaileVC()
                productDetaileVC.productModel = model
                self.navigationController?.pushViewController(productDetaileVC, animated: true)
                self.pushVC = true
                if sp_getString(string: indexGood?.type) != SP_AUCTION{
                    if indexPath.row < 6 {
                     SPThridManager.sp_recommend(index: sp_getString(string: "\(indexPath.row + 1)"))
                    }
                }
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
          self.isScroll = true
         sp_log(message: "滚动开始")
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isScroll = true
        sp_log(message: "滚动开始")
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
        let  scrollToScrollStop : Bool = !scrollView.isTracking && !scrollView.isDragging && !scrollView.isDecelerating
        if scrollToScrollStop {
            sp_asyncAfter(time: 0.5) {
                self.isScroll = false
                sp_log(message: "滚动结束")
            }
        }
    }

  
}

// MARK: - action
extension SPIndexVC{
    
    func isAuction(string : String) -> Bool{
        if string == "1" {
            return true
        }else{
            return false
        }
    }
    @objc func sp_clickCityAction() {
        self.pushVC = true
        let cityVC = SPCityVC()
        self.navigationController?.pushViewController(cityVC, animated: true)
    }
    @objc fileprivate func sp_clickMsgAction(){
        if SPAPPManager.sp_isLogin(isPush: true) {
            let webVC = SPWebVC()
            webVC.url = URL(string: "\(SP_GET_MSG_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))")
            webVC.title = "消息"
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    /// 点击搜索
    fileprivate func sp_clickSearch(){
         self.pushVC = true
        let searchVC = SPProductSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    /// 处理icon选择的
    ///
    /// - Parameter model: model
    fileprivate func sp_dealIconSelect(model :SPIndexIconModel?){
        guard let iconModel = model else {
            return
        }
        SPIndexHande.sp_deal(viewController: self, lineType: iconModel.linktype,linktarget: iconModel.linktarget, webparam: iconModel.webparam)
        sp_dealPush(lineType: sp_getString(string: iconModel.linktype))
         SPThridManager.sp_icon(name: sp_getString(string: SPIndexHande.sp_getLintTypeName(lineType: iconModel.linktype)))
        
    }
    fileprivate func sp_dealPush(lineType : String){
        let type = sp_getString(string: lineType)
        if type == SPIndexType.item.rawValue || type == SPIndexType.brand.rawValue || type == SPIndexType.shop.rawValue || type == SPIndexType.winery.rawValue || type == SPIndexType.sellwine.rawValue || type == SPIndexType.h5.rawValue{
            self.pushVC = true
        }
    }
    
    /// 出来品牌点击
    ///
    /// - Parameter model: 数据
    fileprivate func sp_dealBrandSelect(model:SPBrandModel?){
        guard let brand = model else {
            return
        }
        
        SPIndexHande.sp_deal(viewController: self, lineType: sp_getString(string: brand.linktype),linktarget: sp_getString(string: brand.brand_id), webparam: nil,name: sp_getString(string: brand.brandname))
        sp_dealPush(lineType: sp_getString(string: brand.linktype))
    }
    /// 处理广告点击
    ///
    /// - Parameter row: 位置
    fileprivate func sp_dealBannerSelect(row:Int){
        sp_log(message: " 点击位置\(row)")
        if row < sp_getArrayCount(array: self.tableHeaderView.indexModel?.bannerList) {
            let model = self.tableHeaderView.indexModel?.bannerList?[row]
            guard let bannerModel = model else{
                return
            }
            SPIndexHande.sp_deal(viewController: self, lineType: bannerModel.linktype,linktarget: bannerModel.linktarget, webparam:  bannerModel.webparam)
            sp_dealPush(lineType: sp_getString(string: bannerModel.linktype))
        }
        
    }
}
// MARK: - notification
extension SPIndexVC{
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_locationNotification), name: NSNotification.Name(rawValue: SP_LOCATION_NOTIFICATION), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(sp_timeRun(notification:)), name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_EDITPRICEAUCTON_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_SUBMITAUCTION_NOTIFICATION), object: nil)
    }
    /// 定位成功通知
    @objc fileprivate func sp_locationNotification(){
        self.titleView.showCityView.sp_setupData()
    }
    @objc fileprivate func sp_timeRun(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
       
        if sp_getArrayCount(array: self.dataArray) > 0 {
            sp_simpleSQueues {
                if sp_getArrayCount(array: self.auctionGood.dataArray) > 0 {
                    var list = [SPProductModel]()
                    for model in self.auctionGood.dataArray! {
                        model.sp_set(second: second)
                        if model.second > 0 {
                            list.append(model)
                        }
                    }
                    self.auctionGood.dataArray = list
                    if self.isScroll == false {
                        sp_dealDataArray()
                    }
                }
            }
        }
    }
    @objc fileprivate func sp_editPrice(){
        self.isEditPrice = true
    }
    
}
extension SPIndexVC{
    
    fileprivate func sp_sendRequest(){
        let model = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue("index", forKey: "tmpl")
        model.parm = parm
        SPAppRequest.sp_getIndex(requestModel: model) { (code, indexModel, errorModel) in
            if code  == SP_Request_Code_Success {
                self.indexModel = indexModel
                self.tableHeaderView.indexModel = indexModel
                self.tableView.sp_layoutHeaderView()
            }
            sp_hideAnimation(view: self.view)
        }
    }
    fileprivate func sp_sendGoodRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "pagesize")
        parm.updateValue("index", forKey: "tmpl")
        self.requestModel.parm = parm
        SPAppRequest.sp_getIndexGoods(requestModel: self.requestModel) { (code,auctionList,list, errorModel, total) in
            self.sp_dealRequest(code: code,auctionList: auctionList, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealRequest(code:String,auctionList : [SPProductModel]?,list : [SPProductModel]? ,errorModel : SPRequestError?,total : Int){
        if code == SP_Request_Code_Success {
            if self.currentPage == 1 {
                if SP_ISSHOW_AUCTION {
                     self.auctionGood.dataArray = auctionList
                }
                self.defaultGood.dataArray = nil
            }
            
            if sp_getArrayCount(array: self.defaultGood.dataArray) > 0 {
                if sp_getArrayCount(array: list) > 0 {
                    if let dataArray = self.defaultGood.dataArray , let listData = list{
                        self.defaultGood.dataArray = dataArray + listData
                    }
                  
                }else{
                    if self.currentPage > 1 {
                        self.currentPage = self.currentPage - 1
                    }
                    if self.currentPage < 0 {
                        self.currentPage = 1
                    }
                }
            }else{
                self.defaultGood.dataArray = list
            }
         
        }
        sp_dealDataArray()
        sp_mainQueue {
            self.tableView.sp_stopHeaderRefesh()
            self.tableView.sp_stopFooterRefesh()
        }
      
    }
    fileprivate func sp_dealDataArray(){
        self.dataArray?.removeAll()
        if sp_getArrayCount(array: self.auctionGood.dataArray) > 0 {
            self.dataArray?.append(self.auctionGood)
        }
        if sp_getArrayCount(array: self.defaultGood.dataArray) > 0 {
            self.dataArray?.append(self.defaultGood)
        }
        sp_mainQueue {
            
            self.tableView.reloadData()
            self.isScroll = false
            
        }
    }
    
    
    
}
