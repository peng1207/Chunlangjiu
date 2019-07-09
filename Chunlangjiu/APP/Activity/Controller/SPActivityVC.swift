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
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        btn.setImage(UIImage(named: "public_leftBack"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isHidden = true
        return view
    }()
    fileprivate lazy var backgroundImgView : UIImageView = {
        let view = UIImageView()
        return view
    }()
 
     fileprivate var pushVC : Bool = false
    var activity_id : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_showAnimation(view: self.view, title: nil)
        self.sp_sendRequest()
        self.sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.sp_backColor(color: UIColor.white)
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : sp_getFontSize(size: 18),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.pushVC = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font : sp_getFontSize(size: 18),NSAttributedStringKey.foregroundColor : SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)]
        self.navigationController?.navigationBar.sp_reset()
        UIApplication.shared.statusBarStyle = .lightContent
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 赋值
    fileprivate func sp_setupData(){
        self.navigationItem.title = sp_getString(string: self.activityModel?.title)
        if sp_getString(string: self.navigationItem.title).count == 0 {
            self.navigationItem.title = "活动"
        }
        if sp_getString(string: self.activityModel?.color).count > 0  {
            self.view.backgroundColor =  SPColorForHexString(hex: sp_getString(string: self.activityModel?.color))
            self.tableView.backgroundColor = self.view.backgroundColor
        }
        self.headerView.imgView.sp_cache(string: sp_getString(string: self.activityModel?.top_img), plImage: nil) { [weak self](image) in
            if let i = image {
                let scale = i.size.height / i.size.width
                self?.headerView.frame = CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getScreenWidth() * scale)
                self?.tableView.tableHeaderView = self?.headerView
            }
        }
        var top : CGFloat = 0.0
        if  sp_getArrayCount(array: self.activityModel?.item) > 0 || (SP_ISSHOW_AUCTION && sp_getArrayCount(array: self.activityModel?.auction) > 0 ){
            top = 41.0
        }
        if sp_getString(string: self.activityModel?.bottom_img).count > 0 {
           
            self.footerView.imgView.sp_cache(string:  sp_getString(string: self.activityModel?.bottom_img), plImage: nil) { [weak self](image) in
                if let i = image {
                    let scale = i.size.height / i.size.width
                    self?.footerView.frame =  CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height:  sp_getScreenWidth() * scale + top)
                   
                }else{
                    self?.footerView.frame =  CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height:top)
                }
                self?.footerView.sp_updateTop(top: top)
                self?.tableView.tableFooterView = self?.footerView
            }
        }else{
            self.footerView.frame =  CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height:top)
            self.footerView.sp_updateTop(top: top)
            self.tableView.tableFooterView = self.footerView
        }
        
       sp_dealData()
        
    }
    fileprivate func sp_dealData(all : Bool = true){
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
        if all {
             self.tableView.reloadData()
        }else{
            if sp_getArrayCount(array: self.dataArray) > 0 {
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections([0], with: UITableViewRowAnimation.none)
                }
            }else{
                self.tableView.reloadData()
            }
        }
       
        self.sp_dealNoData()
    }
    /// 创建UI
    override func sp_setupUI() {
        
        
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
 
        self.tableView.tableHeaderView = self.headerView
        self.tableView.tableFooterView = self.footerView
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.backgroundImgView)
        self.view.addSubview(self.tableView)
 
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)

        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if self.activityModel == nil{
            self.noData.isHidden = false
            self.noData.text = "暂时没有活动哦!"
            self.view.bringSubview(toFront: self.noData)
            self.tableView.isHidden = true
        }else{
            if sp_getString(string: self.activityModel?.open).count > 0 ,let isOpen = Bool(sp_getString(string: self.activityModel?.open)), isOpen == false{
                self.noData.isHidden = false
                self.noData.text = "暂时没有活动哦!"
                self.view.bringSubview(toFront: self.noData)
                self.tableView.isHidden = true
            }else{
                self.noData.isHidden = true
                self.tableView.isHidden = false
            }
           
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
 
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.backgroundImgView.snp.makeConstraints { (maker) in
            maker.left.top.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
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
        if section < sp_getArrayCount(array: self.dataArray) ,sp_getArrayCount(array: self.dataArray) > 0  {
            let model = self.dataArray?[section]
            return sp_getArrayCount(array: model?.dataArray)
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model : SPActivityHeaderModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray),sp_getArrayCount(array: self.dataArray) > 0 {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray),sp_getArrayCount(array: model?.dataArray) > 0{
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
        if indexPath.section < sp_getArrayCount(array: self.dataArray) ,sp_getArrayCount(array: self.dataArray) > 0 {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray),sp_getArrayCount(array: model?.dataArray) > 0 {
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
        if section < sp_getArrayCount(array: self.dataArray) , sp_getArrayCount(array: self.dataArray) > 0 {
            let model = self.dataArray?[section]
            headerView?.titleLabel.text = sp_getString(string:model?.title)
//            headerView?.textLabel?.textColor =  SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
            if sp_getString(string: self.activityModel?.color).count > 0  {
                headerView?.contentView.backgroundColor = SPColorForHexString(hex: sp_getString(string: self.activityModel?.color))
                if sp_getString(string: self.activityModel?.color) == "#ffffff"{
                    headerView?.titleLabel.textColor = SPColorForHexString(hex: SP_HexColor.color_333333.rawValue)
                }
            }
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return  nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var model : SPActivityHeaderModel?
        var productModel : SPProductModel?
        if indexPath.section < sp_getArrayCount(array: self.dataArray) , sp_getArrayCount(array: self.dataArray) > 0 {
            model = self.dataArray?[indexPath.section]
            if indexPath.row < sp_getArrayCount(array: model?.dataArray) , sp_getArrayCount(array: model?.dataArray) > 0 {
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
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.activity_id), forKey: "id")
        self.requestModel.parm = parm
        
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
//            sp_simpleSQueues {
                var list = [SPProductModel]()
                for model in (self.activityModel?.auction)! {
                    model.sp_set(second: second)
                    if model.second > 0 {
                        list.append(model)
                    }
                }
                self.activityModel?.auction = list
//                sp_mainQueue {
                   self.sp_dealData(all: false)
//                }
//            }
        }
        
        
    }
}
