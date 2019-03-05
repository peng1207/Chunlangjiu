//
//  SPOrderHandle.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/2.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
typealias SPOrderHandleComplete = (_ isSuccess : Bool)-> Void

class SPOrderHandle : NSObject {
    /// 订单按钮上操作
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - btnIndex: 从右往左按钮点击的位置 从0 开始
    ///   - viewController: 当前控制器
    ///   - complete: 处理完的回调 true 处理成功 false 处理失败
    class func sp_dealOrder(orderModel : SPOrderModel?,btnIndex : Int,viewController : UIViewController?,complete: SPOrderHandleComplete?){
        guard let model  = orderModel else {
            return
        }
        guard let vc = viewController else {
            return
        }
        
        switch model.status {
        case SP_WAIT_BUYER_PAY:
            if btnIndex == 0 {
                if sp_getString(string: model.pay_type) == SPPayType.largePayment.rawValue {
                    
                }else{
                    sp_toPay(orderModel: model, viewController: vc, complete: complete)
                }
            }else{
                sp_canceOrder(orderModel: model, viewController: vc, complete: complete)
            }
        case SP_WAIT_SELLER_SEND_GOODS :
            if SPAPPManager.sp_isBusiness() {
                if btnIndex == 0 {
                    if sp_getString(string: model.cancel_status) == SP_NO_APPLY_CANCEL || sp_getString(string: model.cancel_status) == SP_FAILS{
                         sp_logistics(orderModel: model, viewController: vc, complete: complete)
                    }else if sp_getString(string: model.cancel_status) == SP_CANCE_WAIT_PROCESS{
                        sp_refund(orderModel: model, viewController: vc, complete: complete)
                    }
                   
                }else{
                    if sp_getString(string: model.cancel_status) == SP_CANCE_WAIT_PROCESS{
                        
                    }else{
                        sp_shopCanceReason(order: model, viewController: vc, complete: complete)
                    }
                    
                }
            }else{
                if btnIndex == 0 {
                    sp_canceOrder(orderModel: model, viewController: vc, complete: complete)
                }
            }
        case SP_WAIT_BUYER_CONFIRM_GOODS :
                if btnIndex == 0 {
                    sp_confirmOrder(orderModel: model, viewController: vc, complete: complete)
                }
        case  SP_TRADE_FINISHED :
            if btnIndex == 0 {
                if let isRate = Bool(sp_getString(string: orderModel?.is_buyer_rate)),isRate == true {
                     sp_delete(order: model, viewController: vc, complete: complete)
                }else{
                    let evaulteVC = SPProductEvaluationVC()
                    evaulteVC.orderModel = model
                    vc.navigationController?.pushViewController(evaulteVC, animated: true)
                }
            }else{
                sp_delete(order: model, viewController: vc, complete: complete)
            }
        case SP_STATUS_0:
            if SPAPPManager.sp_isBusiness(){
                if btnIndex == 0 {
                    sp_agreeRefund(orderModel: model, viewController: vc, complete: complete)
                }else if btnIndex == 1 {
                    sp_refuseRefund(orderModel: model, viewController: vc, complete: complete)
                }
            }else{
                if sp_getString(string: orderModel?.type) == SP_AUCTION{
                    if btnIndex == 0 {
                        // 去付定金
                        sp_toPay(orderModel: model, viewController: vc, complete: complete)
                    }else{
                        
                    }
                    
                }else{
                    if btnIndex == 0 {
                        sp_revokeApply(refund: model, viewController: vc, complete: complete)
                    }
                }
                
               
            }
        case SP_STATUS_1:
            if SPAPPManager.sp_isBusiness(){
                if sp_getString(string: model.progress) == SP_PROGRESS_2 , btnIndex == 0 {
                    sp_refund(orderModel: model, viewController: vc, complete: complete)
                }
            }else{
                if sp_getString(string: model.type) == SP_AUCTION {
                    if btnIndex == 0 {
                        sp_log(message: "修改出价")
                        sp_auctionEditPrice(order: model, viewController: vc, complete: complete)
                    }
                }else{
                    if btnIndex == 0{
                        sp_logistics(orderModel: model, viewController: vc, complete: complete)
                    }else{
                        sp_revokeApply(refund: model, viewController: vc, complete: complete)
                    }
                }
              
            }
        case SP_STATUS_2:
            if SPAPPManager.sp_isBusiness(){
                
            }else{
                if sp_getString(string: model.type) == SP_AUCTION{
                    if sp_getString(string: model.trade_ststus) == SP_WAIT_BUYER_PAY {
                         sp_toPay(orderModel: model, viewController: vc, complete: complete)
                    }else if sp_getString(string: model.trade_ststus) == SP_WAIT_BUYER_CONFIRM_GOODS{
                        sp_confirmOrder(orderModel: model, viewController: vc, complete: complete)
                    }
                }else{
                    if btnIndex == 0 {
                        sp_delete(order: model, viewController: vc, complete: complete)
                    }
                }
            }
        case SP_STATUS_3:
            if btnIndex == 0{
                 sp_openTel(text: "400-788-9550")
//                sp_delete(order: model, viewController: vc, complete: complete)
            }
        case SP_TRADE_CLOSED_BY_SYSTEM:
            if btnIndex == 0 {
                sp_delete(order: model, viewController: vc, complete: complete)
            }
        case SP_WAIT_CHECK:
            if SPAPPManager.sp_isBusiness(){
                if btnIndex == 0 {
                    sp_checkCanceAgree(order: model, viewController: vc, complete: complete)
                }else{
                    sp_checkCanceReject(order: model, viewController: vc, complete: complete)
                }
            }
        default:
            sp_log(message: "没有相应的订单状态")
        }
    }
    /// 取消订单
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_canceOrder(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
       
        let alertController = UIAlertController(title: "提示", message: /* sp_getString(string: orderModel.status) == SP_WAIT_SELLER_SEND_GOODS ? "是否申请退款?" :*/"是否取消订单?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.default, handler: { (action) in
            sp_getCanceReason(orderModel: orderModel, viewController: viewController, complete: complete)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    class func sp_getCanceReason(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        let parm = [String:Any]()
        request.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPOrderRequest.sp_getCanceReason(requestModel: request) { (code, list,errorModel, total) in
                sp_hideAnimation(view: nil)
            if code == SP_Request_Code_Success {
                SPCanceReasonView.sp_show(list: list as? [String], complete: { (selectString) in
                    sp_canceRequest(orderModel: orderModel, canceReason: selectString, viewController: viewController, complete: complete)
                })
            }else{
                sp_showTextAlert(tips: "取消订单失败!")
            }
        }
    }
    class func sp_canceRequest(orderModel : SPOrderModel,canceReason:String,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(orderModel.tid, forKey: "tid")
        parm.updateValue(sp_getString(string: canceReason), forKey: "cancel_reason")
        request.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPOrderRequest.sp_getCanceOrder(requestModel: request) { (code, msg, errorModel) in
           sp_hideAnimation(view: nil)
            if code ==  SP_Request_Code_Success{
                sp_showTextAlert(tips: msg.count > 0  ? msg : "取消订单成功")
                sp_dealComplete(isSuccess: true, complete: complete)
            }else{
                sp_showTextAlert(tips: sp_getString(string: msg).count > 0  ? sp_getString(string: msg) : "取消订单失败")
                sp_dealComplete(isSuccess: false, complete: complete)
            }
        }
        
    }
    /// 去支付
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_toPay(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let payManager = SPOrderPayManager()
        payManager.orderModel = orderModel
        payManager.complete = complete
        payManager.sp_payRequest()
    }
    /// 上传凭证
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_toVoucher(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        SPPaymentVoucherView.sp_show(viewController: viewController) { (image) in
            
        }
    }
    
    /// 确认收货
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_confirmOrder(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let alertController = UIAlertController(title: "提示", message: "是否确认已经收到货?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "商品签单", style: UIAlertActionStyle.default, handler: { (action) in
            sp_confirmRequest(orderModel: orderModel, viewController: viewController, complete: complete)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
           viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    /// 确认收货请求
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_confirmRequest(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(orderModel.tid, forKey: "tid")
        request.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPOrderRequest.sp_getConfrimOrder(requestModel: request) { (code, msg, errorModel) in
            sp_hideAnimation(view: nil)
            if code == SP_Request_Code_Success {
                sp_showTextAlert(tips: "商品签单成功")
                sp_dealOrderNotificaton(orderModel: orderModel)
                sp_dealComplete(isSuccess: true, complete: complete)
            }else{
                sp_showTextAlert(tips: sp_getString(string: msg).count > 0 ? sp_getString(string: msg) : "商品签单失败")
                sp_dealComplete(isSuccess: false, complete: complete)
            }
        }
    }
    /// 回调
    private class  func sp_dealComplete(isSuccess : Bool,complete: SPOrderHandleComplete?){
        guard let block = complete else {
            return
        }
        block(isSuccess)
    }
    /// 处理订单处理完成
    ///
    /// - Parameter orderModel: 订单数据
    class func sp_dealOrderNotificaton(orderModel : SPOrderModel?)->Void{
        guard let model = orderModel else {
            return
        }
        switch sp_getString(string: model.status) {
        case SP_WAIT_BUYER_PAY:
            NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_ALL_NOTIFICATION), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_WAIT_SELLER_SEND_GOODS_NOTIFICATION), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_WAIT_BUYER_PAY_NOTIFICATION), object: nil)
        case SP_WAIT_SELLER_SEND_GOODS:
             NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_ALL_NOTIFICATION), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_WAIT_BUYER_CONFIRM_GOODS_NOTIFICATION), object: nil)
             NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_WAIT_SELLER_SEND_GOODS_NOTIFICATION), object: nil)
        case SP_WAIT_BUYER_CONFIRM_GOODS:
            NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_FINISH_NOTIFICATION), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_WAIT_BUYER_CONFIRM_GOODS_NOTIFICATION), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_ALL_NOTIFICATION), object: nil)
        case SP_STATUS_0:
            if SPAPPManager.sp_isBusiness(){
                
            }else{
                if sp_getString(string: model.type) == SP_AUCTION {
                    NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_AUCTIIN_PAY), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_AUCTION_ING_NOTIFICATION), object: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(SP_ORDER_AUCTION_ALL_NOTIFICATION), object: nil)
                }else{
                    
                }
            }
        default:
            sp_log(message: "没有找到")
        }
        
    }
    
    /// 买家统一的上传图片接口
    ///
    /// - Parameters:
    ///   - imageType: 图片类型
    ///   - imageArray: 图片数据
    ///   - complete: 回调 isSuccess 所有图片上传成功 则true 只要有一张上传失败则为fales imageIDs 上传图片的顺序 失败则为空字符串 否则为后台返回的图片链接
    class func sp_uploadImage(imageType:String,imageArray:[UIImage],complete:((_ isSuccess : Bool,_ imageIDs: [String]?)->Void)?)->Void{
        if sp_getArrayCount(array: imageArray) > 0 {
            let group = DispatchGroup() //创建group
            var i = 0
            var selectImage = [String]()
            for _  in imageArray{
                selectImage.append("")
            }
            for image in imageArray {
                let uploadImage = sp_fixOrientation(aImage: image)
                let data = UIImageJPEGRepresentation(uploadImage, 0.5)
                guard let d = data else{
                    continue
                }
                group.enter() // 将以下任务添加进group
                let imageRequestModel = SPRequestModel()
                imageRequestModel.data = [d]
                imageRequestModel.name = "image"
                imageRequestModel.fileName = ["proudct.jpg"]
                imageRequestModel.mineType = "image/jpg"
                var parm = [String:Any]()
                parm.updateValue(imageType, forKey: "image_type")
                parm.updateValue(0, forKey: "image_cat_id")
                parm.updateValue("proudct.jpg", forKey: "image_input_title")
                parm.updateValue("binary", forKey: "upload_type")
                imageRequestModel.parm = parm
                let index = i
                SPAppRequest.sp_getUserUploadImg(requestModel: imageRequestModel) { (code, msg, uploadImageModel, errorModel) in
                    if code == SP_Request_Code_Success, let upload = uploadImageModel{
                        if index < selectImage.count {
                            selectImage[index] = sp_getString(string: upload.url)
                        }
                    }
                    sp_log(message: index)
                    group.leave()
                }
                i = i + 1
            }
            group.notify(queue: .main) {  // group中的所有任务完成后再主线程中调用回调函数，将结果传出去
                sp_log(message: "请求数据成功 \(selectImage)")
                var isSuccess = true
                for select : String in selectImage {
                    if sp_getString(string: select).count == 0 {
                        isSuccess = false
                    }
                }
                if let block = complete {
                    block(isSuccess,selectImage)
                }
            }
        }else{
            if let block = complete {
                block(true,nil)
            }
        }
    }
    /// 发货
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_deliver(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){

    }
    ///  取消发货
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_canceDeliver(orderModel : SPOrderModel,viewController: UIViewController,reason : String,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: orderModel.tid), forKey: "tid")
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        parm.updateValue(sp_getString(string: reason), forKey: "cancel_reason")
        request.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPOrderRequest.sp_getShopCance(requestModel: request) { (code, msg, errorModel) in
            sp_hideAnimation(view: nil)
            if let block = complete {
                block(code == SP_Request_Code_Success ? true : false)
            }
            sp_showTextAlert(tips: msg)
        }
    }
    /// 同意退货退款
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_agreeRefund(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let alertController = UIAlertController(title: "提示", message: "是否同意退货退款?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "同意", style: UIAlertActionStyle.default, handler: { (action) in
            sp_refundRequest(orderModel: orderModel, viewController: viewController, check_result: true, reason: nil, complete: complete)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    /// 拒绝退货退款
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_refuseRefund(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        SPRefuseView.sp_show(title: "拒绝理由", msg: "拒绝理由") { (reason) in
             sp_refundRequest(orderModel: orderModel, viewController: viewController, check_result: false, reason: reason, complete: complete)
        }
      
    }
    class func sp_refundRequest(orderModel : SPOrderModel,viewController: UIViewController,check_result : Bool,reason : String?,refundPrice : String? = nil ,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: orderModel.aftersales_bn), forKey: "aftersales_bn")
        parm.updateValue(check_result ? "true" : "false", forKey: "check_result")
        parm.updateValue(sp_getString(string: reason), forKey: "shop_explanation")
        if sp_getString(string: SP_SHOP_ACCESSTOKEN).count > 0   {
            parm.updateValue(SP_SHOP_ACCESSTOKEN, forKey: "accessToken")
        }
        if sp_getString(string: refundPrice).count > 0  {
            parm.updateValue(sp_getString(string: refundPrice), forKey: "total_price")
        }
        request.parm = parm
        SPOrderRequest.sp_getShopAfterSaleCheck(requestModel: request) { (code, msg, errorModel) in
            if let block = complete {
                sp_showTextAlert(tips: msg)
                block(code == SP_Request_Code_Success ? true : false)
            }
        }
    }
    /// 修改退款金额
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_modifyRefundAmount(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        
    }
    /// 填写物流信息 用户申请退款 或商家发货时填写的物流信息
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_logistics(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        SPOrderLogisticsView.sp_show(orderModel: orderModel, complete: complete)
    }
    /// 撤销申请退货退款
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_revokeApply(refund orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let alertController = UIAlertController(title: "提示", message: "是否撤销申请?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "撤销", style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            viewController.present(alertController, animated: true, completion: nil)
        }
       
    }
    /// 退款金额
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_refund(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        SPRefuseView.sp_show(title: "退款", msg: "退款金额",isNum: true) { (data) in
            sp_refundRequest(orderModel: orderModel, viewController: viewController, check_result: true, reason: nil,refundPrice: data, complete: complete)
        }
    }
    /// 投诉订单
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_complaint(orderModel : SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        
    }
  
    /// 删除订单
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 控制器
    ///   - complete: 回调
    class func sp_delete(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let alertController = UIAlertController(title: "提示", message: "是否删除订单?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "删除", style: UIAlertActionStyle.default, handler: { (action) in
            sp_deleteRequest(order: orderModel, viewController: viewController, complete: complete)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
           viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    /// 删除订单请求
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_deleteRequest(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        var parm = [String:Any]()
        parm.updateValue(orderModel.tid ?? 0, forKey: "tid")
        request.parm = parm
        sp_showAnimation(view: nil, title: nil)
        SPOrderRequest.sp_getDeleteOrder(requestModel: request) { (code, msg, errorModel) in
          sp_hideAnimation(view: nil)
            if let block = complete {
                sp_showTextAlert(tips: msg.count > 0 ? msg : "")
                block(code == SP_Request_Code_Success ? true : false)
                
            }
        }
    }
    /// 商家取消订单原因列表
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_shopCanceReason(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let request = SPRequestModel()
        let parm = [String:Any]()
        request.parm = parm
        
        SPOrderRequest.sp_getShopReasonList(requestModel: request) { (code, list, errorModel, total) in
            if code == SP_Request_Code_Success{
                SPCanceReasonView.sp_show(list: list as? [String], complete: { (selectString) in
                    sp_canceDeliver(orderModel: orderModel, viewController: viewController, reason: sp_getString(string: selectString), complete: complete)
                })
            }else{
                sp_showTextAlert(tips: "取消订单失败")
            }
           
        }
    }
    /// 修改出价
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - complete: 回调
    class func sp_auctionEditPrice(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        
        SPAddPriceView.sp_show(maxPrice: sp_getString(string: orderModel.max_price), originPrice: sp_getString(string: orderModel.original_bid),status: sp_getString(string: orderModel.auction_status)) { (price) in
            sp_auctionEditPriceRequest(order: orderModel, viewController: viewController, price: price, complete: complete)
        }
    }
    /// 修改出价请求
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - price: 价格
    ///   - complete: 回调
    class func sp_auctionEditPriceRequest(order orderModel :SPOrderModel,viewController: UIViewController,price : String,complete: SPOrderHandleComplete?){
        sp_showAnimation(view: nil, title: nil)
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: price), forKey: "price")
        parm.updateValue(sp_getString(string: orderModel.auctionitem_id), forKey: "auctionitem_id")
        request.parm = parm
        SPAppRequest.sp_getAuctionAddPrice(requestModel: request) { (code, msg, errorModel) in
            sp_hideAnimation(view: nil )
            if code == SP_Request_Code_Success{
                sp_showTextAlert(tips: "出价成功")
                sp_dealComplete(isSuccess: true, complete: complete)
                NotificationCenter.default.post(name: NSNotification.Name(SP_EDITPRICEAUCTON_NOTIFICATION), object: nil)
            }else{
                sp_dealComplete(isSuccess: false, complete: complete)
                 sp_showTextAlert(tips: msg)
            }
           
            
        }
    }
    class func sp_checkCanceReject(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        SPRefuseView.sp_show(title: "拒绝理由", msg: "拒绝理由") { (reason) in
            sp_checkCanceRequest(order: orderModel, viewController: viewController, status: "reject", reason: sp_getString(string: reason), complete: complete)
        }
    }
    class func sp_checkCanceAgree(order orderModel :SPOrderModel,viewController: UIViewController,complete: SPOrderHandleComplete?){
        let alertController = UIAlertController(title: "提示", message: "是否同意退款?", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "同意", style: UIAlertActionStyle.default, handler: { (action) in
            sp_checkCanceRequest(order: orderModel, viewController: viewController, status: "agree", reason: "", complete: complete)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        }))
        sp_mainQueue {
            viewController.present(alertController, animated: true, completion: nil)
        }
        
    }
    /// 处理待发货申请退款的请求处理
    ///
    /// - Parameters:
    ///   - orderModel: 订单数据
    ///   - viewController: 当前控制器
    ///   - status: 同意（agree）或拒绝（reject）
    ///   - reason: 拒绝理由
    ///   - complete: 回调
    class func sp_checkCanceRequest(order orderModel :SPOrderModel,viewController: UIViewController,status : String,reason : String,complete: SPOrderHandleComplete?){
        sp_showAnimation(view: nil, title: nil)
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue(sp_getString(string: orderModel.cancel_id), forKey: "cancel_id")
        parm.updateValue(sp_getString(string: status), forKey: "status")
        if sp_getString(string: reason).count > 0  {
             parm.updateValue(sp_getString(string: reason), forKey: "reason")
        }
        request.parm = parm
        SPOrderRequest.sp_getCheckCance(requestModel: request) { (code , msg, errorModel) in
            sp_hideAnimation(view: nil)
            if code  == SP_Request_Code_Success{
                sp_dealComplete(isSuccess: true, complete: complete)
            }else{
                sp_dealComplete(isSuccess: false, complete: complete)
            }
            sp_showTextAlert(tips: msg)
        }
    }
}
