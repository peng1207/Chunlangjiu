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
        view.countLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sp_clickMsgAction)))
        view.searchView.didClickBlock = { () -> Bool  in
            self.sp_clickSearch()
            return false
        }
        return view
    }()
    fileprivate lazy var noNetLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 15)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        label.textAlignment = .left
        label.text = "  当前网络出现问题，请检查您的网络设置"
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickNetFailure))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    fileprivate lazy var nodataBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("没有数据，点击重试", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(sp_clickNoData), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var pushVC : Bool = false
    fileprivate var tableView : UITableView!
    fileprivate var collectionView : UICollectionView!
    fileprivate var dataArray : [SPIndexGoods]! = [SPIndexGoods]()
    fileprivate var currentPage : Int = 1
    fileprivate var indexModel : SPIndexModel?
    fileprivate var isEditPrice : Bool! = false
    fileprivate let collectVCellID = "collectVCellID"
    fileprivate let collectHAuctionCellID = "collectHAuctionCellID"
    fileprivate let collectionHeadHeaderID = "collectionHeadHeaderID"
    fileprivate let collectionHeaderID = "collectionHeaderID"
    fileprivate lazy var msgRequestModel : SPRequestModel = {
        let model = SPRequestModel()
        return model
    }()
    fileprivate lazy var indexRequestModel : SPRequestModel = {
        let model = SPRequestModel()
        return model
    }()
    fileprivate lazy var auctionGood : SPIndexGoods = {
        return SPIndexGoods.sp_init(type: SP_AUCTION)
    }()
    fileprivate lazy var defaultGood : SPIndexGoods = {
        return SPIndexGoods.sp_init(type: nil)
    }()
    fileprivate lazy var headerModel : SPIndexGoods = {
        let model = SPIndexGoods.sp_init(type: SP_HEADER)
        return model
    }()
    fileprivate var noNetHeight : Constraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
        sp_clickNoData()
        sp_netChange()
        sp_addNotification()
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
        sp_sendMsgCountRequest()
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
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SPProductListVCell.self, forCellWithReuseIdentifier: collectVCellID)
        self.collectionView.register(SPProductAuctionCollectCell.self, forCellWithReuseIdentifier: collectHAuctionCellID)
        self.collectionView.register(SPIndexHeadHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeadHeaderID)
        self.collectionView.register(SPIndexCollectHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: collectionHeaderID)
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.collectionView)
         self.view.addSubview(self.noNetLabel)
        self.view.addSubview(self.nodataBtn)
        self.collectionView.sp_headerRefesh { [weak self]() in
            self?.currentPage = 1
            self?.sp_clickNoData()
        }
        self.collectionView.sp_footerRefresh { [weak self]() in
            if let page = self?.currentPage {
                if sp_getArrayCount(array: self?.defaultGood.dataArray) > 0 {
                     self?.currentPage = page + 1
                }else{
                    self?.currentPage = 1
                }
               
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
        self.noNetLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            self.noNetHeight = maker.height.equalTo(0).constraint
            maker.top.equalTo(self.titleView.snp.bottom)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.noNetLabel.snp.bottom).offset(0)
            maker.left.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
              maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
               maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.nodataBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(20)
            maker.right.equalTo(self.view).offset(-20)
            maker.centerY.equalTo(self.view).offset(0)
            maker.height.equalTo(40)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPIndexVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) , sp_getArrayCount(array: self.dataArray) > 0 {
            if let model : SPIndexGoods = self.dataArray?[section] {
                if sp_getString(string: model.type) != SP_HEADER {
                    return sp_getArrayCount(array: model.dataArray)
                }
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var indexModel : SPIndexGoods?
        
        if indexPath.section < sp_getArrayCount(array: self.dataArray), sp_getArrayCount(array: self.dataArray) > 0 {
            indexModel = self.dataArray?[indexPath.section]
        }
        if sp_getString(string: indexModel?.type) == SP_AUCTION {
            let cell : SPProductAuctionCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectHAuctionCellID, for: indexPath) as! SPProductAuctionCollectCell
            if indexPath.row < sp_getArrayCount(array: indexModel?.dataArray) , sp_getArrayCount(array: indexModel?.dataArray) > 0 {
                cell.auctionView.productModel = indexModel?.dataArray?[indexPath.row]
                cell.auctionView.productView.shopBlock = { [weak self](model) in
                    self?.sp_clickShop(model: model)
                }
            }
            return cell
           
        }else{
            let cell : SPProductListVCell = collectionView.dequeueReusableCell(withReuseIdentifier: collectVCellID, for: indexPath) as! SPProductListVCell
            
            if indexPath.row < sp_getArrayCount(array: indexModel?.dataArray) , sp_getArrayCount(array: indexModel?.dataArray) > 0 {
                cell.productView.productModel = indexModel?.dataArray?[indexPath.row]
                cell.productView.shopBlock = { [weak self](model) in
                    self?.sp_clickShop(model: model)
                }
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var indexModel : SPIndexGoods?
        
        if indexPath.section < sp_getArrayCount(array: self.dataArray), sp_getArrayCount(array: self.dataArray) > 0  {
            indexModel = self.dataArray?[indexPath.section]
        }
        if sp_getString(string: indexModel?.type) == SP_HEADER {
            let headerView : SPIndexHeadHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeadHeaderID, for: indexPath) as! SPIndexHeadHeaderView
            headerView.tableHeaderView.indexModel = self.indexModel
            headerView.tableHeaderView.iconView.selectblock = { [weak self](model) in
                self?.sp_dealIconSelect(model: model)
            }
            headerView.tableHeaderView.brandView.selectBlock = { [weak self](model) in
                self?.sp_dealBrandSelect(model: model)
                SPThridManager.sp_brand()
            }
            headerView.tableHeaderView.bannerView.selectBlock = { [weak self](row) in
                self?.sp_dealBannerSelect(row: row)
                SPThridManager.sp_banner()
            }
            return headerView
        }else {
            let headerView : SPIndexCollectHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: collectionHeaderID, for: indexPath) as! SPIndexCollectHeaderView
            headerView.titleLabel.text = sp_getString(string: indexModel?.name)
            headerView.moreBtn.isHidden = sp_getString(string: indexModel?.type) == SP_AUCTION ? false : true
            headerView.moreBtn.addTarget(self, action: #selector(sp_clickMore), for: UIControlEvents.touchUpInside)
            return headerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section < sp_getArrayCount(array: self.dataArray) , sp_getArrayCount(array: self.dataArray) > 0 {
            let indexModel : SPIndexGoods? = self.dataArray?[indexPath.section];
            if sp_getString(string: indexModel?.type) == SP_AUCTION {
                   return  CGSize(width: collectionView.frame.size.width, height: indexPath.row == 0 ? 175 + 10 : 175 + 5)
            }else{
                let width =  NSInteger((collectionView.frame.size.width - 25) / 2.0)
                return  CGSize(width: CGFloat(width), height:  (CGFloat(width) * SP_PRODUCT_SCALE ) + 115 )
            }
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section < sp_getArrayCount(array: self.dataArray), sp_getArrayCount(array: self.dataArray) > 0 {
            let indexModel : SPIndexGoods? = self.dataArray?[section];
            if sp_getString(string: indexModel?.type) == SP_HEADER {
                var height : CGFloat = collectionView.frame.size.width *  200.00/375.00
                if sp_getArrayCount(array: self.indexModel?.bannerList) == 0 {
                    height = 0.0
                }
                if sp_getArrayCount(array: self.indexModel?.iconList) > 0 {
                    height = height + 81.0
                }
                if sp_getArrayCount(array: self.indexModel?.brandList) > 0 {
                    height = height + 210.0
                }
                return CGSize(width: collectionView.frame.size.width, height: height)
            }else{
                return CGSize(width: collectionView.frame.size.width, height: 54)
            }
        }
        return CGSize(width: 0, height: 0)
    }
    // 返回cell 上下左右的间距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section < sp_getArrayCount(array: self.dataArray) , sp_getArrayCount(array: self.dataArray) > 0 {
            let indexModel : SPIndexGoods? = self.dataArray?[section];
            if sp_getString(string: indexModel?.type) == SP_AUCTION {
                  return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }else{
               
                return  UIEdgeInsets(top: 5, left:10, bottom: 0, right: 10)
            }
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section < sp_getArrayCount(array: self.dataArray),  sp_getArrayCount(array: self.dataArray) > 0  {
            let indexModel : SPIndexGoods? = self.dataArray?[section];
            if sp_getString(string: indexModel?.type) == SP_AUCTION {
                return 0
            }else{
                return 5
            }
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section < sp_getArrayCount(array: self.dataArray), sp_getArrayCount(array: self.dataArray) > 0 {
            let indexModel : SPIndexGoods? = self.dataArray?[section];
            if sp_getString(string: indexModel?.type) == SP_AUCTION {
                return 0
            }else{
                return 5
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section < sp_getArrayCount(array: self.dataArray), sp_getArrayCount(array: self.dataArray) > 0 {
            let indexGood = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: indexGood?.dataArray), sp_getArrayCount(array: indexGood?.dataArray) > 0{
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
    /*
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
    } */

  
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
        SPIndexHande.sp_deal(viewController: self, lineType: iconModel.linktype,linktarget: iconModel.linktarget, webparam: iconModel.webparam,name: "",webview: iconModel.webview)
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
            SPIndexHande.sp_deal(viewController: self, lineType: bannerModel.linktype,linktarget: bannerModel.linktarget, webparam:  bannerModel.webparam,name: "",webview: model?.webview)
            sp_dealPush(lineType: sp_getString(string: bannerModel.linktype))
        }
        
    }
    /// 点击店铺
    ///
    /// - Parameter model: 商品model
    fileprivate func sp_clickShop(model : SPProductModel?){
        guard let product = model else {
            return
        }
        let shopModel = SPShopModel()
        shopModel.shop_id = product.shop_id
        shopModel.shop_name = product.shop_name 
        let shopVC = SPShopHomeVC()
        shopVC.shopModel = shopModel
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
    /// 处理没有数据时按钮显示
    fileprivate func sp_dealNoDataBtn(){
        if sp_getArrayCount(array: self.indexModel?.brandList) == 0 , sp_getArrayCount(array: self.indexModel?.bannerList) == 0 , sp_getArrayCount(array: self.indexModel?.iconList) == 0 , sp_getArrayCount(array: self.auctionGood.dataArray) == 0 , sp_getArrayCount(array: self.defaultGood.dataArray) == 0{
            self.nodataBtn.isHidden = false
        }else{
            self.nodataBtn.isHidden = true
        }
    }
    /// 点击没有数据
    @objc fileprivate func sp_clickNoData(){
        self.currentPage = 1
        self.sp_sendRequest()
        self.sp_sendGoodRequest()
        sp_sendMsgCountRequest()
    }
    /// 点击竞拍更多
    @objc fileprivate func sp_clickMore(){
        NotificationCenter.default.post(name: NSNotification.Name(SP_CHANGETABBAR_NOTIIFICATION), object: ["index":"\(SP_ISSHOW_AUCTION ? SP_TAB_AUCTION : SP_TAB_SORT)"])
    }
    /// 点击网络失败
    @objc fileprivate func sp_clickNetFailure(){
        let failureVC = SPNetWorkFailureVC()
        self.navigationController?.pushViewController(failureVC, animated: true)
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
        NotificationCenter.default.addObserver(self, selector: #selector(sp_netChange), name: NSNotification.Name(SP_NETWORK_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_loginout), name: NSNotification.Name(SP_LOGOUT_NOTIFICATION), object: nil)
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
//            sp_simpleSQueues {
                if sp_getArrayCount(array: self.auctionGood.dataArray) > 0 {
                    var list = [SPProductModel]()
                    for model in self.auctionGood.dataArray! {
                        model.sp_set(second: second)
                        if model.second > 0 {
                            list.append(model)
                        }
                    }
                    self.auctionGood.dataArray = list
//                    if self.isScroll == false {
                        sp_dealDataArray(all: false)
//                    }
                }
//            }
        }
    }
    @objc fileprivate func sp_editPrice(){
        self.isEditPrice = true
    }
    @objc fileprivate func sp_netChange(){
        if SPNetWorkManager.sp_notReachable() {
            // 没有网络
            self.noNetHeight.update(offset: 40)
            if SPNetWorkManager.sp_isOpenWwan() == false {
                
            }
            sp_log(message: "移动网络是否打开\(SPNetWorkManager.sp_isOpenWwan())")
        }else{
            // 有网络
            self.noNetHeight.update(offset: 0)
            if sp_getArrayCount(array: self.defaultGood.dataArray) <= 0 {
                self.currentPage = 1
                self.sp_clickNoData()
            }
        }
    }
    /// 退出登录通知
    @objc fileprivate func sp_loginout(){
        sp_dealMsgCount(count: "")
    }
}
extension SPIndexVC{
    
    fileprivate func sp_sendRequest(){
        if self.indexRequestModel.isRequest  {
            return
        }
        var parm = [String:Any]()
        parm.updateValue("index", forKey: "tmpl")
        self.indexRequestModel.parm = parm
        SPAppRequest.sp_getIndex(requestModel: self.indexRequestModel) { [weak self](code, indexModel, errorModel) in
            
            if code  == SP_Request_Code_Success {
                self?.indexModel = indexModel
                self?.tableHeaderView.indexModel = indexModel
            }
            sp_hideAnimation(view: self?.view)
            self?.sp_dealDataArray()
            self?.sp_dealNoDataBtn()
            
        }
    }
    fileprivate func sp_sendGoodRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "pagesize")
        parm.updateValue("index", forKey: "tmpl")
        self.requestModel.parm = parm
        SPAppRequest.sp_getIndexGoods(requestModel: self.requestModel) { [weak self](code,auctionList,list, errorModel, total) in
            
            self?.sp_dealRequest(code: code,auctionList: auctionList, list: list, errorModel: errorModel, total: total)
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
        self.sp_dealNoDataBtn()
        sp_mainQueue {
            self.collectionView.sp_stopHeaderRefesh()
            self.collectionView.sp_stopFooterRefesh()
        }
      
    }
    fileprivate func sp_dealDataArray(all : Bool = true){
        var list = [SPIndexGoods]()
        
        list.append(self.headerModel)
        
        if sp_getArrayCount(array: self.auctionGood.dataArray) > 0 {
            list.append(self.auctionGood)
        }
        if sp_getArrayCount(array: self.defaultGood.dataArray) > 0 {
            list.append(self.defaultGood)
        }
        sp_mainQueue {
            self.dataArray = list
            if all {
                  self.collectionView.reloadData()
            }else {
                if sp_getArrayCount(array: self.auctionGood.dataArray) > 0 {
                    UIView.performWithoutAnimation {
                        self.collectionView.reloadSections([1])
                    }
                }else{
                    self.collectionView.reloadData()
                }
            }

            
        }
    }
    /// 发送获取消息数量请求
    fileprivate func sp_sendMsgCountRequest(){
        if SPAPPManager.sp_isLogin(isPush: false) {
            if self.msgRequestModel.isRequest {
                return
            }
            let parm = [String : Any]()
            self.msgRequestModel.parm = parm
            SPAppRequest.sp_getMsgCount(requestModel: self.msgRequestModel) { [weak self](code, msg, errorModel) in
                if code == SP_Request_Code_Success{
                    self?.sp_dealMsgCount(count: msg)
                }
            }
        }else{
            sp_dealMsgCount(count: "")
        }
    }
    
    fileprivate func sp_dealMsgCount(count : String){
        if sp_getString(string: count).count > 0  {
            if let num = Int(sp_getString(string: count)){
                if num > 99 {
                    self.titleView.countLabel.text = "99+"
                }else{
                    self.titleView.countLabel.text = sp_getString(string: count)
                }
                self.titleView.countLabel.isHidden = false
                return
            }
        }
        self.titleView.countLabel.isHidden = true
        
        
    }
    
}
