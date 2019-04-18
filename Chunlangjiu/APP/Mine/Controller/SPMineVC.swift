//
//  SPMineVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 个人中心
import Foundation

import SnapKit
class SPMineVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    fileprivate lazy var headerView : SPMineHeaderView = {
        let view = SPMineHeaderView(frame:  CGRect(x: 0, y: 0, width: sp_getScreenWidth(), height: sp_getstatusBarHeight() + SP_NAVGIT_HEIGHT + 125 + 18))
        view.clickLogin = { [weak self] in
            self?.sp_pushLogin()
        }
        view.clickIdent = { [weak self] in
            self?.sp_clickIdentAction()
        }
        view.clickIcon = { [weak self] in
            self?.sp_clickIconAction()
        }
        view.clickAuth = { [weak self] in
            self?.sp_clickIdentAction(isPush: false)
        }
        return view
    }()
    fileprivate lazy var setBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "public_set"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(sp_clickSet), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate var dataArray : [SPMineSectionModel]?
  
    fileprivate var pushVC : Bool = false
     
    private var countModel : SPMineCountModel?
    
    /// 企业认证状态
    private var companyAuth : SPCompanyAuth?
    private var realNameAuth : SPRealNameAuth?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sp_setupUI()
        self.sp_getData()
        sp_addNotification()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sp_log(message: "isStatusBarHidden is \(UIApplication.shared.isStatusBarHidden)")
        self.navigationController?.setNavigationBarHidden(true, animated: self.pushVC ? true : false)
        self.sp_sendAllRequest()
        self.headerView.sp_checkLogin()
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
    /// 创建UI
    override func sp_setupUI() {
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
//        self.tableView.estimatedRowHeight = 120
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.tableHeaderView = self.headerView
        self.tableView.bounces = false
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.setBtn)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }

        self.sp_addConstraint()
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.setBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.right.equalTo(self.view).offset(-10)
            maker.top.equalTo(self.view).offset( sp_getstatusBarHeight() + 6)
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - delegate
extension SPMineVC: UITableViewDelegate ,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray) > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mineTableCellID = "mineTableCellID"
        var cell : SPMineTableCell? = tableView.dequeueReusableCell(withIdentifier: mineTableCellID) as? SPMineTableCell
        if cell == nil {
            cell = SPMineTableCell(style: UITableViewCellStyle.default, reuseIdentifier: mineTableCellID)
            cell?.contentView.backgroundColor = self.view.backgroundColor
            
        }
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            cell?.countModel = self.countModel
            cell?.sectionModel = self.dataArray?[indexPath.row]
            cell?.selectBlock = { [weak self] (model) in
                self?.sp_dealSelect(mineModel: model)
            }
            
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let sectionModel = self.dataArray?[indexPath.row]
            if let model = sectionModel {
                return 40 + sp_lineHeight + 10 + CGFloat((sp_getArrayCount(array: model.dataArray) / model.rowCount + (sp_getArrayCount(array: model.dataArray) % model.rowCount  > 0 ? 1 : 0) ) * 81)
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard SPAPPManager.sp_isLogin(isPush: true) else {
            return
        }
        
        if indexPath.row < sp_getArrayCount(array: self.dataArray) {
            let sectionModel = self.dataArray?[indexPath.row]
            if let model = sectionModel {
                if model.type == .orderManager{
                    sp_pushOrderVC()
                }else if model.type == .productManager{
                    sp_pushProductManager()
                }
                
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[ UIImagePickerControllerEditedImage] as? UIImage
        self.sp_uploadImage(image: image)
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - action push
extension SPMineVC {
    
    fileprivate func sp_dealSelect(mineModel : SPMineModel?){
        
        guard SPAPPManager.sp_isLogin(isPush: true) else {
            self.pushVC = true
            return
        }
        
        guard let model = mineModel else {
            return
        }
        self.pushVC = true
        switch model.mintType {
        case .address?:
            self.sp_pushAddressVC()
        case .addProduct?:
            self.sp_pushAddProduct()
        case .share?:
            self.sp_clickShare()
        case .pend_pay?:
            self.sp_pushOrderVC(orderState: SPOrderStatus.pendPay)
        case .pend_receipt?:
            self.sp_pushOrderVC(orderState: SPOrderStatus.receipt)
        case .evaluated?:
            sp_pushEvaluateVC()
        case .after_sale?:
            sp_pushAfterSaleVC(orderState: SPOrderStatus.all)
        case .all_order? :
            sp_pushOrderVC(orderState: SPOrderStatus.all)
        case .paydown? :
            sp_pushAuctionVC(orderState: SPOrderStatus.paydown)
        case .auction_ing?:
            sp_pushAuctionVC(orderState: SPOrderStatus.auction_ing)
        case .winning_bid?:
            sp_pushAuctionVC(orderState: SPOrderStatus.winning_bid)
        case .falling_mark? :
            sp_pushAuctionVC(orderState: SPOrderStatus.falling_mark)
        case .auction_receipt?:
            sp_pushAuctionVC(orderState: SPOrderStatus.auction_receipt)
        case .auction_all?:
            sp_pushAuctionVC(orderState: SPOrderStatus.all)
        case .deliver?:
            sp_pushOrderVC(orderState: SPOrderStatus.deliver)
        case .saleProduct?:
            sp_clickSale()
//            sp_pushWebVC(url: "\(SP_GET_ONSALE_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "在售商品管理")
        case .warehouseProduct?:
            sp_clickWarehouse()
//            sp_pushWebVC(url: "\(SP_GET_INSTOCK_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "仓库商品管理")
        case .member?:
            if SPAPPManager.sp_isBusiness() {
                sp_pushWebVC(url: "\(SP_GER_SELLERINFO_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "会员资料")
            }else{
                sp_pushWebVC(url: "\(SP_GET_USER_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "会员资料")
            }
        case .funds?:
            sp_pushFundsVC()
        //                         sp_pushWebVC(url: "\(SP_GET_CAPITAL_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "资金管理")
        case .collect?:
            sp_pushWebVC(url: "\(SP_GET_COLLECT_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "我的收藏")
        case .bank_card?:
            sp_pushWebVC(url: "\(SP_GET_BANK_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "银行卡管理")
        case .auctionProduct?:
            sp_clickProductAuction()
//            sp_pushWebVC(url: "\(SP_GET_AUCTION_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "竞拍商品管理")
        case .reviewProduct?:
            sp_clickReview()
//            sp_pushWebVC(url: "\(SP_GET_PEND_WEB_UEL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "审核商品管理")
        case .cance?:
            sp_clickCanceOrder()
        case .valuation?:
            sp_pushWebVC(url: "\(SP_GET_EVALUATE_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "我的估值")
        case .set?:
            sp_clickSet()
        case .customServer?:
            sp_pushCustomServer()
        case .fans?:
            sp_pushFans()
        case .shop?:
            sp_clickShop()
        case .none:
            sp_log(message: "none")
        case .some(_):
            sp_log(message: "some")
        }
    
    }
    fileprivate func sp_pushFans(){
        let fansVC = SPFansVC()
        self.navigationController?.pushViewController(fansVC, animated: true)
    }
    fileprivate func sp_pushCustomServer(){
        let serverVC = SPCustomerServiceVC()
        self.navigationController?.pushViewController(serverVC, animated: true)
    }
    
    fileprivate func sp_pushAddressVC(){
        let addressVC = SPAddressVC()
        addressVC.title = "地址列表"
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    @objc func sp_pushLogin(){
        SPAPPManager.sp_login()
        self.pushVC = true 
    }
    /// 点击切换身份事件
    fileprivate func sp_clickIdentAction(isPush:Bool = true){
        guard let userModel = SPAPPManager.instance().userModel else {
            sp_pushLogin()
            return
        }
//        guard let realModel = self.realNameAuth else {
//            sp_pushAuthHomeVC()
//            return
//        }
//
        if sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODIFIER || sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODIFIER {
            if isPush {
                if sp_getString(string: userModel.identity) == SP_IS_ENTERPRISE {
                    SPAPPManager.sp_change(identity: "")
                    
                }else{
                    SPAPPManager.sp_change(identity: SP_IS_ENTERPRISE)
                    
                }
                sp_changeIdent()
                self.headerView.sp_setupData()
                sp_transitionAnimation()
            }
        }else{
            sp_pushAuthHomeVC()
//            if  sp_getString(string: realModel.status) == SP_STATUS_ACTIVE || sp_getString(string: realModel.status) == SP_STATUS_FAILING{
//                if sp_getString(string: realModel.status) == SP_STATUS_ACTIVE  {
//                    sp_showTextAlert(tips: "您还没有进行实名认证，请先认证！")
//                }
//
//
//            }else if sp_getString(string: self.realNameAuth?.status) == SP_STATUS_LOCKED {
//                let alertController = UIAlertController(title: "提示", message: "您的认证正在审核中，我们会尽快处理的", preferredStyle: UIAlertControllerStyle.alert)
//                alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
//
//                }))
//                sp_mainQueue { [weak self] in
//                    self?.present(alertController, animated: true, completion: nil)
//                }
//
//            }
        }
    }
    
    fileprivate func sp_pushAuthHomeVC(){
        self.pushVC = true
        let authVC = SPAuthHomeVC()
        self.navigationController?.pushViewController(authVC, animated: true)
    }
    
    /// 点击认证
    fileprivate func sp_clickAuthAction(){
        guard let model = self.realNameAuth else {
            sp_pushRealNameVC()
            return
        }
        
        if sp_getString(string: model.status) == SP_STATUS_ACTIVE || sp_getString(string: model.status) == SP_STATUS_FAILING{
            if sp_getString(string: model.status) == SP_STATUS_FAILING {
                sp_showTextAlert(tips: "您的认证被驳回，请重新提交资料审核")
            }
            sp_pushRealNameVC()
        }else if sp_getString(string: model.status) == SP_STATUS_LOCKED{
            let alertController = UIAlertController(title: "提示", message: "您的认证正在审核中，我们会尽快处理的", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            sp_mainQueue { [weak self]in
                self?.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    fileprivate func sp_pushRealNameVC(){
        self.pushVC = true
        // 个人认证
        let realVC = SPRealNameAuthenticationVC()
        self.navigationController?.pushViewController(realVC, animated: true)
    }
    fileprivate func sp_clickCompany(){
        guard let model = self.companyAuth else {
            sp_pushCompanyVC()
            return
        }
        if sp_getString(string: model.status) == SP_STATUS_LOCKED {
            let alertController = UIAlertController(title: "提示", message: "您的认证正在审核中，我们会尽快处理的", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            sp_mainQueue { [weak self]in
                 self?.present(alertController, animated: true, completion: nil)
            }
           
        }else if sp_getString(string: model.status) == SP_STATUS_FAILING || sp_getString(string: model.status) ==  SP_STATUS_ACTIVE {
            if sp_getString(string: model.status) == SP_STATUS_FAILING {
                 sp_showTextAlert(tips: "您的认证被驳回，请重新提交资料审核")
            }
          sp_pushCompanyVC()
        }
    }
    fileprivate func sp_pushCompanyVC(){
        self.pushVC = true
        //  企业认证
        let companyVC = SPCompanyAuthenticationVC()
        self.navigationController?.pushViewController(companyVC, animated: true)
    }
    /// 点击头像
    fileprivate func sp_clickIconAction(){
//        self.pushVC = true
        //        sp_showSelectImage(viewController: self, delegate: self)
        sp_thrSelectImg(viewController: self, nav: self.navigationController) { [weak self](img) in
             self?.sp_uploadImage(image: img)
        }
    }
    /// 点击修改昵称
    fileprivate func sp_clickEdit(){
        SPMineEditView.sp_show(title: nil) { [weak self](text) in
            self?.sp_sendUpdateShop(name: sp_getString(string: text))
        }
    }
    fileprivate func sp_pushAddProduct(){
        let addProduct = SPProductAddVC()
        addProduct.title = "添加商品"
        self.navigationController?.pushViewController(addProduct, animated: true)
        
    }
    /// 点击分享
    fileprivate func sp_clickShare(){
        self.pushVC = false
        let shareDataModel = SPShareDataModel()
        shareDataModel.shareData = SP_SHARE_URL
        shareDataModel.title = "给您推荐高端酒综合服务平台-醇狼"
        shareDataModel.descr = "为行业用户提供高端酒发布、估价、竞拍、鉴定等综合性服务"
        shareDataModel.currentViewController = self
        shareDataModel.thumbImage =  sp_getLogoImg()
        SPShareManager.sp_share(shareDataModel: shareDataModel) { (model, error) in
            
        }
    }
    /// 点击银行卡
    fileprivate func sp_clickBankCard(){
        let bankCardVC = SPBankCardVC()
        self.navigationController?.pushViewController(bankCardVC, animated: true)
    }
    
    fileprivate func sp_getData(){
         self.dataArray = SPMineData.sp_getMineAllData()
        self.tableView.reloadData()
    }
    fileprivate func sp_clickShop(){
        self.pushVC = true
        let shopVC = SPShopHomeVC()
        let shopModel = SPShopModel()
        shopModel.shop_name = SPAPPManager.instance().memberModel?.shop_name
        shopModel.shop_id = SPAPPManager.instance().memberModel?.shop_id
        shopVC.shopModel = shopModel
        self.navigationController?.pushViewController(shopVC, animated: true)
    }
    fileprivate func sp_pushOrderVC(orderState : SPOrderStatus = .all){
        self.pushVC = true
        if SPAPPManager.sp_isBusiness() {
            let orderVC = SPOrderVC()
            orderVC.orderState = orderState
            if sp_getString(string: SPAPPManager.instance().userModel?.identity) == SP_IS_ENTERPRISE {
                orderVC.orderType = .shopType
            }else{
                orderVC.orderType = .defaultType
            }
            self.navigationController?.pushViewController(orderVC, animated: true)
        }else{
            let orderVC = SPOrderHomeVC()
            orderVC.orderState = orderState
            orderVC.orderType = .defaultType
            self.navigationController?.pushViewController(orderVC, animated: true)
        }
        
        
      
    }
    fileprivate func sp_pushAfterSaleVC(orderState : SPOrderStatus = .all){
        let orderVC = SPOrderVC()
        orderVC.orderState = orderState
         if sp_getString(string: SPAPPManager.instance().userModel?.identity) == SP_IS_ENTERPRISE {
            orderVC.orderType = .shopSaleType
         }else{
            orderVC.orderType = .afterSaleType
        }
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    fileprivate func sp_pushProductManager(){
        self.pushVC = true
        sp_clickProductManager()
//        sp_pushWebVC(url: "\(SP_GET_ITECEMTER_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))", title: "商品管理")
        
    }
    fileprivate func sp_pushAuctionVC(orderState : SPOrderStatus = .all){
        let orderVC = SPOrderVC()
        orderVC.orderState = orderState
        orderVC.orderType = .auctionType
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    fileprivate func sp_pushEvaluateVC(){
        let order = SPOrderListVC()
        order.title = "待评价订单"
        let tooleModel = SPOrderToolModel()
        tooleModel.orderType = .defaultType
        tooleModel.status = .evaluated
        order.toolModel = tooleModel
        self.navigationController?.pushViewController(order, animated: true)
    }
    fileprivate func sp_pushFallingMarkVC(){
        let order = SPOrderListVC()
        order.title = "落标订单"
        let tooleModel = SPOrderToolModel()
        tooleModel.orderType = .defaultType
        tooleModel.status = .falling_mark
        order.toolModel = tooleModel
        self.navigationController?.pushViewController(order, animated: true)
    }
    
    fileprivate func sp_pushWebVC(url : String,title:String? = nil){
        let webVC = SPWebVC()
        webVC.url = URL(string: url)
        webVC.title = title
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    fileprivate func sp_pushFundsVC(){
        let fundsVC = SPFundsVC()
        self.navigationController?.pushViewController(fundsVC, animated: true)
    }
    @objc fileprivate func sp_clickSet(){
        if SPAPPManager.sp_isLogin(isPush: true){
//            sp_pushWebVC(url: "\(SP_GET_SETTING_WEB_URL)?apitoken=\(sp_getString(string: SPAPPManager.instance().userModel?.accessToken))",title: "设置")
            let setVC = SPSetVC()
            self.navigationController?.pushViewController(setVC, animated: true)
        }
        self.pushVC = true
    }
    fileprivate func sp_clickProductManager(){
        let managerVC = SPProductManagerVC()
        self.navigationController?.pushViewController(managerVC, animated: true)
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
    fileprivate func sp_clickProductAuction(){
        let vc = SPProductAuctionVC()
        vc.title = "竞拍商品"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 取消订单
    fileprivate func sp_clickCanceOrder(){
        let orderListVC = SPOrderListVC()
        let toolModel = SPOrderToolModel()
        toolModel.status = .userApplyRefund
        toolModel.orderType = .shopType
        toolModel.statusString = "取消订单"
        orderListVC.toolModel = toolModel
        orderListVC.title = "取消订单"
        self.navigationController?.pushViewController(orderListVC, animated: true)
    }
    fileprivate func sp_transitionAnimation(){
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        UIView.setAnimationDuration(1.0)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.view, cache: true)
        UIView.commitAnimations()
    }
    fileprivate func sp_dealHeaderView(){
        
        if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODIFIER || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODIFIER {
            self.headerView.sp_isAuth(isAuth: true)
        }else{
            self.headerView.sp_isAuth(isAuth: false)
            if sp_getString(string: SPAPPManager.instance().userModel?.identity) == SP_IS_ENTERPRISE {
                  SPAPPManager.sp_change(identity: "")
                self.sp_getData()
                self.sp_sendCountRequest()
                self.sp_sendMemberInfoRequest()
                self.headerView.sp_setupData()
            }
        }
    }
    fileprivate func sp_dealAuthAlert(){
        if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FINISH {
            // 认证成功
            
            if SPRealmTool.sp_getIsAlert(isSuccess: true) == true {
                SPMineAlertView.sp_showView(title:  sp_getString(string: self.companyAuth?.status) == SP_STATUS_FINISH ? "您的企业认证已通过！" : "您的个人认证已通过！", content: "恭喜您可以在醇狼平台发布商品啦！\n若交易成功，平台每单将收取3.5%的佣金。", btnTitle: "去发布商品", isSuccess: true) { [weak self] in
                    self?.sp_pushAddProduct()
                }
                SPRealmTool.sp_insertAuthSuccess(isAlert: false)
            }
            
           
            
        }else if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FAILING || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODEFIERFAIL || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_FAILING || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODEFIERFAIL {
            if SPRealmTool.sp_getIsAlert(isSuccess: false) == true {
                // 认证失败
                var title = ""
                if sp_getString(string: self.companyAuth?.status) == SP_STATUS_FAILING || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODEFIERFAIL {
                    title = "您的企业认证未通过！"
                }else{
                    title = "您的个人认证未通过！"
                }
                SPMineAlertView.sp_showView(title:  title, content: "距离发布商品还差一点点哦，我们期待您再次提交。", btnTitle: "重新提交认证", isSuccess: false) { [weak self] in
                    self?.sp_pushAuthHomeVC()
                }
                SPRealmTool.sp_insertAuthFaile(isAlert: false)
            }
           
        }else {
            if sp_getString(string: self.companyAuth?.status) == SP_STATUS_LOCKED || sp_getString(string: self.companyAuth?.status) == SP_STATUS_MODIFIER || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_LOCKED || sp_getString(string: self.realNameAuth?.status) == SP_STATUS_MODIFIER {
                SPRealmTool.sp_insertAuthFaile(isAlert: true)
                SPRealmTool.sp_insertAuthSuccess(isAlert: true)
            }
        }
        
    }
}

// MARK: - 请求 数据
extension SPMineVC{
    
    /// 上传图片
    ///
    /// - Parameter image: 图片
    fileprivate func sp_uploadImage(image : UIImage?){
        guard let uImage = image else {
            return
        }
        let uploadImage = sp_fixOrientation(aImage: uImage)
        let d = sp_resetImgSize(sourceImage: uploadImage)
        //        let data = UIImageJPEGRepresentation(uploadImage, 1.0)
        //        if let d = data {
        let imageRequestModel = SPRequestModel()
        imageRequestModel.data = [d]
        imageRequestModel.name = "image"
        imageRequestModel.fileName = ["proudct.jpg"]
        imageRequestModel.mineType = "image/jpg"
        var parm = [String:Any]()
        parm.updateValue("rate", forKey: "image_type")
        parm.updateValue("proudct.jpg", forKey: "image_input_title")
        parm.updateValue("binary", forKey: "upload_type")
        
        imageRequestModel.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel) { [weak self](code, msg, uploadImageModel, errorModel) in
            if code == SP_Request_Code_Success, let upload = uploadImageModel{
                self?.sp_sendSet(img:sp_getString(string: upload.url))
            }else{
                sp_showTextAlert(tips: msg)
                sp_hideAnimation(view: nil)
            }
            
        }
        //        }
    }
    fileprivate func sp_sendSet(img imgUrl : String){
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: imgUrl), forKey: "img_url")
        request.parm = parm
        SPAppRequest.sp_getUserImgSet(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: nil)
            if code == SP_Request_Code_Success {
                if let model = SPAPPManager.instance().memberModel {
                    model.head_portrait = imgUrl
                    SPAPPManager.instance().memberModel = model
                    self?.headerView.memberModel = model
                }
            }
            
        }
    }
    fileprivate func sp_sendAllRequest(){
        guard SPAPPManager.instance().userModel != nil else {
            sp_asyncAfter(time: 0.1) {
                self.tableView.reloadData()
            }
            return
        }
        self.sp_sendCountRequest()
        self.sp_sendMemberInfoRequest()
        sp_sendAuthRequest()
    }
    
    /// 获取数据统计请求
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
            self.tableView.reloadData()
        }
    }
    /// 获取会员信息请求
    fileprivate func sp_sendMemberInfoRequest(){
        let request = SPRequestModel()
        SPAppRequest.sp_getMemberInfo(requestModel: request) { [weak self](code, memberModel, errorModel) in
         self?.sp_dealMemberInfoRequest(code: code, memberModel: memberModel, errorModel: errorModel)
        }
    }
    private func sp_dealMemberInfoRequest(code:String,memberModel:SPMemberModel?,errorModel:SPRequestError?){
            if code == SP_Request_Code_Success {
                SPAPPManager.instance().memberModel = memberModel;
                self.headerView.memberModel = SPAPPManager.instance().memberModel
            }
    }
    
    /// 发送认证的请求
    fileprivate func sp_sendAuthRequest(){
        
        let group = DispatchGroup()
        group.enter()
        SPAppRequest.sp_getCompanyAuthStatus(requestModel: SPRequestModel()) { [weak self](code , model, errorModel) in
            if code == SP_Request_Code_Success{
                self?.companyAuth = model
            }
            group.leave()
        }
        group.enter()
        SPAppRequest.sp_getRealNameAuth(requestModel: SPRequestModel()) { [weak self](code , model , errorModel) in
            if code == SP_Request_Code_Success{
                self?.realNameAuth = model
                
            }
            group.leave()
        }
        group.notify(queue: DispatchQueue(label: "getAuthStatusQueue")) { [weak self] in
            sp_mainQueue {
                self?.sp_dealHeaderView()
                self?.sp_dealAuthAlert()
            }
        }
    }
    
    fileprivate func sp_sendUpdateShop(name:String){
        sp_showAnimation(view: self.view, title: nil)
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: name), forKey: "company_name")
        request.parm = parm
        SPAppRequest.sp_getUpdateShop(requestModel: request) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                if let model = SPAPPManager.instance().memberModel {
                    model.shop_name = name
                }
                self?.tableView.reloadData()
                sp_showTextAlert(tips: sp_getString(string: msg).count >  0 ? sp_getString(string: msg) : "更改成功")
            }else{
                sp_showTextAlert(tips: msg)
            }
        }
    }
    
}
// MARK: - notification
extension SPMineVC{
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_logout), name: NSNotification.Name(SP_LOGOUT_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_changeIdent), name: NSNotification.Name(SP_CHANGEID_NOTIFICATION), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_netChange), name: NSNotification.Name(SP_NETWORK_NOTIFICATION), object: nil)
    }
    /// 退出登录通知
    @objc fileprivate func sp_logout(){
        SPAPPManager.sp_change(identity: "")
        self.companyAuth = nil
        self.realNameAuth = nil
        self.countModel = nil
        SPAPPManager.instance().memberModel = nil
        self.headerView.sp_isAuth(isAuth: false)
        sp_getData()
    }
    @objc fileprivate func sp_changeIdent(){
        self.sp_getData()
        sp_sendAllRequest()
    }
    @objc fileprivate func sp_netChange(){
        if SPNetWorkManager.sp_notReachable() {
            
        }else{
             self.sp_sendAllRequest()
        }
    }
}
