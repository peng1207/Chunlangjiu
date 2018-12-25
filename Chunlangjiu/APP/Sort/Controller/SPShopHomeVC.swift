//
//  SPShopHomeVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPShopHomeVC: SPBaseVC {
    
    fileprivate lazy var shopHomeView : SPShopHomeView = {
        let view = SPShopHomeView()
        view.backgroundColor = UIColor.white
        view.shopModel = shopModel
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_clickShopDetVC))
        view.addGestureRecognizer(tap)
        return view
    }()
    fileprivate lazy var listBtn  : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_list"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_abreast"), for: UIControlState.selected)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: #selector(clickListAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var searchView : SPSearchView = {
        var view = SPSearchView(frame:  CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 120, height: 30))
        view.searchBlock = { [weak self](text) in
            self?.sp_dealSearch(text: text)
        }
        return view
    }()
  
    fileprivate var collectionView : UICollectionView!
    fileprivate var dataArray : [SPProductModel]?
    fileprivate var shopCollectionCellID = "shopCollectionCellID"
    fileprivate var currentPage : Int = 1
    var shopModel : SPShopModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_sendRequest()
        self.sp_sendProductRequest()
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
    override func sp_dealNoData() {
        self.collectionView.sp_stopFooterRefesh()
        self.collectionView.sp_stopHeaderRefesh()
        if sp_getArrayCount(array: self.dataArray) > 0  {
            self.noData.isHidden = true
        }else{
            self.noData.isHidden = false
            self.noData.text = "没有找到相关的商品哦"
        }
    }
    /// 创建UI
    override func sp_setupUI() {
        self.navigationItem.title = "店铺首页"
        self.view.addSubview(self.shopHomeView)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = self.view.backgroundColor
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.register(SPShopProductCollectCell.self, forCellWithReuseIdentifier: shopCollectionCellID)
        self.collectionView.showsVerticalScrollIndicator = false 
        self.view.addSubview(self.collectionView)
        self.collectionView.sp_headerRefesh {[weak self] in
            self?.currentPage = 1
            self?.sp_sendProductRequest()
        }
        self.collectionView.sp_footerRefresh { [weak self] in
            if let page = self?.currentPage {
                if sp_getArrayCount(array: self?.dataArray) > 0 {
                     self?.currentPage = page + 1
                }else{
                     self?.currentPage = 1
                }
            }
            self?.sp_sendProductRequest()
        }
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.shopHomeView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(5)
            maker.top.equalTo(self.view).offset(5)
            maker.right.equalTo(self.view).offset(-5)
            maker.height.equalTo(100)
        }
        self.collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(0)
            maker.right.equalTo(self.view).offset(0)
            maker.top.equalTo(self.shopHomeView.snp.bottom).offset(0)
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
extension SPShopHomeVC : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : SPShopProductCollectCell = collectionView.dequeueReusableCell(withReuseIdentifier: shopCollectionCellID, for: indexPath) as! SPShopProductCollectCell
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell.productView.productModel = self.dataArray?[indexPath.row]
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width =  NSInteger((collectionView.frame.size.width - 25) / 2.0)
        return  CGSize(width: CGFloat(width), height:  (CGFloat(width) * SP_PRODUCT_SCALE ) + 95 )
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let detVC = SPProductDetaileVC()
            detVC.productModel =  self.dataArray?[indexPath.row]
            self.navigationController?.pushViewController(detVC, animated: true)
        }
    }
}
// MARK: - action
extension SPShopHomeVC {
    @objc fileprivate func clickListAction(){
        self.listBtn.isSelected = !self.listBtn.isSelected
        
    }
    /// 处理点击搜索
    ///
    /// - Parameter text: 搜索数据
    fileprivate func sp_dealSearch(text:String?){
        if sp_getString(string: text).count > 0 {
            
        }else{
            sp_showTextAlert(tips: "请输入关键字")
        }
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.shopHomeView.shopModel = self.shopModel
    }
    @objc fileprivate func sp_clickShopDetVC(){
        let detVC = SPShopDetVC()
        detVC.shopModel = self.shopModel
        self.navigationController?.pushViewController(detVC, animated: true)
    }
}
extension SPShopHomeVC {
    fileprivate func sp_sendRequest(){
        var parm = [String:Any]()
        parm.updateValue(self.shopModel?.shop_id ?? 0, forKey: "shop_id")
        self.requestModel.parm = parm
        SPAppRequest.sp_getShop(requestModel: self.requestModel) {  [weak self](code , model, errorModel) in
            if code  == SP_Request_Code_Success {
                self?.shopModel = model
                self?.sp_setupData()
            }
        }
    }
    fileprivate func sp_sendProductRequest(){
        var parm = [String : Any]()
        if let shop = self.shopModel {
            parm.updateValue(shop.shop_id ?? "", forKey: "shop_id")
        }
        
        parm.updateValue(self.currentPage, forKey: "page_no")
        parm.updateValue(10, forKey: "page_size")
        
//        if let price = self.conditionView.selectprice {
//            if sp_getString(string: price.maxPrice).count > 0 {
//                parm.updateValue(sp_getString(string: price.maxPrice), forKey: "max_price")
//            }
//            if sp_getString(string: price.minPrice).count > 0 {
//                parm.updateValue(sp_getString(string: price.minPrice), forKey: "min_price")
//            }
//        }
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
    
}
