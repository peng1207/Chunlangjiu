//
//  SPActivityVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/12/6.
//  Copyright © 2018 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPActivityVC: SPBaseVC {
    
    fileprivate var tableView : UITableView!
    fileprivate var dataArray : [SPActivityHeaderModel]?
    fileprivate var activityModel : SPActivityModel?
    fileprivate lazy var headerView : SPActivityHeaderView = {
        let view = SPActivityHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.835)
        return view
    }()
    fileprivate lazy var footerView : SPActivityFooterView = {
        let view = SPActivityFooterView()
        view.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.533 + 41.0)
        return view
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_back_wither"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
     fileprivate var pushVC : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
        self.sp_sendRequest()
        self.sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: self.pushVC ? true : false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.pushVC = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        var dataArray = [SPActivityHeaderModel]()
        if SP_ISSHOW_AUCTION {
            if sp_getArrayCount(array: self.activityModel?.auction) > 0 {
                let auctionModel = SPActivityHeaderModel.sp_init(type: SP_AUCTION)
                auctionModel.dataArray = self.activityModel?.auction
                dataArray.append(auctionModel)
            }
          
        }
        if sp_getArrayCount(array: self.activityModel?.item) > 0  {
            let goodModel = SPActivityHeaderModel.sp_init(type: "")
            goodModel.dataArray = self.activityModel?.item
            dataArray.append(goodModel)
        }
        
        self.dataArray = dataArray
        self.headerView.imgView.sp_cache(string: sp_getString(string: self.activityModel?.top_img), plImage: sp_getDefaultImg())
        self.footerView.imgView.sp_cache(string: sp_getString(string: self.activityModel?.bottom_img), plImage: sp_getDefaultImg())
        if sp_getString(string: self.activityModel?.color).count > 0  {
            self.view.backgroundColor = SPColorForHexString(hex: sp_getString(string: self.activityModel?.color))
             self.tableView.backgroundColor = self.view.backgroundColor
        }
        self.tableView.reloadData()
        self.headerView.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.835)
        var top : CGFloat = 0.0
        if sp_getArrayCount(array: self.activityModel?.list) > 0 {
            top = 41.0
        }
        self.footerView.frame =  CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * 0.533 + top)
        self.footerView.sp_updateTop(top: top)
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        
        self.sp_dealNoData()
    }
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
       
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.backBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if self.activityModel == nil {
            self.noData.isHidden = false
            self.noData.text = "暂时没有活动哦!"
            self.view.bringSubview(toFront: self.noData)
            self.tableView.isHidden = true
        }else{
            self.noData.isHidden = true
            self.tableView.isHidden = false
        }
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
        self.backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view.snp.top).offset(sp_getstatusBarHeight()  + 2)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPActivityVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[section]
            return sp_getArrayCount(array: model?.dataArray)
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model : SPActivityHeaderModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray){
                productModel = model?.dataArray?[indexPath.row]
            }
        }
        if let p = productModel, p.isAuction {
            let activityAuctionCellID = "activityAuctionCellID"
            var cell : SPAuctionTableCell? = tableView.dequeueReusableCell(withIdentifier: activityAuctionCellID) as? SPAuctionTableCell
            if cell == nil {
                cell = SPAuctionTableCell(style: UITableViewCellStyle.default, reuseIdentifier: activityAuctionCellID)
            }
            cell?.auctionView.productModel = p
            cell?.auctionView.productView.shopBlock = { [weak self](model) in
                self?.sp_clickShop(model: model)
            }
            return cell!
        }else{
            let activityCellID = "activityCellID"
            var cell : SPProductTableCell? = tableView.dequeueReusableCell(withIdentifier: activityCellID) as? SPProductTableCell
            if cell == nil {
                cell = SPProductTableCell(style: UITableViewCellStyle.default, reuseIdentifier: activityCellID)
            }
            cell?.productView.productModel = productModel
            cell?.productView.shopBlock = {  [weak self](model) in
                self?.sp_clickShop(model: model)
            }
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var model : SPActivityHeaderModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray){
                productModel = model?.dataArray?[indexPath.row]
            }
        }
        if let p = productModel, p.isAuction {
            return indexPath.row == 0 ? 175 : 180
        }else{
            return indexPath.row == 0 ? 150 : 155
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let activitySectionHeaderID = "activitySectionHeaderID"
        var headerView : SPActivitySectionView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: activitySectionHeaderID) as? SPActivitySectionView
        if headerView == nil {
            headerView = SPActivitySectionView(reuseIdentifier: activitySectionHeaderID)
        }
        if section < sp_getArrayCount(array: self.dataArray) {
            let model = self.dataArray?[section]
            headerView?.titleLabel.text = sp_getString(string:model?.title)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model : SPActivityHeaderModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray){
                productModel = model?.dataArray?[indexPath.row]
            }
        }
        if let p = productModel {
            let detVC = SPProductDetaileVC()
            detVC.productModel = p
            self.navigationController?.pushViewController(detVC, animated: true)
            self.pushVC = true
        }
        
    }
    
}
extension SPActivityVC {
    
    fileprivate func sp_sendRequest(){
        
        SPAppRequest.sp_getActivityList(requestModel: self.requestModel) { [weak self](code, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            self?.activityModel = model
            self?.sp_setupData()
        }
        
    }
    
}
extension SPActivityVC {
    
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
    
}
extension SPActivityVC {
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_timeRun(notification:)), name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_timeRun(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
        if sp_getArrayCount(array: self.activityModel?.auction) > 0  {
            sp_simpleSQueues {
                var list = [SPProductModel]()
                for model in (self.activityModel?.auction)! {
                    model.sp_set(second: second)
                    if model.second > 0 {
                        list.append(model)
                    }
                }
                self.activityModel?.auction = list
                self.sp_setupData()
            }
        }
        
        
    }
}
