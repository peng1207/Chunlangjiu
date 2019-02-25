//
//  SPOrderRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

class SPOrderRequest  : SPAppRequest {
    
    /// 获取订单列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getOrderList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_ORDERLIST_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var orderList = [SPOrderModel]()
                var total = 0
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let orderDic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPOrderModel.sp_deserialize(from: orderDic)
                                if let m = orderModel {
                                    orderList.append(m)
                                }
                            }
                            
                        }
                    }
                    let pagers : [String : Any]? = data?["pagers"] as? [String:Any]
                    if sp_isDic(dic: pagers){
                        if let t : Int = pagers?["total"] as? Int {
                            total = t
                        }
                    }
                }
                
                if let block = complete {
                    block(errorcode,orderList,nil,total)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getOrderDetaile(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_ORDERDETAILE_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detaileModel : SPOrderDetaileModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    detaileModel = SPOrderDetaileModel.sp_deserialize(from: data)
                   detaileModel?.sp_dealData()
                }
                if let block = complete {
                    block(errorcode,detaileModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取取消原因列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCanceReason(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_ORDERCANCEREASON_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var list : [String]?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    let dataList : [String]? = data?["list"] as? [String]
                    if sp_isArray(array: dataList){
                        list = dataList
                    }
                }
                if let block = complete {
                    block(errorcode,list,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 取消订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCanceOrder(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_CANCEORDER_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"取消订单失败",nil)
                }
            }
        }
    }
    /// 确认收货
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getConfrimOrder(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_ORDERCONFIRM_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"商品签单失败",nil)
                }
            }
        }
    }
    /// 创建支付订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCreatePay(requestModel:SPRequestModel,complete:SPCreateOrderComplete?){
        requestModel.url = SP_GET_CREATEPAYORDER_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var payModel : SPOrderPayModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    payModel = SPOrderPayModel.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,msg,payModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"创建失败",nil,nil)
                }
            }
        }
    }
    /// 获取申请退货退款的理由
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getApplyRefundReason(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_REFUNDAPPLYINFO_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var list :[String]?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    list = data?["reason"] as? [String]
                }
                
                if let block = complete {
                    block(errorcode,list,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 申请退货退款
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getApplyRefund(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_APPLYREFUND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"申请失败",nil)
                }
            }
        }
    }
    /// 评价商品
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getProductRate(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_PRODUCTRATE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"评价商品失败",nil)
                }
            }
        }
    }
    /// 获取申请售后退货列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAfterSalesList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_AFTERSALES_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var orderList = [SPOrderModel]()
                var total = 0
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let orderDic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPOrderModel.sp_deserialize(from: orderDic)
                                if let m = orderModel {
                                    let sku : [String:Any]? = orderDic?["sku"] as? [String : Any]
                                    if sp_isDic(dic: sku){
                                        let productModel = SPOrderItemModel.sp_deserialize(from: sku)
                                        if let p = productModel{
                                            p.num = m.num
                                            m.payment = p.payment
                                            orderModel?.order = [p]
                                        }
                                    }
                                    
                                    orderList.append(m)
                                }
                            }
                            
                        }
                    }
                    let pagers : [String : Any]? = data?["pagers"] as? [String:Any]
                    if sp_isDic(dic: pagers){
                        if let t : Int = pagers?["total"] as? Int {
                            total = t
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,orderList,nil,total)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取申请售后订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAfterSalesDet(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_AFTERSALESDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detaileModel : SPOrderDetaileModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    detaileModel = SPOrderDetaileModel.sp_deserialize(from: data)
                    let order : [String : Any]? =  data?["order"] as? [String : Any]
                    if sp_isDic(dic: order){
                         let itemModel = SPOrderItemModel.sp_deserialize(from: order)
                        if let m = itemModel{
                            detaileModel?.payment = itemModel?.payment
                            detaileModel?.orders = [m]
                        }
                    }
                    detaileModel?.sp_dealData()
                }
                if let block = complete {
                    block(errorcode,detaileModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取商家的订单列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopOrderList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_SHOPORDELIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var orderList = [SPOrderModel]()
                var total = 0
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let orderDic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPOrderModel.sp_deserialize(from: orderDic)
                                if let m = orderModel {
                                    orderList.append(m)
                                }
                            }
                            
                        }
                    }
//                    let pagers : [String : Any]? = data?["pagers"] as? [String:Any]
//                    if sp_isDic(dic: pagers){
                        if let t : Int = data?["count"] as? Int {
                            total = t
                        }
//                    }
                }
                if let block = complete {
                    block(errorcode,orderList,nil,total)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取商家的订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopOrderDet(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_SHOPORDETINFO_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var orderDetaile : SPOrderDetaileModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    orderDetaile = SPOrderDetaileModel.sp_deserialize(from: data)
                    orderDetaile?.orders = orderDetaile?.order
                    orderDetaile?.sp_dealData()
                }
                if let block = complete {
                    block(errorcode,orderDetaile,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取物流列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getLogisticsList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_LOGISITICSLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataList = [SPLogisticsModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let orderDic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPLogisticsModel.sp_deserialize(from: orderDic)
                                if let m = orderModel {
                                    dataList.append(m)
                                }
                            }
                            
                        }
                    }
                }
                
                if let block = complete {
                    block(errorcode,dataList,nil,1)
                }
            }else{
                if let block = complete {
                        block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 提交物流信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getSubmitLogistics(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GER_SENDREFUND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"提交失败",nil)
                }
            }
        }
    }
    /// 删除订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDeleteOrder(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DELETEORDER_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"删除失败",nil)
                }
            }
        }
    }
    /// 获取商家售后订单列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAfterSales(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_SHOPAFTERSALES_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray = [SPOrderModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list!{
                            let orderDic : [String:Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPOrderModel.sp_deserialize(from: orderDic)
                                if let o = orderModel {
                                    let sku : [String:Any]? = orderDic?["sku"] as? [String : Any]
                                    if sp_isDic(dic: sku){
                                        let productModel = SPOrderItemModel.sp_deserialize(from: sku)
                                        if let p = productModel{
                                            p.num = o.num
                                            o.payment = p.payment
                                            orderModel?.order = [p]
                                        }
                                    }
                                    
                                    dataArray.append(o)
                                }
                            }
                        }
                        
                    }
                    
                }
                if let block = complete {
                    block(errorcode,dataArray,nil,1)
                }
            }else{
                if let block = complete {
                   block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 发送商家售后订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAfterSalesDet(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_SHOP_AFTERSALESDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detaileModel : SPOrderDetaileModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    detaileModel = SPOrderDetaileModel.sp_deserialize(from: data)
                    let order : [String : Any]? =  data?["order"] as? [String : Any]
                    if sp_isDic(dic: order){
                        let itemModel = SPOrderItemModel.sp_deserialize(from: order)
                        if let m = itemModel{
                            detaileModel?.payment = itemModel?.payment
                            detaileModel?.orders = [m]
                        }
                    }
                    detaileModel?.sp_dealData()
                }
                if let block = complete {
                    block(errorcode,detaileModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 商家发货
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopDelivery(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_SHOP_DELIVERY_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"发货失败",nil)
                }
            }
        }
    }
    /// 商家 无货 取消订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopCance(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_SHOP_CACNEORDER_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                     block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                     block(SP_Request_Error,"取消订单失败",nil)
                }
            }
        }
    }
    /// 商家售后 同意或拒绝
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAfterSaleCheck(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_SHOP_AFTERSALES_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                   block(SP_Request_Error,"处理失败",nil)
                }
            }
        }
    }
    /// 商家获取取消订单原因
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopReasonList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_SHOP_CANCEREASON_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var list : [String]?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    list = data?["list"] as? [String]
                }
                
                if let block = complete {
                    block(errorcode,list,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取竞拍订单列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuctionOrderList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_SHOP_AUCTIONLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [Any]? = json[SP_Request_Data_Key] as? [Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var list = [SPOrderModel]()
                if sp_isArray(array: data), errorcode == SP_Request_Code_Success{
                    for listDic in data!{
                        if let listDataDic : [String : Any] = listDic as? [String : Any]{
                            let orderModel = SPOrderModel.sp_deserialize(from: listDataDic)
                            if let item : [String : Any] = listDataDic["item"] as? [String : Any]{
                                let itemModel = SPOrderItemModel.sp_deserialize(from:item)
                                itemModel?.pic_path = sp_getString(string: item["image_default_id"])
                                if let shop_id : Int = item["shop_id"] as? Int {
                                    orderModel?.shop_id = shop_id
                                }
                                
                                if let auction : [String : Any] = listDataDic["auction"] as? [String : Any]{
                                    itemModel?.starting_price = sp_getString(string: auction["starting_price"])
                                    itemModel?.max_price = sp_getString(string: auction["max_price"])
                                    itemModel?.auctionitem_id = sp_getString(string: auction["auctionitem_id"])
                                    itemModel?.auction_status = sp_getString(string: auction["auction_status"])
                                    orderModel?.starting_price = itemModel?.starting_price
                                    orderModel?.max_price = itemModel?.max_price
                                    orderModel?.auctionitem_id = itemModel?.auctionitem_id
                                    orderModel?.original_bid = sp_getString(string: auction["original_bid"])
                                    orderModel?.auction_status = itemModel?.auction_status
                                }
                                
                                orderModel?.shopname = sp_getString(string: item["shopname"])
                                orderModel?.shop_logo = sp_getString(string: item["shop_logo"])
                                orderModel?.totalItem = "1"
                                orderModel?.payment = sp_getString(string: listDataDic["cur_money"])
                                if let model = itemModel{
                                    orderModel?.order = [model]
                                }
                            }
                            if let o = orderModel {
                                list.append(o)
                            }
                        }
                    }
                }
                
                if let block = complete {
                        block(errorcode,list,nil,1)
                }
            }else{
                if let block = complete {
                        block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取竞拍订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuctionOrderDet(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_AUCTIONCONFIRM_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detailModel : SPOrderDetaileModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    detailModel = SPOrderDetaileModel.sp_deserialize(from: data)
                    if let default_address : [String : Any] = data?["default_address"] as? [String : Any]{
                        detailModel?.receiver_address = sp_getString(string: default_address["addr"])
                        detailModel?.receiver_name = sp_getString(string: default_address["name"])
                        detailModel?.receiver_mobile = sp_getString(string: default_address["mobile"])
                        detailModel?.receiver_state = sp_getString(string: default_address["area"])
                    }
                    
                    if let payments : [String : Any] = data?["payments"] as? [String : Any]{
                        detailModel?.payment_id = sp_getString(string: payments["payment_id"])
                        detailModel?.created_time = sp_getString(string: payments["created_time"])
                        detailModel?.pay_time = sp_getString(string: payments["payed_time"])
                        detailModel?.pay_name = sp_getString(string: payments["pay_name"])
                        detailModel?.type = sp_getString(string: payments["type"])
                        detailModel?.modified_time = sp_getString(string: payments["modified_time"])
                        detailModel?.tid = Int(sp_getString(string: detailModel?.payment_id))
                        detailModel?.payment = sp_getString(string: payments["cur_money"])
                    }
                    
                    
                    let itemModel = SPOrderItemModel.sp_deserialize(from: data)
                    
                    if let model = itemModel {
                        
                        if let auction :[String : Any] = data?["auction"] as? [String : Any] {
                            detailModel?.auctionitem_id = sp_getString(string: auction["auctionitem_id"])
                            detailModel?.max_price = sp_getString(string: auction["max_price"])
                            detailModel?.is_pay = sp_getString(string: auction["is_pay"])
                            detailModel?.pledge = sp_getString(string: auction["pledge"])
                            detailModel?.starting_price = sp_getString(string: auction["starting_price"])
                            detailModel?.auction_begin_time = sp_getString(string: auction["begin_time"])
                            detailModel?.auction_end_time = sp_getString(string: auction["end_time"])
                            detailModel?.status = sp_getString(string: auction["status"])
                            detailModel?.auction_status = sp_getString(string: auction["auction_status"])
                            if sp_getString(string: detailModel?.status_desc).count <= 0 {
                                detailModel?.status_desc = sp_getString(string: auction["status_desc"])
                            }
                            model.auctionitem_id = detailModel?.auctionitem_id
                            model.max_price = detailModel?.max_price
                            model.is_pay = detailModel?.is_pay
                            model.pledge = detailModel?.pledge
                            model.starting_price = detailModel?.starting_price
                            model.original_bid = detailModel?.original_bid
                            model.auction_status = detailModel?.auction_status
                        }
                        model.pic_path = sp_getString(string: data?["image_default_id"])
                        
                        detailModel?.orders = [model]
                       
                    }
                    if sp_getString(string: detailModel?.type).count <= 0 {
                        detailModel?.type = SP_AUCTION
                    }
                    detailModel?.sp_dealData()
                }
                if let block = complete {
                        block(errorcode,detailModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取取消订单列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCanceList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GER_CANCELIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var orderList = [SPOrderModel]()
                var total = 0
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let orderDic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: orderDic){
                                let orderModel = SPOrderModel.sp_deserialize(from: orderDic)
                                if let m = orderModel {
                                    orderList.append(m)
                                }
                            }
                            
                        }
                    }
                    let pagers : [String : Any]? = data?["pagers"] as? [String:Any]
                    if sp_isDic(dic: pagers){
                        if let t : Int = pagers?["total"] as? Int {
                            total = t
                        }
                    }
                }
                
                if let block = complete {
                    block(errorcode,orderList,nil,total)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取d取消订单详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCanceDet(requestModel:SPRequestModel,complete:SPOrderDetaileComplete?){
        requestModel.url = SP_GET_CANCEDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detaileModel : SPOrderDetaileModel?
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    detaileModel = SPOrderDetaileModel.sp_deserialize(from: data)
                    detaileModel?.sp_dealData()
                }
                if let block = complete {
                    block(errorcode,detaileModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 处理待发货申请退款
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCheckCance(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_CANCECHECK_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"提交失败",nil)
                }
            }
        }
    }
}
