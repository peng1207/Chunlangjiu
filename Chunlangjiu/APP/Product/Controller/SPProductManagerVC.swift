//
//  SPProductManagerVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/3/3.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductManagerVC: SPBaseVC {
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    fileprivate lazy var headerImgView : UIImageView = {
        let view = UIImageView()
        view.image =   SPBundle.sp_img(name: "public_product_header")
        return view
    }()
    fileprivate lazy var iconImgView : UIImageView = {
        let view = UIImageView()
        view.sp_cornerRadius(cornerRadius: 42)
        return view
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_back"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var shopNameLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 16)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_000000.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    fileprivate lazy var contentView : SPProductManagerContentView = {
        let view = SPProductManagerContentView()
        view.backgroundColor = UIColor.white
        view.sp_cornerRadius(cornerRadius: 10)
        view.clickBlock = { [weak self] (type)in
            self?.sp_dealClickComplete(tyep: type)
        }
        return view
    }()
    fileprivate lazy var addBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("+", for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.titleLabel?.font = sp_getFontSize(size: 36)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue), for: UIControlState.normal)
        btn.sp_cornerRadius(cornerRadius: 30)
        btn.addTarget(self, action: #selector(sp_clickAdd), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var tipsLabel : UILabel = {
        let label = UILabel()
        label.font = sp_getFontSize(size: 12)
        label.textColor = SPColorForHexString(hex: SP_HexColor.color_999999.rawValue)
        label.textAlignment = .center
        label.text = "快去发布商品吧！"
        return label
    }()
    fileprivate var countModel : SPMineCountModel?
    fileprivate var shopModel : SPShopModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        sp_sendShopRequest()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_sendCountRequest()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerImgView)
        self.scrollView.addSubview(self.backBtn)
        self.scrollView.addSubview(self.iconImgView)
        self.scrollView.addSubview(self.shopNameLabel)
        self.scrollView.addSubview(self.contentView)
        self.scrollView.addSubview(self.addBtn)
        self.scrollView.addSubview(self.tipsLabel)
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
        self.headerImgView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(self.scrollView).offset(0)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.height.equalTo(self.headerImgView.snp.width).multipliedBy(0.61)
        }
        self.backBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.left.equalTo(10)
            maker.top.equalTo(self.scrollView.snp.top).offset(sp_getstatusBarHeight() + 6)
        }
        self.iconImgView.snp.makeConstraints { (maker) in
            maker.width.equalTo(84)
            maker.height.equalTo(84)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
            maker.top.equalTo(self.headerImgView.snp.bottom).offset(-50)
        }
        self.shopNameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.iconImgView.snp.bottom).offset(12)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.contentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView.snp.left).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.shopNameLabel.snp.bottom).offset(20)
            maker.height.greaterThanOrEqualTo(0)
        }
        self.addBtn.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(60)
            maker.top.equalTo(self.contentView.snp.bottom).offset(41)
            maker.centerX.equalTo(self.scrollView.snp.centerX).offset(0)
        }
        self.tipsLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.scrollView).offset(10)
            maker.right.equalTo(self.scrollView.snp.right).offset(-10)
            maker.top.equalTo(self.addBtn.snp.bottom).offset(31)
            maker.height.greaterThanOrEqualTo(0)
            maker.bottom.equalTo(self.scrollView.snp.bottom).offset(-58)
        }
    }
    deinit {
        
    }
}
extension SPProductManagerVC {
    
    fileprivate func sp_dealClickComplete(tyep : Int){
        switch tyep {
        case SPMineType.saleProduct.rawValue:
            sp_clickSale()
        case SPMineType.warehouseProduct.rawValue:
            sp_clickWarehouse()
        case SPMineType.reviewProduct.rawValue:
            sp_clickReview()
        case SPMineType.auctionProduct.rawValue:
            sp_clickAuction()
        default:
            sp_log(message: "其他")
        }
    }
    
    @objc fileprivate func sp_clickAdd(){
        let addVC = SPProductAddVC()
        addVC.title = "添加商品"
        self.navigationController?.pushViewController(addVC, animated: true)
    }
    fileprivate func sp_clickSale(){
        let vc = SPShopProductVC()
        vc.title = "在售商品"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickWarehouse(){
        let vc = SPShopProductVC()
        vc.title = "仓库商品"
        vc.type = .warehouse
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickReview(){
        let vc = SPReviewProductVC()
        vc.title = "审核商品"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_clickAuction(){
        let vc = SPProductAuctionVC()
        vc.title = "竞拍商品"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    fileprivate func sp_setupData(){
       self.iconImgView.sp_cache(string: sp_getString(string: self.shopModel?.shop_logo), plImage: sp_getAppIcon())
        self.shopNameLabel.text = sp_getString(string: self.shopModel?.shop_name)
    }
 
}
extension  SPProductManagerVC {
    
    fileprivate func sp_sendShopRequest(){
        var parm = [String:Any]()
        if let shopId = SPAPPManager.instance().memberModel?.shop_id {
             parm.updateValue(shopId, forKey: "shop_id")
        }
        sp_showAnimation(view: self.view, title: nil)
        self.requestModel.parm = parm
        SPAppRequest.sp_getShop(requestModel: self.requestModel) {  [weak self](code , model, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code  == SP_Request_Code_Success {
                self?.shopModel = model
                self?.sp_setupData()
            }
        }
    }
    fileprivate func sp_sendCountRequest(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if SPAPPManager.sp_isBusiness() {
            parm.updateValue("shop", forKey: "type")
        }else{
            parm.updateValue("user", forKey: "type")
        }
        request.parm = parm
        SPAppRequest.sp_getMemberCount(requestModel: request) { [weak self](code,model, errorModel) in
            self?.sp_dealCountRequest(code: code, model: model, errorModel: errorModel)
        }
    }
    /// 处理请求数量
    ///
    /// - Parameters:
    ///   - code: 请求状态码
    ///   - model: 数量model
    ///   - errorModel: 错误
    private func sp_dealCountRequest(code : String,model:SPMineCountModel?,errorModel : SPRequestError?){
        if code == SP_Request_Code_Success {
            self.countModel = model
            self.contentView.countModel = self.countModel
        }
    }
}
