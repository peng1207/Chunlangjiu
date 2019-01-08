//
//  SPAuctionVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 拍卖类
import Foundation
import SnapKit
class SPAuctionVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate lazy var conditionView : SPConditionView = {
        let view = SPConditionView()
        view.backgroundColor = UIColor.white
        view.selectComplete = { [weak self](rootModel, lv2Model,lv3Model) in
            self?.sp_dealSortComplete(rootModel: rootModel, lv2Model: lv2Model, lv3Model: lv3Model)
        }
        view.filterComplete = { [weak self](minPrice,maxPrice,minYear,maxYear,brand_id,wineryId ) in
            self?.sp_dealFilterComplete(minPrice, maxPrice, minYear, maxYear, brand_id, wineryId)
        }
        view.clickBtnBlock = { [weak self](type) in
            self?.sp_dealConditionBtnClick(type: type)
        }
        view.defaultBlock = { [weak self] in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        return view
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(sp_clickSearchAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var topBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "pubilc_topping"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickTopAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var dataArray : [SPProductModel]?
    fileprivate var btnType : SPConditionBtnType = SPConditionBtnType.comprehensive
    var rootModel : SPSortRootModel?
    var sortLv2Model : SPSortLv2Model?
    var sortLv3Model : SPSortLv3Model?
    var maxYear : String?
    var minYear : String?
    var maxPrice : String?
    var minPrice : String?
    var brand_id : Int?
    var wineryId : Int?
    var keywords : String?
    fileprivate var isScroll : Bool = false
    fileprivate var currentPage : Int = 1
    fileprivate var isEditPrice : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "竞拍专区"
        self.sp_setupUI()
        self.sp_sendRequest()
        self.conditionView.sp_sendReqest()
//        self.sp_sendRequestSort()
        //        self.sp_sendRequestFilter()
        sp_addNotificaton()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isEditPrice {
            self.currentPage = 1
            self.sp_sendRequest()
        }
        self.isEditPrice = false
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
        self.view.addSubview(self.conditionView)
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.backgroundColor = self.view.backgroundColor
        self.view.addSubview(self.tableView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.searchBtn)
        self.view.addSubview(self.topBtn)
        self.tableView.sp_headerRefesh { [weak self]in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
//        self.tableView.sp_footerRefresh {
//            self.currentPage = self.currentPage + 1
//            self.sp_sendRequest()
//        }
        self.sp_addConstraint()
    }
    /// 处理没有数据的展示
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0  {
            self.noData.isHidden = true
        }else{
            self.noData.text = "没有找到商品哦"
            self.noData.isHidden = false
            self.view.bringSubview(toFront: self.noData)
        }
        self.tableView.sp_stopFooterRefesh()
        self.tableView.sp_stopHeaderRefesh()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.conditionView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.conditionView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.topBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.view.snp.right).offset(-10)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.bottom.equalTo(self.tableView.snp.bottom).offset(-30)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPAuctionVC : UITableViewDelegate ,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let auctionCellID = "auctionCellID"
        var cell : SPAuctionTableCell? = tableView.dequeueReusableCell(withIdentifier: auctionCellID) as? SPAuctionTableCell
        if cell == nil {
            cell = SPAuctionTableCell(style: UITableViewCellStyle.default, reuseIdentifier: auctionCellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray){
            let productModel = self.dataArray?[indexPath.row]
            cell?.auctionView.productModel = productModel
            cell?.auctionView.productView.shopBlock = { [weak self](model) in
                self?.sp_clickShop(model: model)
            }
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let detaileVC = SPProductDetaileVC()
            detaileVC.productModel = self.dataArray?[indexPath.row]
            self.navigationController?.pushViewController(detaileVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 185
        }
        return 180
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScroll = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.isScroll = true
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
extension SPAuctionVC {
    @objc fileprivate func sp_clickSearchAction(){
        let searchVC = SPProductSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    @objc fileprivate func sp_clickTopAction(){
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    /// 处理点击分类回调
    ///
    /// - Parameters:
    ///   - rootModel: 主分类
    ///   - lv2Model: 第二级分类
    ///   - lv3Model: 第三级分类
    fileprivate func sp_dealSortComplete(rootModel:SPSortRootModel?,lv2Model:SPSortLv2Model?,lv3Model:SPSortLv3Model?){
        self.rootModel = rootModel
        self.sortLv2Model = lv2Model
        self.sortLv3Model = lv3Model
        sp_sendRequest()
    }
    fileprivate func sp_dealFilterComplete(_ minPrice : String?,_ maxPrice: String?,_ minYear : String?,_ maxYear : String?,_ brand_id : Int?, _ wineryId : Int?) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.minYear = minYear
        self.maxYear = maxYear
        self.brand_id = brand_id
        self.wineryId = wineryId
        sp_sendRequest()
    }
    fileprivate func sp_dealConditionBtnClick(type: SPConditionBtnType){
        self.btnType = type
        self.currentPage = 1
        self.sp_sendRequest()
    }
    fileprivate func sp_clickShop(model : SPProductModel?){
        guard let product = model else {
            return
        }
        let shopModel = SPShopModel()
        let shopVC = SPShopHomeVC()
        shopVC.shopModel = shopModel
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
}
extension SPAuctionVC{
    fileprivate func sp_sendRequest(){
        var parm = [String:Any]()
        
        
        if let sort = self.sortLv3Model {
            if let catID =  sort.cat_id {
                parm.updateValue(catID, forKey: "cat_id")
            }
        }
        
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        if let brand_id = self.conditionView.selectBrand?.brand_id {
            parm.updateValue(brand_id, forKey: "brand_id")
        }
        if let area_id = self.conditionView.selectPlace?.area_id {
            parm.updateValue(area_id, forKey: "area_id")
        }
        if let odor_id = self.conditionView.selectType?.odor_id {
            parm.updateValue(odor_id, forKey: "odor_id")
        }
        if let alcohol_id = self.conditionView.alcoholDegree?.alcohol_id {
            parm.updateValue(alcohol_id, forKey: "alcohol_id")
        }
        if let price = self.conditionView.selectprice {
            if sp_getString(string: price.maxPrice).count > 0 {
                parm.updateValue(sp_getString(string: price.maxPrice), forKey: "max_price")
            }
            if sp_getString(string: price.minPrice).count > 0 {
                parm.updateValue(sp_getString(string: price.minPrice), forKey: "min_price")
            }
        }
        
        self.requestModel.parm = parm
        SPAppRequest.sp_getAuctionList(requestModel: self.requestModel) { [weak self](code , list, errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    fileprivate func sp_dealRequest(code : String,list:[Any]?,errorModel : SPRequestError?,total : Int){
        if code == SP_Request_Code_Success {
            if self.currentPage == 1 {
                self.dataArray?.removeAll()
            }
            if let array :  Array<SPProductModel> = self.dataArray ,let l : [SPProductModel] = list as? [SPProductModel]{
                self.dataArray = array + l
            }else{
                self.dataArray = list as? Array<SPProductModel>
            }
           
            self.tableView.reloadData()
        }
        sp_dealNoData()
    }
    /// 获取分类
    fileprivate func sp_sendRequestSort(){
        let request = SPRequestModel()
        SPAppRequest.sp_getCategory(requestModel: request) { [weak self](code, list, errorModel,totalPage) in
            self?.sp_dealSortRequest(code: code, list: list, errorModel: errorModel)
        }
    }
    fileprivate func sp_dealSortRequest(code:String,list:[Any]?,errorModel:SPRequestError?) {
        if code == SP_Request_Code_Success {
            self.conditionView.sortArray = list as? [SPSortLv3Model]
//            self.conditionView.sp_setSort(sortArray: list as? [SPSortRootModel], rootModel: self.rootModel, lv2Model: self.sortLv2Model, lv3Model: self.sortLv3Model)
        }
    }
    /// 获取筛选数据
    fileprivate func sp_sendRequestFilter(){
        let request = SPRequestModel()
        var parm = [String:Any]()
        if let m = self.sortLv3Model {
            if let catID =  m.cat_id {
                parm.updateValue(catID, forKey: "cat_id")
            }
        }
        
        request.parm = parm
        SPAppRequest.sp_getFilter(requestModel: request) { [weak self](code, filterModel : SPFilterModel?, errorModel) in
            self?.sp_dealFilterRequest(code: code, fileterModel: filterModel, errorModel: errorModel)
        }
    }
    /// 处理筛选请求
    ///
    /// - Parameters:
    ///   - code: 请求码
    ///   - fileterModel: 筛选数据
    ///   - errorModel: 错误
    private func sp_dealFilterRequest(code : String,fileterModel : SPFilterModel?,errorModel : SPRequestError?){
        if code == SP_Request_Code_Success{
            self.conditionView.filterModel = fileterModel
        }
    }
}
// MARK: - notification
extension SPAuctionVC{
    func sp_addNotificaton(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_timeRun(notification:)), name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_EDITPRICEAUCTON_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_SUBMITAUCTION_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_netChange), name: NSNotification.Name(SP_NETWORK_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_timeRun(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
//       sp_log(message: "竞拍列表接收到时间")
        if sp_getArrayCount(array: self.dataArray) > 0 {
            sp_simpleSQueues {
                var list = [SPProductModel]()
                for model in self.dataArray! {
                    model.sp_set(second: second)
                    if model.second > 0 {
                        list.append(model)
                    }
                }
                self.dataArray = list
                sp_mainQueue {
                    if self.isScroll == false {
                         self.tableView.reloadData()
                        self.isScroll = false
                    }
                }
            }
        }
    }
    @objc fileprivate func sp_editPrice(){
        self.isEditPrice = true
    }
    
    @objc fileprivate func sp_netChange(){
        if SPNetWorkManager.sp_notReachable() == false {
            // 有网络
            if sp_getArrayCount(array: self.dataArray) <= 0 {
                sp_sendRequest()
            }
        }
    }
}
