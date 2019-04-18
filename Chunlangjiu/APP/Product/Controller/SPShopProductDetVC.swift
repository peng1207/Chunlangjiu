//
//  SPShopProductDet.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPShopProductDetVC: SPBaseVC {
    
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isHidden = true
        return view
    }()
    
    lazy var bannerView : SPBannerView =  {
        let view  = SPBannerView()
        view.pageControl.currentColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        view.pageControl.otherColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue).withAlphaComponent(0.7)
        view.numBlock = { [weak self](second : Int) -> Int in
            return sp_getArrayCount(array: self?.productModel?.images)
        }
        view.cellBlock = { [weak self](imageView : UIImageView,row :Int) in
            self?.sp_dealCellData(imageView: imageView, row: row)
        }
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var productView : SPProductView = {
        let view = SPProductView()
        view.isShop = true
        view.backgroundColor = UIColor.white
        view.lookDetaile.addTarget(self, action: #selector(sp_pushLookAuction), for: UIControlEvents.touchUpInside)
        return view
    }()
    lazy var tipsView : SPProductTipsView = {
        let view  = SPProductTipsView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    lazy var detView : SPDetView = {
        let view = SPDetView()
        view.isHidden = true
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var priceView : SPShopProductAuctionPriceView = {
        let view = SPShopProductAuctionPriceView()
        view.backgroundColor = UIColor.white
        view.clickBlock = { [weak self]in
            self?.sp_pushLookAuction()
        }
        return view
        
    }()
    lazy var auctionInfoView : SPAuctionInfoView = {
        let view = SPAuctionInfoView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.isHidden = true
        view.clickBlock = { [weak self] in
            self?.sp_pushMoreAuctionInfo()
        }
        return view
    }()
    lazy var serviceView : SPProductServiceView = {
        let view = SPProductServiceView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        return view
    }()
    fileprivate lazy var otherBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("去看其他竞拍商品 >>", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), for: UIControlState.normal)
        btn.isHidden = true
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickOther), for: UIControlEvents.touchUpInside)
        return btn
    }()
     fileprivate var tipsTop : Constraint!
    fileprivate var auctionInfoTop : Constraint!
    fileprivate var auctionInfoHeight : Constraint!
    fileprivate var productModel : SPProductModel?
    var item_id : Int?
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
        self.navigationItem.title = "商品详情"
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.bannerView)
        self.scrollView.addSubview(self.productView)
        self.scrollView.addSubview(self.tipsView)
        self.scrollView.addSubview(self.priceView)
        self.scrollView.addSubview(self.detView)
        self.scrollView.addSubview(self.auctionInfoView)
        self.scrollView.addSubview(self.serviceView)
        self.scrollView.addSubview(self.otherBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.bannerView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(self.bannerView.snp.width).offset(0)
            maker.centerX.equalTo(self.scrollView).offset(0)
        }
        self.productView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.bannerView.snp.bottom).offset(0)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.tipsView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.greaterThanOrEqualTo(0)
            self.tipsTop = maker.top.equalTo(self.productView.snp.bottom).offset(0).constraint
        }
        
        self.priceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.height.equalTo(0)
            maker.top.equalTo(self.tipsView.snp.bottom).offset(0)
        }
        self.detView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.priceView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.auctionInfoView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            self.auctionInfoTop = maker.top.equalTo(self.detView.snp.bottom).offset(0).constraint
            self.auctionInfoHeight = maker.height.equalTo(0).constraint
        }
        self.serviceView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.top.equalTo(self.auctionInfoView.snp.bottom).offset(10)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.otherBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(self.serviceView.snp.bottom).offset(0)
            maker.height.equalTo(76)
            maker.left.right.equalTo(self.scrollView).offset(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(0)
        }
    }
    deinit {
        sp_removeTimeNotification()
        NotificationCenter.default.removeObserver(self)
    }
}
extension SPShopProductDetVC {
    fileprivate func sp_setupData(){
        self.bannerView.isAutoPaly = true
        self.bannerView.sp_reloadData()
        self.productView.productModel = self.productModel
        self.tipsView.content = sp_getString(string: self.productModel?.explain)
        self.detView.productModel = self.productModel
        self.detView.isHidden = false
        self.serviceView.imgUrl = sp_getString(string: self.productModel?.service_url)
        if sp_getString(string: self.productModel?.explain).count > 0 {
            self.tipsTop.update(offset: 0)
            self.tipsView.isHidden = false
        }else{
            self.tipsTop.update(offset: 0)
            self.tipsView.isHidden = true
        }
        if let isAuction = self.productModel?.isAuction,isAuction == true {
            self.auctionInfoView.isHidden = false
             self.otherBtn.isHidden = false
            self.auctionInfoTop.update(offset: 10)
            self.auctionInfoHeight.update(offset: 140.0 + sp_lineHeight)
            var isMing = false
            let auction_status : Bool? = Bool(sp_getString(string: self.productModel?.auction_status))
            if let status = auction_status , status == true {
                isMing = true
            }
            if isMing {
                self.priceView.isHidden = false
                sp_updateAuctionPrice(isShow: true)
            }else{
                self.priceView.isHidden = true
                sp_updateAuctionPrice(isShow: false)
            }
           
        }else{
            self.auctionInfoView.isHidden = true
            self.otherBtn.isHidden = true
            self.auctionInfoTop.update(offset: 0)
            self.auctionInfoHeight.update(offset:0)
            self.priceView.isHidden = true
             sp_updateAuctionPrice(isShow: false)
        }
    }
    fileprivate func sp_updateAuctionPrice(isShow:Bool){
        self.priceView.snp.remakeConstraints { (maker) in
            maker.left.right.equalTo(self.scrollView).offset(0)
            if isShow {
                  maker.height.greaterThanOrEqualTo(0)
                maker.top.equalTo(self.tipsView.snp.bottom).offset(5)
            }else{
                maker.top.equalTo(self.tipsView.snp.bottom).offset(0)
                maker.height.equalTo(0)
            }

        }
    }
    /// 处理图片轮播的数据
    ///
    /// - Parameters:
    ///   - imageView: 显示图片
    ///   - row: 第几个
    fileprivate func sp_dealCellData(imageView : UIImageView ,row : Int) {
        if row >= 0 ,row < sp_getArrayCount(array: self.productModel?.images) {
            let url = self.productModel?.images![row]
            imageView.sp_cache(string: url, plImage: sp_getDefaultImg())
        }
    }
    @objc fileprivate func sp_clickOther(){
        var auctionVC : SPProductAuctionVC?
        if sp_getArrayCount(array: self.navigationController?.viewControllers) > 0 {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: SPProductAuctionVC.classForCoder()){
                    auctionVC = vc as? SPProductAuctionVC
                    break
                }
            }
        }
        if let aVC = auctionVC {
            self.navigationController?.popToViewController(aVC, animated: true)
        }else{
            auctionVC = SPProductAuctionVC()
            self.navigationController?.pushViewController(auctionVC!, animated: true)
        }
    }
    /// 跳到查看出价列表
   @objc fileprivate func sp_pushLookAuction(){
        let vc = SPLookAuctionVC()
        vc.auctionitem_id = self.productModel?.auctionitem_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_pushMoreAuctionInfo(){
        let auctionInfoVC = SPAuctionInfoVC()
        self.navigationController?.pushViewController(auctionInfoVC, animated: true)
    }
}
extension SPShopProductDetVC {
    fileprivate func sp_sendRequest(){
        var parm  = [String : Any]()
        if  let i_id = item_id {
            parm.updateValue(i_id, forKey: "item_id")
        }
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPProductRequest.sp_getProductDet(requestModel: self.requestModel) { [weak self](code, model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.scrollView.isHidden = false
                self?.productModel = model
                self?.sp_setupData()
                self?.sp_sendAuctionPriceRequest()
                self?.sp_AddTimeNotification()
            }
        }
    }
    fileprivate func sp_sendAuctionPriceRequest(){
        var isMing = false
        let auction_status : Bool? = Bool(sp_getString(string: self.productModel?.auction_status))
        if let status = auction_status , status == true {
            isMing = true
        }
   
        if  let isAuction = self.productModel?.isAuction,isAuction == true, isMing{
            let request = SPRequestModel()
            var parm = [String : Any]()
            parm.updateValue(sp_getString(string: self.productModel?.auctionitem_id), forKey: "auctionitem_id")
            
            request.parm = parm
            
            SPAppRequest.sp_getAuctionPriceList(requestModel: request) { [weak self](code , list, errorModel, total) in
                
                if code == SP_Request_Code_Success {
                    self?.priceView.sp_update(list: list as? [SPAuctionPrice], total: total)
                }else{
                    
                }
            }
        }
        
       
    }
    
}
extension SPShopProductDetVC{
    
    /// 添加计时器的通知
    fileprivate func sp_AddTimeNotification(){
        if  let isAuction = self.productModel?.isAuction,isAuction == true{
            NotificationCenter.default.addObserver(self, selector: #selector(sp_timeRun(notification:)), name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
            
        }else{
            sp_removeTimeNotification()
        }
    }
    /// 移除计时器的通知
    fileprivate func sp_removeTimeNotification(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_timeRun(notification:Notification){
        var second = 1
        if notification.object is [String : Any] {
            let dic : [String : Any] = notification.object as! [String : Any]
            second = dic["timer"] as! Int
        }
        if self.productModel != nil{
            self.productModel?.sp_set(second: second)
            self.productView.productModel = self.productModel
        }
    }
}
