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
        view.backgroundColor = UIColor.white
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
        return view
    }()
    lazy var auctionInfoView : SPAuctionInfoView = {
        let view = SPAuctionInfoView()
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        view.isHidden = true
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
  
        btn.titleLabel?.font = sp_getFontSize(size: 15)
        btn.addTarget(self, action: #selector(sp_clickOther), for: UIControlEvents.touchUpInside)
        return btn
    }()
     fileprivate var tipsTop : Constraint!
    fileprivate var auctionInfoTop : Constraint!
    fileprivate var auctionInfoHeight : Constraint!
    fileprivate var priceTop : Constraint!
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
        self.navigationItem.title = "详情"
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
            maker.height.greaterThanOrEqualTo(0)
            self.priceTop = maker.top.equalTo(self.tipsView.snp.bottom).offset(0).constraint
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
            maker.top.equalTo(self.auctionInfoView.snp.bottom).offset(0)
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
            self.auctionInfoTop.update(offset: 10)
             self.auctionInfoHeight.update(offset: 140.0 + sp_lineHeight)
          
            var isMing = false
            let auction_status : Bool? = Bool(sp_getString(string: self.productModel?.auction_status))
            if let status = auction_status , status == true {
                isMing = true
            }
            if isMing {
                  self.priceView.isHidden = false
                self.priceTop.update(offset: 5)
            }else{
                 self.priceTop.update(offset: 0)
                  self.priceView.isHidden = true
            }
            
            
        }else{
            self.auctionInfoView.isHidden = true
            self.auctionInfoTop.update(offset: 0)
            self.auctionInfoHeight.update(offset:0)
            self.priceView.isHidden = true
            self.priceTop.update(offset: 0)
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
}
extension SPShopProductDetVC {
    fileprivate func sp_sendRequest(){
        var parm  = [String : Any]()
        if  let i_id = item_id {
            parm.updateValue(i_id, forKey: "item_id")
        }
        self.requestModel.parm = parm
        SPProductRequest.sp_getProductDet(requestModel: self.requestModel) { [weak self](code, model, errorModel) in
            if code == SP_Request_Code_Success {
                self?.productModel = model
                self?.sp_setupData()
            }
        }
        
    }
    
}
