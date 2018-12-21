//
//  SPProductListVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/5.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductListVC: SPBaseVC {
    
    fileprivate lazy var conditionView : SPConditionView = {
        let view = SPConditionView()
        view.backgroundColor = UIColor.white
        view.selectComplete = { [weak self](rootModel, lv2Model,lv3Model) in
            self?.sp_dealSortComplete(rootModel: rootModel, lv2Model: lv2Model, lv3Model: lv3Model)
        }
        view.filterComplete = { [weak self](minPrice,maxPrice,minYear,maxYear,brand_id,wineryId ) in
            self?.sp_dealFilterComplete(minPrice, maxPrice, minYear, maxYear, brand_id, wineryId)
        }
        view.defaultBlock = { [weak self]()in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        view.clickBtnBlock = { [weak self](type) in
            self?.sp_dealConditionBtnClick(type: type)
        }
        return view
    }()
    fileprivate lazy var searchBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_search_white"), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate lazy var listBtn  : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_list"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_abreast"), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return btn
    }()
    fileprivate lazy var topBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "pubilc_topping"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickTopAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var shopCartBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_shopcart_white"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_shopcart_white"), for: UIControlState.highlighted)
//        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue).withAlphaComponent(0.3)
        btn.addTarget(self, action: #selector(sp_clickShopCartAction), for: UIControlEvents.touchUpInside)
//        btn.sp_cornerRadius(cornerRadius: 25)
        return btn
    }()
    fileprivate lazy var numLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = sp_getFontSize(size: 10)
        label.textAlignment = .center
        label.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textColor = UIColor.white
        label.sp_cornerRadius(cornerRadius: 8)
        return label
    }()
    fileprivate  var collectionView : UICollectionView!
    fileprivate  var dataArray : Array<SPProductModel>?
    fileprivate let collectHCellID = "collectHCellID"
    fileprivate let collectVCellID = "collectVCellID"
    fileprivate let collectHAuctionCellID = "collectHAuctionCellID"
    fileprivate var currentPage : Int = 1
    fileprivate var btnType : SPConditionBtnType = SPConditionBtnType.comprehensive
    fileprivate var topConstraint : Constraint!
    var canRequest : Bool = true
    fileprivate var isHiddenNav = false
    fileprivate var isEditPrice : Bool = false
    public var isH = false {
        didSet{
            if let collection = self.collectionView {
                collection.reloadData()
            }
        }
    }
    var rootModel : SPSortRootModel?
    var sortLv2Model : SPSortLv2Model?
    var sortLv3Model : SPSortLv3Model?
    var shopModel : SPShopModel?
    var brandModel : SPBrandModel? 
    var maxYear : String?
    var minYear : String?
    var maxPrice : String?
    var minPrice : String?
    var brand_id : Int?
    var wineryId : Int?
    var keywords : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "全部商品"
        self.sp_setupUI()
        self.conditionView.selectBrand = self.brandModel 
        if self.canRequest {
            self.sp_sendRequest()
//            self.sp_sendRequestFilter()
        }
        self.sp_sendRequestSort()
          sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_sendCountRquest()
        if self.isEditPrice {
            self.sp_searchRequest()
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
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.conditionView)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.register(SPProductListHCell.self, forCellWithReuseIdentifier: collectHCellID)
        self.collectionView.register(SPProductListVCell.self, forCellWithReuseIdentifier: collectVCellID)
        self.collectionView.register(SPProductAuctionCollectCell.self, forCellWithReuseIdentifier: collectHAuctionCellID)
        self.collectionView.showsVerticalScrollIndicator = false

        self.collectionView.sp_headerRefesh { [weak self] in
            self?.currentPage = 1
            self?.sp_sendRequest()
        }
        self.collectionView.sp_footerRefresh { [weak self] in
            if let page = self?.currentPage {
                self?.currentPage = page + 1
                self?.sp_sendRequest()
            }
           
        }
        self.view.addSubview(self.collectionView)
        self.searchBtn.addTarget(self, action: #selector(clickSearchAction), for: UIControlEvents.touchUpInside)
        self.listBtn.addTarget(self, action: #selector(clickListAction), for: UIControlEvents.touchUpInside)
        let searchItem = UIBarButtonItem(customView: self.searchBtn)
        let listBtnItem = UIBarButtonItem(customView: self.listBtn )
        self.navigationItem.rightBarButtonItems = [listBtnItem,searchItem]
        self.view.addSubview(self.topBtn)
        self.view.addSubview(self.shopCartBtn)
        self.view.addSubview(self.numLabel)
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
        self.collectionView.sp_stopFooterRefesh()
        self.collectionView.sp_stopHeaderRefesh()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.conditionView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            self.topConstraint = maker.top.equalTo(self.view).offset(0).constraint
            maker.height.greaterThanOrEqualTo(0)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(0)
            maker.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.conditionView.snp.bottom).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.topBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-10)
            maker.width.equalTo(50)
            maker.height.equalTo(50)
            maker.bottom.equalTo(self.collectionView.snp.bottom).offset(-50)
        }
        self.shopCartBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.topBtn.snp.right).offset(0)
            maker.width.height.equalTo(50)
            maker.bottom.equalTo(self.topBtn.snp.top).offset(-20)
        }
        self.numLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(self.shopCartBtn.snp.right).offset(0)
            maker.top.equalTo(self.shopCartBtn.snp.top).offset(0)
            maker.width.height.equalTo(16)
        }
    }
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
}
//MARK: - delegate
extension SPProductListVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isH {
            var productModel : SPProductModel?
            if indexPath.row < sp_getArrayCount(array: self.dataArray) {
                productModel = self.dataArray?[indexPath.row]
            }
            
            if let m = productModel, m.isAuction == true{
                let cell : SPProductAuctionCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectHAuctionCellID, for: indexPath) as! SPProductAuctionCollectCell
                cell.contentView.backgroundColor = self.view.backgroundColor
                cell.auctionView.productModel = m
                return cell
            }else{
                let cell : SPProductListHCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectHCellID, for: indexPath) as! SPProductListHCell
                cell.contentView.backgroundColor = self.view.backgroundColor
                   cell.productView.productModel = productModel
                cell.productView.addComplete = { [weak self](model) in
                    self?.sp_sendAddRequest(model: model)
                }
                return cell
            }
        }else{
            let cell : SPProductListVCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectVCellID, for: indexPath) as! SPProductListVCell
            cell.contentView.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
            if indexPath.row < sp_getArrayCount(array: self.dataArray) {
                cell.productView.productModel = self.dataArray?[indexPath.row]
            }
            cell.productView.addComplete = { [weak self](model) in
                self?.sp_sendAddRequest(model: model)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isH {
            var height : CGFloat = 150.00
            if indexPath.row < sp_getArrayCount(array: self.dataArray){
                let model = self.dataArray?[indexPath.row]
                if let m = model ,m.isAuction == true{
                    height = 175.00
                }
            }
            return  CGSize(width: collectionView.frame.size.width, height: indexPath.row == 0 ? height + 10 : height + 5)
        }else{
            let width =  NSInteger((collectionView.frame.size.width - 25) / 2.0)
            return  CGSize(width: CGFloat(width), height:  (CGFloat(width) * SP_PRODUCT_SCALE ) + 115 )
        }
    }
    // 返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if self.isH {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return  UIEdgeInsets(top: 5, left:10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.isH {
            return 0
        }else{
            return 5
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.isH {
            return 0
        }else{
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetaileVC = SPProductDetaileVC()
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            productDetaileVC.productModel = self.dataArray?[indexPath.row]
        }
        self.navigationController?.pushViewController(productDetaileVC, animated: true)
    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//         let point = scrollView.panGestureRecognizer.translation(in: self.view)
//        if point.y > 0  {
//            sp_log(message: "------往上滚动")
//            sp_showNav()
//        }else{
//            sp_log(message: "------往下滚动")
//            sp_hiddenNav()
//        }
//    }
}
//MARK: - action
extension SPProductListVC {
    ///  点击搜索按钮
    @objc fileprivate func clickSearchAction(){
        let searchVC = SPProductSearchVC()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    /// 点击列表按钮
    @objc fileprivate func clickListAction(){
        self.listBtn.isSelected = !self.listBtn.isSelected
        self.isH = self.listBtn.isSelected
        
    }
    fileprivate func sp_dealConditionBtnClick(type: SPConditionBtnType){
        self.btnType = type
        self.currentPage = 1
        self.sp_sendRequest()
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
        sp_searchRequest()
    }
    fileprivate func sp_dealFilterComplete(_ minPrice : String?,_ maxPrice: String?,_ minYear : String?,_ maxYear : String?,_ brand_id : Int?, _ wineryId : Int?) {
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.minYear = minYear
        self.maxYear = maxYear
        self.brand_id = brand_id
        self.wineryId = wineryId
        sp_searchRequest()
    }
    @objc fileprivate func sp_clickTopAction(){
        self.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    @objc fileprivate func sp_clickShopCartAction(){
        let shopCartVC = SPShopCartVC()
        self.navigationController?.pushViewController(shopCartVC, animated: true)
    }
    fileprivate func sp_hiddenNav(){
        if self.isHiddenNav == false{
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.topConstraint.update(offset: sp_getstatusBarHeight())
        }
        self.isHiddenNav = true
    }
    fileprivate func sp_showNav(){
        if self.isHiddenNav {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.topConstraint.update(offset: 0)
        }
        self.isHiddenNav = false
    }
   
}
// MARK: - 请求
extension SPProductListVC {
    
    /// 搜索 发送请求
    func sp_searchRequest(){
        self.currentPage = 1
        sp_sendRequest()
//        sp_sendRequestFilter()
    }
    
    /// 发送请求
    fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        if let shop = self.shopModel {
            parm.updateValue(shop.shop_id ?? "", forKey: "shop_id")
        }
        if let sort = self.sortLv3Model {
            if let catID =  sort.cat_id {
                parm.updateValue(catID, forKey: "cat_id")
            }
        }
        if let key = self.keywords {
            parm.updateValue(key, forKey: "search_keywords")
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
//        if self.btnType == .comprehensive {
//            parm.updateValue("", forKey: "orderBy")
//        }else if self.btnType == .new {
//            parm.updateValue("list_time", forKey: "orderBy")
//        }else if self.btnType == .price_asc{
//            parm.updateValue("price_asc", forKey: "orderBy")
//        }else if self.btnType == .price_desc {
//            parm.updateValue("price_desc", forKey: "orderBy")
//        }
//
//        if self.wineryId != nil {
//            parm.updateValue(wineryId ?? 0, forKey: "wineryId")
//        }
     
        self.requestModel.parm = parm
        SPAppRequest.sp_getProductList(requestModel: requestModel) { [weak self](code, list, errorModel,totalPage) in
            self?.sp_dealRequest(errorCode: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    /// 处理请求成功的
    ///
    /// - Parameters:
    ///   - errorCode:  请求code
    ///   - list: 返回数据列表
    ///   - errorModel: 错误model
    ///   - totalPage: 总页数
    fileprivate func sp_dealRequest(errorCode:String,list:[Any]?,errorModel:SPRequestError?,totalPage:Int){
        if errorCode == SP_Request_Code_Success {
            if self.currentPage == 1 {
                self.dataArray?.removeAll()
            }
            if let array :  Array<SPProductModel> = self.dataArray ,let l : [SPProductModel] = list as? [SPProductModel]{
                self.dataArray = array + l
                if self.currentPage > 1 && sp_getArrayCount(array: l) <= 0 {
                    self.currentPage = self.currentPage - 1
                    if self.currentPage < 1 {
                        self.currentPage = 1
                    }
                }
            }else{
                self.dataArray = list as? Array<SPProductModel>
            }
            sp_mainQueue {
              self.collectionView.reloadData()
            }
          
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
            self.conditionView.selectSortModel = self.sortLv3Model
            self.conditionView.selectBrand = self.brandModel
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
        parm.updateValue(sp_getString(string: self.keywords), forKey: "search_keywords")
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
    fileprivate func sp_sendAddRequest(model : SPProductModel?){
        
        if SPAPPManager.sp_isLogin(isPush: true) == false  {
            return
        }
        
        guard let m = model else {
            return
        }
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(m.item_id, forKey: "sku_id")
//        parm.updateValue(48, forKey: "sku_id")
        parm.updateValue(1, forKey: "quantity")
        parm.updateValue("", forKey: "package_sku_ids")
        parm.updateValue("", forKey: "package_id")
        parm.updateValue("item", forKey: "obj_type")
        parm.updateValue("cart", forKey: "mode")
        
        request.parm = parm
        SPAppRequest.sp_getAddProduct(requestModel: request) { (code , msg, errorModel) in
            if code == SP_Request_Code_Success {
                
            }else{
                sp_log(message: "添加商品失败哦哦哦哦")
            }
        }
    }
    fileprivate func sp_sendCountRquest(){
        let countRequest = SPRequestModel()
        SPAppRequest.sp_getShopCartCount(requestModel: countRequest) { [weak self](code, countModel, error) in
            if code == SP_Request_Code_Success {
                if let m = countModel {
                    if m.number > 0 {
                        self?.numLabel.isHidden = false
                    }else{
                        self?.numLabel.isHidden = true
                    }
                }else{
                    self?.numLabel.isHidden = true
                }
                
                self?.numLabel.text = sp_getString(string: countModel?.number)
            }
        }
        
    }
}
// MARK: - notification
extension SPProductListVC{
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_EDITPRICEAUCTON_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_editPrice), name: NSNotification.Name(SP_SUBMITAUCTION_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_auctionend(obj:)), name: NSNotification.Name(SP_AUCTIONEND_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_editPrice(){
        self.isEditPrice = true
    }
    @objc fileprivate func sp_auctionend(obj : Notification){
        if let dic : [String : Any] = obj.object as? [String : Any]{
        
            if let item_id : Int = dic["item_id"] as? Int , sp_getArrayCount(array: self.dataArray) > 0{
                var index = 0
                var isExist = false
                if sp_getArrayCount(array: self.dataArray) > 0 {
                    for model in self.dataArray! {
                        if let modelId = model.item_id , model.isAuction == true {
                            if modelId == item_id {
                                isExist = true
                                break
                            }
                        }
                        index = index + 1
                    }
                }
                
                if isExist, index < sp_getArrayCount(array: self.dataArray){
                    self.dataArray?.remove(at: index)
                }
                
                self.collectionView.reloadData()
                sp_dealNoData()
            }
            
        }
        
    }
}
