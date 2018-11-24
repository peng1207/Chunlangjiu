
//
//  SPShopCartVC.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 购物车
import Foundation
import SnapKit
class SPShopCartVC: SPBaseVC {
    fileprivate var tableView : UITableView!
    lazy fileprivate var btnView : SPShopCartBtnView = {
        let view = SPShopCartBtnView()
        view.backgroundColor = UIColor.white
        view.clickBlock = { [weak self] in
            self?.sp_dealBtnAction()
        }
        view.selectBlock = { [weak self](isSelect) in
            self?.sp_dealBottomBtnSelect(isSelect: isSelect)
        }
        return view
    }()
    fileprivate lazy var editBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "shopcart_edit"), for: UIControlState.normal)
        btn.setImage(UIImage(), for: UIControlState.selected)
        btn.setTitle("完成", for: UIControlState.selected)
        btn.setTitle("", for: UIControlState.normal)
        btn.titleLabel?.font = sp_getFontSize(size: 16)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn.addTarget(self, action: #selector(sp_clickEidtAction), for: UIControlEvents.touchUpInside)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -30)
        return btn
    }()
    fileprivate lazy var loginBtn : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("您还没登录哦!", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.backgroundColor = SPColorForHexString(hex: SP_HexColor.color_b31f3f.rawValue)
        btn.isHidden = true
        btn.sp_cornerRadius(cornerRadius: 20)
        btn.addTarget(self, action: #selector(sp_pushLogin), for: UIControlEvents.touchUpInside)
        return btn
    }()
    fileprivate lazy var noDataTips : UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("购物车空空的", for: UIControlState.normal)
        btn.setTitleColor(SPColorForHexString(hex: SP_HexColor.color_333333.rawValue), for: UIControlState.normal)
        btn.isHidden = true
        return btn
    }()
    fileprivate var dataArray : Array<SPShopModel>? = nil
    fileprivate var isEdit : Bool = false
    fileprivate var deleteCartIDs = [String]()
    fileprivate var selectCartIDs = [String]()
    fileprivate var selectShop = [Int]()
    fileprivate var deleteShop = [Int]()
    fileprivate var allSelect : Bool = false
    fileprivate var totalPrice : String = "0.00"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "购物车"
        self.sp_setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sp_checkIsLogin()
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
        self.tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = SP_SHOPCART_PRODUCT_WIDTH * SP_PRODUCT_SCALE + 10.0
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.sp_headerRefesh {[weak self]()in
            if let edit = self?.isEdit, edit == false{
                 self?.sp_sendRequest()
            }else{
                 self?.tableView.sp_stopHeaderRefesh()
            }
        }
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.btnView)
        self.view.addSubview(self.loginBtn)
        self.view.addSubview(self.noDataTips)
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(customView: self.editBtn)
        self.sp_addConstraint()
    }
    /// 处理有没数据
    override func sp_dealNoData(){
        if sp_getArrayCount(array: self.dataArray) > 0 {
            self.tableView.isHidden = false
            self.btnView.isHidden = false
            self.editBtn.isHidden = false
            self.noDataTips.isHidden = true
        }else{
            self.btnView.isHidden = true
            self.btnView.isHidden = true
            self.editBtn.isHidden = true
            self.noDataTips.isHidden = false
        }
    }
    /// 添加约束
    fileprivate func sp_addConstraint(){
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(self.view).offset(0)
            maker.bottom.equalTo(self.btnView.snp.top).offset(0)
        }
        self.btnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self.view).offset(0)
            maker.height.equalTo(49)
            if #available(iOS 11.0, *) {
                maker.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(0)
            } else {
                 maker.bottom.equalTo(self.view.snp.bottom).offset(0)
            }
        }
        self.loginBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(40)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
        self.noDataTips.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(10)
            maker.right.equalTo(self.view).offset(-10)
            maker.height.equalTo(40)
            maker.centerY.equalTo(self.view.snp.centerY).offset(0)
        }
    }
    deinit {
        
    }
}
extension SPShopCartVC : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sp_getArrayCount(array: self.dataArray)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < sp_getArrayCount(array: self.dataArray) {
            let shopModel = self.dataArray![section]
            return sp_getArrayCount(array: shopModel.productArray)
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shopCartCellId = "shopCartCellId"
        var cell : SPShopCartTableCell? = tableView.dequeueReusableCell(withIdentifier: shopCartCellId) as? SPShopCartTableCell
        if cell == nil {
            cell = SPShopCartTableCell(style: .default, reuseIdentifier: shopCartCellId)
        }
        if indexPath.section < sp_getArrayCount(array: self.dataArray) {
            let shopModel = self.dataArray![indexPath.section]
            if indexPath.row < sp_getArrayCount(array: shopModel.productArray){
                cell?.productModel = shopModel.productArray?[indexPath.row]
                if !self.isEdit {
                    cell?.selectBtn.isSelected = self.selectCartIDs.contains(sp_getString(string: cell?.productModel?.cart_id))
                }else{
                    cell?.selectBtn.isSelected = self.deleteCartIDs.contains(sp_getString(string: cell?.productModel?.cart_id))
                }
            }
            cell?.deleteBlock = { [weak self](model) in
                self?.sp_dealCellDelete(model: model)
            }
            cell?.selectBlock = { [weak self](model,isSelect) in
                self?.sp_dealCellSelect(model: model, isSelect: isSelect)
            }
            cell?.numBlock = { [weak self](model,num) in
                self?.sp_dealCellNum(model: model, num: num)
            }
        }
        
       cell?.numView.isHidden = self.isEdit
        cell?.deleteBtn.isHidden = !self.isEdit
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { (action, indexPath) in
            if indexPath.section < sp_getArrayCount(array: self.dataArray) {
                let shopModel = self.dataArray?[indexPath.section]
                if indexPath.row < sp_getArrayCount(array: shopModel?.productArray) {
                    self.sp_dealCellDelete(model: shopModel?.productArray?[indexPath.row])
                }
            }
        }
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let shopCartHeadID = "shopCartHeadID"
        var headView : SPShopCartHeadView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: shopCartHeadID) as?  SPShopCartHeadView
        if headView == nil {
            headView = SPShopCartHeadView(reuseIdentifier: shopCartHeadID)
        }
        if section < sp_getArrayCount(array: self.dataArray) {
             let shopModel = self.dataArray![section]
            headView?.shopModel = shopModel
            if self.isEdit{
                headView?.selectBtn.isSelected = self.deleteShop.contains(shopModel.shop_id!)
            }else{
                headView?.selectBtn.isSelected = self.selectShop.contains(shopModel.shop_id!)
            }
            headView?.selectBlock = { [weak self](model ,isSelect) in
                self?.sp_dealShopIsSelect(shopModel: model, isSelect: isSelect)
            }
        }
        return headView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
//MARK: - action
extension SPShopCartVC{
    fileprivate func sp_dealBtnAction(){
        if self.editBtn.isSelected {
            if sp_getArrayCount(array: self.deleteCartIDs) > 0 {
                sp_sendDeletqRequest(cart_ids: sp_getString(string:  self.deleteCartIDs.joined(separator: ",")))
            }
        }else{
            if sp_getArrayCount(array: self.selectCartIDs) > 0 {
                 self.sp_sendConfirmOrderRequest()
            }else{
                sp_showTextAlert(tips: "请选择商品")
            }
           
        }
    }
    fileprivate func sp_pushConfirmOrder(){
        let confirmOrder = SPConfirmOrderVC()
        self.navigationController?.pushViewController(confirmOrder, animated: true)
    }
    
    @objc fileprivate func sp_clickEidtAction(){
        self.isEdit = !self.isEdit
        self.editBtn.isSelected = self.isEdit
        self.tableView.reloadData()
        self.btnView.btn.isSelected = self.isEdit
        sp_dealBottomBtnIsSelect()
    }
    /// 检查是否已经登录
    fileprivate func sp_checkIsLogin(){
        let isLogin = SPAPPManager.sp_isLogin(isPush: false)
        self.tableView.isHidden = !isLogin
        self.btnView.isHidden = !isLogin
        self.editBtn.isHidden = !isLogin
        self.noDataTips.isHidden = true
        self.loginBtn.isHidden = isLogin
        if isLogin {
            sp_dealNoData()
            self.sp_sendRequest()
        }
    }
    /// 跳到登录界面
    @objc fileprivate func sp_pushLogin(){
        SPAPPManager.sp_login()
    }
    fileprivate func sp_dealCellDelete(model:SPProductModel?){
        guard let m = model else {
            return
        }
        sp_sendDeletqRequest(cart_ids: sp_getString(string: m.cart_id))
    }
    fileprivate func sp_dealCellSelect(model:SPProductModel?,isSelect :Bool){
        guard let m = model else {
            return
        }
        if self.isEdit {
            if isSelect {
                self.deleteCartIDs.append(sp_getString(string: m.cart_id))
            }else{
                let index = self.deleteCartIDs.index(of: sp_getString(string: m.cart_id))
                if index! < self.deleteCartIDs.count {
                    self.deleteCartIDs.remove(at: index!)
                }
            }
            self.deleteShop.removeAll()
            if sp_getArrayCount(array: self.dataArray) > 0 {
                for shopModel in self.dataArray! {
                    var count = 0
                    for productModel in shopModel.productArray! {
                        if self.deleteCartIDs.contains(sp_getString(string: productModel.cart_id)){
                            count = count + 1
                        }
                    }
                    if count == sp_getArrayCount(array: shopModel.productArray){
                        self.deleteShop.append(shopModel.shop_id!)
                    }
                }
            }
           
            self.sp_dealBottomBtnIsSelect()
            self.tableView.reloadData()
            
        }else{
            var list = [[String:Any]]()
            var parm = [String:Any]()
            parm.updateValue(Int(sp_getString(string: m.cart_id)) ?? 0, forKey: "cart_id")
            parm.updateValue(isSelect ? 1 : 0, forKey: "is_checked")
            parm.updateValue(0, forKey: "selected_promotion")
            parm.updateValue(m.quantity, forKey: "totalQuantity")
            list.append(parm)
            sp_sendUpdateRequest(cart_params: list)
        }
    }
    fileprivate func sp_dealCellNum(model : SPProductModel?,num : String){
        guard let productModel = model else {
            return
        }
        var list = [[String:Any]]()
        var parm = [String:Any]()
        parm.updateValue(Int(sp_getString(string: productModel.cart_id)) ?? 0 , forKey: "cart_id")
        if self.selectCartIDs.contains(sp_getString(string: productModel.cart_id)) {
             parm.updateValue( 1, forKey: "is_checked")
        }else{
             parm.updateValue( 0 , forKey: "is_checked")
        }
        parm.updateValue(0, forKey: "selected_promotion")
        parm.updateValue(Int(num) ?? 0, forKey: "totalQuantity")
        list.append(parm)
        sp_sendUpdateRequest(cart_params: list)
        
        
    }
    /// 出来底部按钮点击事件
    ///
    /// - Parameter isSelect: 是否选中
    fileprivate func sp_dealBottomBtnSelect(isSelect:Bool){
        guard sp_getArrayCount(array: self.dataArray) > 0 else {
            return
        }
        
        if self.isEdit {
            self.deleteCartIDs.removeAll()
            self.deleteShop.removeAll()
            if isSelect {
                for shopModel in self.dataArray! {
                    var selectCount = 0
                    for productModel in shopModel.productArray!{
                        self.deleteCartIDs.append(sp_getString(string: productModel.cart_id))
                        selectCount = selectCount + 1
                    }
                    // 店铺选择
                    self.deleteShop.append(shopModel.shop_id!)
                }
            }
            self.tableView.reloadData()
        }else{
            var list = [[String:Any]]()
            
            for shopModel in self.dataArray! {
                for productModel in shopModel.productArray!{
                    var parm = [String:Any]()
                    parm.updateValue(Int(sp_getString(string: productModel.cart_id)) ?? 0, forKey: "cart_id")
                    parm.updateValue(isSelect ? 1 : 0, forKey: "is_checked")
                    parm.updateValue(0, forKey: "selected_promotion")
                    parm.updateValue(productModel.quantity, forKey: "totalQuantity")
                    list.append(parm)
                }
            }
            sp_sendUpdateRequest(cart_params: list)
        }
    }
    /// 出来底部按钮是否选中
    fileprivate func sp_dealBottomBtnIsSelect(){
        if self.isEdit {
            self.btnView.selectBtn.isSelected = sp_getArrayCount(array: self.deleteShop) == sp_getArrayCount(array: self.dataArray) ? true : false
            self.btnView.priceLabel.text = ""
        }else{
             self.btnView.selectBtn.isSelected = sp_getArrayCount(array: self.selectShop) == sp_getArrayCount(array: self.dataArray) ? true : false
            self.btnView.priceLabel.text = "\(SP_CHINE_MONEY)\(self.totalPrice)"
            
        }
    }
    /// 处理店铺点击选择按钮的
    ///
    /// - Parameters:
    ///   - shopModel: 店铺数据
    ///   - isSelect: 是否没有选择
    fileprivate func sp_dealShopIsSelect(shopModel:SPShopModel?,isSelect : Bool) {
        guard let model = shopModel else {
            return
        }
        if self.isEdit{
            if let shopId = model.shop_id {
                if isSelect {
                    self.deleteShop.append(shopId)
                }else{
                    self.deleteShop.remove(shopId)
                }
            }
           
            for productModel in model.productArray!{
                if self.deleteCartIDs.contains(sp_getString(string: productModel.cart_id)) {
                    self.deleteCartIDs.remove(sp_getString(string: productModel.cart_id))
                }
                if isSelect {
                    self.deleteCartIDs.append(sp_getString(string: productModel.cart_id))
                }
            }
            self.sp_dealBottomBtnIsSelect()
            self.tableView.reloadData()
        } else {
            var list = [[String:Any]]()
            for productModel in model.productArray!{
                var parm = [String:Any]()
                parm.updateValue(Int(sp_getString(string: productModel.cart_id)) ?? 0, forKey: "cart_id")
                parm.updateValue(isSelect ? 1 : 0, forKey: "is_checked")
                parm.updateValue(0, forKey: "selected_promotion")
                parm.updateValue(productModel.quantity, forKey: "totalQuantity")
                list.append(parm)
            }
            sp_sendUpdateRequest(cart_params: list)
        }
    }
  
    
}
extension SPShopCartVC {
    
    /// 发送请求获取购物车数据
    fileprivate func sp_sendRequest(){
        var parm = [String:Any]()
        parm.updateValue("cart", forKey: "mode")
        parm.updateValue("wap", forKey: "platform")
        self.requestModel.parm = parm
        SPAppRequest.sp_getShopCartData(requestModel: self.requestModel) { [weak self ](code, list , errorModel, total) in
            self?.sp_dealRequest(code: code, list: list, errorModel: errorModel, total: total)
        }
    }
    /// 处理获取购物车数据
    ///
    /// - Parameters:
    ///   - code: 状态码
    ///   - list: 数据
    ///   - errorModel: 错误model
    ///   - total: 总数量
    private func sp_dealRequest(code : String,list : Any?,errorModel : SPRequestError?,total:Int){
        if code == SP_Request_Code_Success {
            self.dataArray = list as? Array<SPShopModel>
            self.sp_dealSelectCount()
            self.tableView.reloadData()
        }
        self.sp_dealBottomBtnIsSelect()
        self.sp_dealNoData()
        self.tableView.sp_stopHeaderRefesh()
    }
    fileprivate func sp_dealSelectCount(){
        self.selectCartIDs.removeAll()
        self.selectShop.removeAll()
        var allTotal = 0
        var allSelectTotal = 0
        var total : String = "0.00"
        if sp_getArrayCount(array: self.dataArray) > 0  {
            for shopModel in self.dataArray! {
                var selectCount = 0
                for productModel in shopModel.productArray!{
                    if productModel.is_checked == 1{
                        self.selectCartIDs.append(sp_getString(string: productModel.cart_id))
                        selectCount = selectCount + 1
                        total = sp_add(price: total, addPrice: sp_multiplying(price: sp_getString(string: productModel.showCartPrice), count: sp_getString(string: productModel.quantity)))
                        
                    }
                    allTotal = allTotal + 1
                }
                if selectCount == sp_getArrayCount(array: shopModel.productArray){
                    // 店铺选择
                    self.selectShop.append(shopModel.shop_id!)
                }else{
                    // 店铺没有选择
                }
                allSelectTotal = allSelectTotal + selectCount
            }
        }
       
        if allSelectTotal == allTotal {
            // 全选
            allSelect = true
        }else{
            // 没有全选
            allSelect = true
        }
        totalPrice = total
    }
    
    /// 发送删除请求
    fileprivate func sp_sendDeletqRequest(cart_ids:String){
        let deleteRequestModel = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(sp_getString(string: cart_ids), forKey: "cart_id")
        parm.updateValue("cart", forKey: "mode")
        deleteRequestModel.parm = parm
        sp_showAnimation(view: self.view, title: "删除中")
        SPAppRequest.sp_getDeleteShopCart(requestModel: deleteRequestModel) { [weak self](code, msg, errorModel) in
            sp_hideAnimation(view: self?.view)
            if code == SP_Request_Code_Success {
                self?.sp_dealDeleteSuccess(cart_ids: cart_ids)
            }else{
                self?.sp_dealBottomBtnIsSelect()
                self?.sp_dealNoData()
                sp_showTextAlert(tips: msg)
            }
        }
    }
    /// 处理删除成功时
    ///
    /// - Parameter cart_ids: 删除的ids
    private func sp_dealDeleteSuccess(cart_ids:String){
        self.sp_sendRequest()
    }
    /// 发送更新请求
    fileprivate func sp_sendUpdateRequest(cart_params : [Any]){
        let updateModel = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue("cart", forKey: "mode")
//        parm.updateValue("item", forKey: "obj_type")
        
        let cart_paramsString = sp_arrayValueString(cart_params)
        
//        if sp_getArrayCount(array: cart_params) > 0 {
//            parm.updateValue(cart_params, forKey: "cart_params")
//        }
        parm.updateValue(sp_getString(string: cart_paramsString), forKey: "cart_params")
        
        updateModel.parm = parm
        SPAppRequest.sp_getUpdateShopCart(requestModel: updateModel) { [weak self](code , msg, errorModel) in
            if code == SP_Request_Code_Success{
                self?.sp_sendRequest()
            }else{
                self?.sp_dealBottomBtnIsSelect()
                self?.sp_dealNoData()
                sp_showTextAlert(tips: msg)
            }
        }
    }
    /// 获取确认订单
    fileprivate func sp_sendConfirmOrderRequest(){
        sp_showAnimation(view: self.view, title: nil)
        let confirmOrder = SPRequestModel()
        var parm = [String :Any]()
        parm.updateValue("cart", forKey: "mode")
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
            confirmOrderVC.confirmOrder = confirmOrderModel
            self.navigationController?.pushViewController(confirmOrderVC, animated: true)
        }else{
            sp_showTextAlert(tips: msg)
        }
       
    }
    
    
}
