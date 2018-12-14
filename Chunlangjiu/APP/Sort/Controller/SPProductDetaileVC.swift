
//
//  SPProductDetaileVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import SnapKit
class SPProductDetaileVC: SPBaseVC {
    fileprivate lazy var topView : SPProductDetailTopView = {
        let view = SPProductDetailTopView(frame: CGRect(x: 0, y: 0, width: sp_getScreenWidth() - 80, height: SP_NAVGIT_HEIGHT))
        //        view.backgroundColor = UIColor.white
        
        //        view.isHidden = true
        view.btnClickBlock = { [weak self](index : Int) in
            self?.sp_dealTopBtnClick(index: index)
        }
        return view
    }()
    fileprivate lazy var bottomView : SPProductDetaileBottomView = {
        let view = SPProductDetaileBottomView ()
        view.backgroundColor = UIColor.white
        
        view.clickBlock = { [weak self](btn,type) in
            self?.sp_dealBottomClickComplete(btn: btn, type: type)
        }
        return view
    }()
    fileprivate lazy var scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_eeeeee.rawValue)
        return view
    }()
    fileprivate lazy var detaileView : SPProductDetaileView = {
        let view = SPProductDetaileView()
        view.didScrollBlock = { [weak self](view : UIScrollView) in
            self?.sp_didScrollComplete(view: view)
        }
        view.evaluateView.clickBlock = { [weak self]()in
            self?.sp_clickEv()
           
        }
        view.didDetaileBlock = { [weak self](isDetaile) in
            self?.sp_deal(isDetaile: isDetaile)
        }
        view.bannerView.selectBlock = { [weak self](index)in
            self?.sp_clickBraner(index: index)
        }
        view.timeOutBlock = { [weak self] in
//            self?.sp_sendRequest()
            self?.sp_clickBackAction()
        }
        view.recommendView.clickBlock = { [weak self] in
            self?.sp_clickMore()
        }
        view.recommendView.selectBlock = { [weak self] (model) in
            self?.sp_select(model: model)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(sp_pushShop))
        view.shopView.addGestureRecognizer(tap)
        view.productView.lookDetaile.addTarget(self, action: #selector(sp_lookAuction), for: UIControlEvents.touchUpInside)
        return view
    }()
    fileprivate lazy var webVC : SPProductDetaileWebVC = {
        let vc = SPProductDetaileWebVC()
        vc.showDownView = true
        vc.finishComlete = { [weak self] in
            self?.sp_deal(isDetaile: false)
        }
        return vc
    }()
    fileprivate lazy var shareBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_share_white"), for: UIControlState.selected)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.sp_cornerRadius(cornerRadius: 15)
        btn.addTarget(self, action: #selector(sp_clickShareAction), for: UIControlEvents.touchUpInside)
        btn.setImage(UIImage(named: "public_share_alpha"), for: UIControlState.normal)
        btn.isHidden = true
        return btn
    }()
    fileprivate lazy var evaluateVC : SPEvaluateListVC = {
        let view = SPEvaluateListVC()
        view.getDataBlock = {  [weak self](list ,total) in
            self?.detaileView.sp_setEvaluate(list: list, totalPage: total)
        }
        return view
    }()
    fileprivate lazy var backBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_back_wither"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "public_back"), for: UIControlState.selected)
        btn.addTarget(self, action: #selector(sp_clickBackAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        return btn
    }()
    fileprivate let topViewHeight : CGFloat = 44
    fileprivate var showDetaile : Bool = false
    fileprivate var topViewTopConstat : Constraint?
    var productModel : SPProductModel?
    var detaileModel : SPProductDetailModel?
    var countModel : SPShopCarCount?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_ffffff.rawValue)
        self.sp_setupUI()
        sp_sendRequest()
        sp_sendRecommd()
        sp_addNoitification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.sp_star()
        self.detaileView.productScrollView.delegate = self.detaileView
        self.detaileView.scrollViewDidScroll(self.detaileView.productScrollView)
        sp_sendCountRquest()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.sp_reset()
        self.detaileView.productScrollView.delegate = nil
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    /// 创建UI
    override func sp_setupUI() {
        //        self.view.addSubview(self.topView)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.bottomView)
        self.scrollView.addSubview(self.detaileView)
        self.addChildViewController(self.detaileView.webVC)
        self.scrollView.addSubview(self.webVC.view)
        self.addChildViewController(self.webVC)
        self.scrollView.addSubview(self.evaluateVC.view)
        self.addChildViewController(self.evaluateVC)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.shareBtn)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.backBtn)
        self.navigationItem.titleView = self.topView
        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        //        self.topView.snp.makeConstraints { (maker) in
        //            maker.left.right.equalTo(self.view).offset(0)
        //            self.topViewTopConstat = maker.top.equalTo(self.view).offset(0).constraint
        //            maker.height.equalTo(topViewHeight)
        //        }
        self.scrollView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            self.topViewTopConstat = maker.top.equalTo(self.view).offset(0).constraint
            maker.bottom.equalTo(self.bottomView.snp.top).offset(0)
        }
        self.bottomView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.detaileView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.equalTo(self.scrollView).offset(0)
            maker.width.equalTo(self.scrollView.snp.width).offset(0)
            maker.centerY.equalTo(self.scrollView.snp.centerY).offset(0)
        }
        self.webVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.detaileView.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.detaileView).offset(0)
        }
        self.evaluateVC.view.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.webVC.view.snp.right).offset(0)
            maker.top.bottom.width.equalTo(self.detaileView).offset(0)
            //            maker.right.equalTo(self.scrollView.snp.right).offset(0)
        }
        
    }
    deinit {
        self.scrollView.delegate = nil
        self.webVC.sp_remove()
    }
}
// MARK: - deletage
extension SPProductDetaileVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = self.scrollView.contentOffset.x / self.scrollView.frame.size.width
        self.sp_dealTopView(index: Int(index))
        self.topView.sp_setBtnIndex(index: Int(index))
    }
}
// MARK: - notification
extension SPProductDetaileVC {
    fileprivate func sp_addNoitification(){
        NotificationCenter.default.addObserver(self, selector:#selector(sp_login), name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_logout), name: NSNotification.Name(SP_LOGOUT_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_sendRequest), name: NSNotification.Name(SP_SUBMITAUCTION_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_login(){
        sp_sendRequest()
        sp_sendCountRquest()
    }
    @objc fileprivate func sp_logout(){
        sp_sendRequest()
        self.countModel = nil
        self.bottomView.countModel = nil
    }
}
// MARK: - action push
extension SPProductDetaileVC {
    fileprivate func sp_didScrollComplete(view : UIScrollView){
//        guard self.showDetaile == false else {
//            return
//        }
        let aplha = self.navigationController?.navigationBar.sp_change(SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue), with: view, andValue: (SP_NAVGIT_HEIGHT + sp_getstatusBarHeight()))
        if let a = aplha {
            self.sp_dealView(aplha: a)
        }
    }
    fileprivate func sp_dealView(aplha : CGFloat){
        if aplha >= 1 {
            if self.topView.isHidden == true{
                self.topView.isHidden = false
                self.topViewTopConstat?.update(offset: 0)
            }
            self.backBtn.isSelected = true
//            self.title = "商品详情"
            self.shareBtn.isSelected = true
            
        }else{
            if self.topView.isHidden == false {
                self.topView.isHidden = true
                self.topViewTopConstat?.update(offset: (-(SP_NAVGIT_HEIGHT + sp_getstatusBarHeight())))
            }
            self.backBtn.isSelected = false
            self.shareBtn.isSelected = false
//            self.title = ""
        }
    }
    fileprivate func sp_clickEv(){
        self.scrollView.delegate = nil
       
        sp_asyncAfter(time: 0.1) {
             self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3.0, height: 0)
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * 2.0, y: 0)
            self.topView.sp_setBtnIndex(index: 2)
        }
        
        self.navigationController?.navigationBar.sp_reset()
        self.sp_dealView(aplha: 1)
        
        sp_asyncAfter(time: 1) {
             self.scrollView.delegate = self
        }
//
    }
    fileprivate func sp_deal(isDetaile : Bool){
        self.showDetaile = isDetaile
        if isDetaile {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3.0, height: 0)
            sp_dealTopBtnClick(index: 1)
            self.navigationController?.navigationBar.sp_reset()
            sp_dealView(aplha: 1)
        }else
        {
            sp_dealTopBtnClick(index: 0)
            if self.topView.isHidden == true {
                 self.scrollView.contentSize = CGSize(width:0, height: 0)
            }
        }
    }
    
    fileprivate func sp_dealTopBtnClick(index : Int){
        self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width * CGFloat(integerLiteral: index), y: 0)
        self.sp_dealTopView(index: index)
    }
    fileprivate func sp_dealTopView(index : Int){
        if index == 0 {
            self.sp_didScrollComplete(view: self.detaileView.productScrollView)
        }else{
            self.navigationController?.navigationBar.sp_backColor(color: SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue))
            self.sp_dealView(aplha: 1)
        }
    }
    fileprivate func sp_clickMsgAction(){
//        if SPAPPManager.sp_isLogin(isPush: true){
//            let webVC = SPWebVC()
//            webVC.url = URL(string: "\(SP_GET_MSG_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))")
//            webVC.title = "消息"
//            self.navigationController?.pushViewController(webVC, animated: true)
//        }
     
        if sp_getString(string: self.detaileModel?.shop?.mobile).count > 0  {
            if let url = URL(string: "tel://\(sp_getString(string: self.detaileModel?.shop?.mobile))"){
                 UIApplication.shared.openURL(url)
            }
        }else{
            sp_showTextAlert(tips: "商家暂无联系方式")
        }
        
        
       
    }
    @objc fileprivate func sp_clickShareAction(){
        let shareDataModel = SPShareDataModel()
        shareDataModel.shareData = SP_SHARE_URL
        shareDataModel.title = sp_getString(string: self.detaileModel?.item?.title)
        shareDataModel.descr = sp_getString(string: self.detaileModel?.item?.sub_title)
        shareDataModel.currentViewController = self
        shareDataModel.thumbImage = sp_getString(string: self.detaileModel?.item?.images?.first)
        shareDataModel.placeholderImage =  sp_getLogoImg()
        SPShareManager.sp_share(shareDataModel: shareDataModel) { (model, error) in
            
        }
    }
    fileprivate func sp_clickCollectAction(isSelect : Bool){
        if SPAPPManager.sp_isLogin(isPush: true) {
            if isSelect {
                self.sp_sendAddCollectRequest()
            }else{
                self.sp_sendRemoveCollectRequest()
            }
        }else{
            self.bottomView.sp_setCollectRes()
        }
    }
    fileprivate func sp_clickShopCartAction(){
        let shopCartVC = SPShopCartVC()
        self.navigationController?.pushViewController(shopCartVC, animated: true)
    }
    fileprivate func sp_clickIntoShopCartAction(){
        if SPAPPManager.sp_isLogin(isPush: true) {
            SPProductNumView.sp_show { [weak self](text) in
                self?.sp_sendAddRequest(text: text)
            }
        }
    }
    fileprivate func sp_clickBuyAction(){
        if SPAPPManager.sp_isLogin(isPush: true) {
            SPProductNumView.sp_show { [weak self](text) in
                self?.sp_sendBuyRequest(text: text)
            }
        }
    }
    fileprivate func sp_clickShopAction(){
        let shopVC = SPShopHomeVC()
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
    /// 跳到店铺首页
    @objc fileprivate func sp_pushShop(){
        let shopVC = SPShopHomeVC()
        shopVC.shopModel = self.detaileModel?.shop
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
    fileprivate func sp_clickEditPrice(btn : UIButton){
        if SPAPPManager.sp_isLogin(isPush: true) {
            if let isCheck : Bool = Bool(sp_getString(string: (self.detaileModel?.item?.check))) , isCheck == true {
                 // 已经购买过了
                if let isPay : Bool = Bool(sp_getString(string: self.detaileModel?.item?.is_pay)) , isPay == true{
                    // 已经支付了
                    SPAddPriceView.sp_show(maxPrice: sp_getString(string: self.detaileModel?.item?.max_price), originPrice: sp_getString(string: detaileModel?.item?.original_bid),status: sp_getString(string: self.detaileModel?.item?.auction_status)) { (price) in
                        self.sp_sendEditPricRequest(price: price)
                    }
                }else{
                  //没有支付
                let orderModel = SPOrderModel()
                orderModel.payment_id = self.detaileModel?.item?.payment_id
                    orderModel.type = SP_AUCTION
                    orderModel.status = SP_AUCTION_0
                    SPOrderHandle.sp_toPay(orderModel: orderModel, viewController: self) { [weak self](isSuccess) in
                        self?.sp_sendRequest()
                    }
                }
            }else{
                // 没有购买过
                sp_sendAuctionConfirm()
            }
        }
    }
    fileprivate func sp_dealBottomClickComplete(btn:UIButton,type:SPProductDetaileBtnType){
        switch type {
        case .msg:
            self.sp_clickMsgAction()
        case .buy:
            self.sp_clickBuyAction()
        case .collection:
            self.sp_clickCollectAction(isSelect: btn.isSelected)
        case .editPrice:
            sp_clickEditPrice(btn: btn)
        case .intoShopcart:
            sp_clickIntoShopCartAction()
        case .shopcart:
            sp_clickShopCartAction()
        }
    }
    /// 查看出价详细
    @objc fileprivate func sp_lookAuction(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.detaileModel?.item?.auctionitem_id), forKey: "auctionitem_id")
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getAuctionPriceList(requestModel: request) { [weak self](code , list, errorModel, total) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                if sp_getArrayCount(array: list) > 0 {
                    SPAuctionPriceList.sp_show(list: list as? [SPAuctionPrice])
                }else{
                    sp_showTextAlert(tips: "还没有人出价哦!")
                }
            }else{
                sp_showTextAlert(tips: "获取列表数据失败")
            }
        }
    }
    fileprivate func sp_clickBraner(index : Int){
        sp_log(message: "index \(index)")
        let lookPictureVC = SPLookPictureVC()
        lookPictureVC.dataArray = self.detaileModel?.item?.images
        lookPictureVC.selectIndex = index
        self.present(lookPictureVC, animated: true, completion: nil)
    }
    fileprivate func sp_clickMore(){
        let productListVC = SPProductListVC()
        self.navigationController?.pushViewController(productListVC, animated: true)
        
    }
    fileprivate func sp_select(model : SPProductModel?){
        guard let productModel = model else {
            return
        }
        let detaileVC = SPProductDetaileVC()
        detaileVC.productModel = productModel
        self.navigationController?.pushViewController(detaileVC, animated: true)
    }
}
// MARK: - 网络请求
extension SPProductDetaileVC {
    /// 请求
   @objc fileprivate func sp_sendRequest(){
        var parm = [String : Any]()
        if let p = self.productModel {
            parm.updateValue(p.item_id, forKey: "item_id")
        }
        parm.updateValue(sp_getString(string: SPAPPManager.instance().userModel?.accessToken), forKey: "token")
        //        parm.updateValue("v2", forKey: "v")
        self.requestModel.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_productDetaile(requestModel: self.requestModel) { [weak self](errorCode, detaileModel, errorModel) in
            self?.sp_dealRequest(errorCode: errorCode, detaileModel: detaileModel, errorModel: errorModel)
        }
    }
    private func sp_dealRequest(errorCode:String,detaileModel:SPProductDetailModel?,errorModel:SPRequestError?){
        if errorCode == SP_Request_Code_Success {
            self.bottomView.isHidden = false
            self.detaileModel = detaileModel
            self.detaileView.detaileModel = detaileModel
            self.evaluateVC.skuID = detaileModel?.item?.item_id
            self.evaluateVC.sp_sendRequest()
            self.bottomView.detaileModel = detaileModel
            self.webVC.url = URL(string: sp_getString(string: detaileModel?.item?.desc))
            self.webVC.sp_reloadUrl()
           
        }else{
            self.bottomView.isHidden = true

        }
        sp_hideAnimation(view: self.view)
    }
    fileprivate func sp_sendAddRequest(text:String){
        guard let m = self.detaileModel?.item else {
            return
        }
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: m.sku_id), forKey: "sku_id")
        parm.updateValue(Int(sp_getString(string: text)) ?? 1, forKey: "quantity")
        parm.updateValue("", forKey: "package_sku_ids")
        parm.updateValue("", forKey: "package_id")
        parm.updateValue("item", forKey: "obj_type")
        parm.updateValue("cart", forKey: "mode")
        
        request.parm = parm
        SPAppRequest.sp_getAddProduct(requestModel: request) { [weak self](code , msg, errorModel) in
            if code == SP_Request_Code_Success {
                self?.sp_sendCountRquest()
            }else{
                sp_log(message: "添加商品失败哦哦哦哦")
                sp_showTextAlert(tips: msg.count > 0 ? msg : "添加商品失败")
            }
        }
    }
    fileprivate func sp_sendAddCollectRequest(){
        let request = SPRequestModel()
        var parm = [String:Any]()
        if let productModel = self.detaileModel?.item {
            parm.updateValue(productModel.item_id, forKey: "item_id")
        }
        request.parm = parm
        sp_showAnimation(view: self.view, title: "添加收藏...")
        SPAppRequest.sp_getAddCollection(requestModel: request) { [weak self](code , msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code  == SP_Request_Code_Success{
                sp_showTextAlert(tips: msg)
            }else{
                sp_showTextAlert(tips: msg)
                self?.bottomView.sp_setCollectRes()
            }
        }
    }
    fileprivate func sp_sendRemoveCollectRequest(){
        let request = SPRequestModel()
        var parm = [String:Any]()
        if let productModel = self.detaileModel?.item {
            parm.updateValue(productModel.item_id, forKey: "item_id")
        }
        request.parm = parm
        sp_showAnimation(view: self.view, title: "取消收藏中...")
        SPAppRequest.sp_getRemoveCollect(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                sp_showTextAlert(tips: msg)
            }else{
                sp_showTextAlert(tips: msg)
                self?.bottomView.sp_setCollectRes()
            }
        }
    }
    /// 立即购买
    ///
    /// - Parameter text: 数量
    fileprivate func sp_sendBuyRequest(text:String){
        guard let m = self.detaileModel?.item else {
            return
        }
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: m.sku_id), forKey: "sku_id")
        parm.updateValue(Int(sp_getString(string: text)) ?? 1, forKey: "quantity")
        parm.updateValue("", forKey: "package_sku_ids")
        parm.updateValue("", forKey: "package_id")
        parm.updateValue("item", forKey: "obj_type")
        parm.updateValue(SP_MODE_TYPE_FASTBUY, forKey: "mode")
        
        request.parm = parm
        sp_showAnimation(view: self.view, title: nil)
        SPAppRequest.sp_getAddProduct(requestModel: request) { [weak self](code , msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.sp_sendConfirmOrderRequest()
            }else{
                sp_log(message: "购买失败!")
                sp_hideAnimation(view: self?.view)
                sp_showTextAlert(tips: msg.count > 0 ? msg : "购买失败!")
            }
        }
    }
    /// 发送确认订单
    fileprivate func sp_sendConfirmOrderRequest(){
        sp_showAnimation(view: self.view, title: nil)
        let confirmOrder = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(SP_MODE_TYPE_FASTBUY, forKey: "mode")
        confirmOrder.parm = parm
        SPAppRequest.sp_getConfirmOrder(reqestModel: confirmOrder) { [weak self](code, msg, confirmOrderMOdel, errorModel) in
            self?.sp_dealConfirmOrderRequest(code: code, msg: msg, confirmOrderModel: confirmOrderMOdel, errorModel: errorModel)
        }
    }
    /// 处理确认订单请求
    ///
    /// - Parameters:
    ///   - code: 请求code
    ///   - msg: msg
    ///   - confirmOrderModel: 确认订单数据
    ///   - errorModel: 错误码
    private func sp_dealConfirmOrderRequest(code : String,msg : String,confirmOrderModel :SPConfirmOrderModel?,errorModel : SPRequestError?){
        sp_hideAnimation(view: self.view)
        if code == SP_Request_Code_Success {
            let confirmOrderVC = SPConfirmOrderVC()
            confirmOrderVC.modelType = SP_MODE_TYPE_FASTBUY
            confirmOrderVC.confirmOrder = confirmOrderModel
            if let isAuction =   self.detaileModel?.item?.isAuction, isAuction == true{
                confirmOrderVC.isAuction = true
//                let shopModel = self.detaileModel?.shop
//                if self.detaileModel?.item != nil{
//                    shopModel?.productArray = [self.detaileModel?.item] as? [SPProductModel]
//                }
//                if shopModel != nil{
//                    confirmOrderVC.confirmOrder?.dataArray = [shopModel] as? [SPShopModel]
//                }
//                confirmOrderVC.confirmOrder?.auctionitem_id = self.detaileModel?.item?.auctionitem_id
            }
            self.navigationController?.pushViewController(confirmOrderVC, animated: true)
        }else{
            sp_showTextAlert(tips: msg)
        }
    }
    fileprivate func sp_sendCountRquest(){
        let countRequest = SPRequestModel()
        SPAppRequest.sp_getShopCartCount(requestModel: countRequest) { [weak self](code, countModel, error) in
            if code == SP_Request_Code_Success {
                self?.countModel = countModel;
                self?.bottomView.countModel = countModel
            }
        }
    }
    fileprivate func sp_sendAuctionConfirm(){
        sp_showAnimation(view: self.view, title: nil)
        let confirmOrder = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: self.detaileModel?.item?.auctionitem_id), forKey: "auctionitem_id")
        confirmOrder.parm = parm
        SPAppRequest.sp_getAuctionConfirmOrder(reqestModel: confirmOrder) {  [weak self](code, msg, confirmOrderMOdel, errorModel) in
            self?.sp_dealConfirmOrderRequest(code: code, msg: msg, confirmOrderModel: confirmOrderMOdel, errorModel: errorModel)
        }
    }
    fileprivate func sp_sendEditPricRequest(price : String){
        sp_showAnimation(view: self.view, title: nil)
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: price), forKey: "price")
        parm.updateValue(sp_getString(string: self.detaileModel?.item?.auctionitem_id), forKey: "auctionitem_id")
        request.parm = parm
        SPAppRequest.sp_getAuctionAddPrice(requestModel: request) {  [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: "出价成功")
                self?.sp_sendRequest()
                NotificationCenter.default.post(name: NSNotification.Name(SP_EDITPRICEAUCTON_NOTIFICATION), object: nil)
            }else{
                 sp_showTextAlert(tips: msg)
            }
           
            
        }
    }
    fileprivate func sp_sendRecommd(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        if let p = self.productModel {
            parm.updateValue(p.item_id, forKey: "item_id")
        }
        parm.updateValue(1, forKey: "page_no")
        parm.updateValue(6, forKey: "page_size")
        request.parm = parm
        SPAppRequest.sp_productRecommd(requestModel: request) { [weak self](code , list, errorModel, total) in
            if code == SP_Request_Code_Success{
                self?.detaileView.sp_setRecomd(list: list)
            }
        }
 
    }
}
