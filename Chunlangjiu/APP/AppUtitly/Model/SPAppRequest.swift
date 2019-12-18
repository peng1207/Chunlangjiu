//
//  SPAppRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

let SP_Request_Code_Success = "0"
let SP_Request_Errorcod_Key      = "errorcode"
let SP_Request_Msg_Key           = "msg"
let SP_Request_Data_Key          = "data"
let SP_Request_Error             = "requestError"

class SPAppRequest {
    ///  获取商品分类
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
    class func sp_getIndex(requestModel:SPRequestModel,complete:SPIndexComplete?) -> Void{
        requestModel.url = SP_GET_INDEX_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var indexModel : SPIndexModel? = nil 
                if sp_isDic(dic: data) && errorcode == SP_Request_Code_Success {
                    let categorys : [Any]? = data!["modules"] as? [Any]
                    var bannerList = [SPBannerModel]()
                    var iconList = [SPIndexIconModel]()
                    var categoryList = [SPBrandModel]()
                    if sp_isArray(array: categorys) {
                        for categorydic  in categorys! {
                            if sp_isDic(dic: categorydic) {
                                let dic : [String : Any]  = categorydic as! [String : Any]
                                let params : [String : Any]? = dic["params"] as? [String : Any]
                                let widget = sp_getString(string: dic["widget"])
                                if sp_isDic(dic: params){
                                    let pic : [Any]? = params?["pic"] as? [Any]
                                    if sp_isArray(array: pic){
                                        for picDic in pic! {
                                            if sp_isDic(dic: picDic) {
                                                let picData : [String :Any] = picDic as! [String : Any]
                                                if widget == "slider" {
                                                    let model = SPBannerModel.sp_deserialize(from: picData)
                                                    if let m = model {
                                                        bannerList.append(m)
                                                    }
                                                }else if widget == "icons_nav"{
                                                    let model = SPIndexIconModel.sp_deserialize(from: picData)
                                                    if let m = model {
                                                        if SP_ISSHOW_AUCTION == false{
                                                            if sp_getString(string: m.tag) == "竞拍专区"{
                                                                m.tag = "精品专区"
                                                            }
                                                        }

                                                        iconList.append(m)
                                                    }
                                                }else if widget == "brand"{
                                                    let model = SPBrandModel.sp_deserialize(from: picData)
                                                    if let m = model {
                                                        categoryList.append(m)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if sp_getArrayCount(array: bannerList) > 0 || sp_getArrayCount(array: iconList) > 0 || sp_getArrayCount(array: categoryList) > 0 {
                        indexModel = SPIndexModel()
                        indexModel?.bannerList = bannerList
                        indexModel?.iconList = iconList
                        indexModel?.brandList = categoryList
                    }
                    
                }
                if let block = complete{
                    block(errorcode,indexModel,nil)
                }
            }else{
                if let block  = complete {
                   block(SP_Request_Error,
                         nil,nil)
                }
            }
        }
    }
    ///  获取首页商品数据
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
    class func sp_getIndexGoods(requestModel:SPRequestModel,complete:SPIndexGoodComplete?) -> Void{
        requestModel.url = SP_GET_INDEXGOODS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var listArray : [SPProductModel] = [SPProductModel]()
                var auctionList = [SPProductModel]()
                if sp_isDic(dic: data) && errorcode == SP_Request_Code_Success {
                    let categorys : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: categorys) {
                        for categorydic  in categorys! {
                            if sp_isDic(dic: categorydic) {
                                let dic : [String : Any] = categorydic as! [String : Any]
                                let model =  SPProductModel.sp_deserialize(from: dic)
                                if let m = model  {
                                    listArray.append(m)
                                }
                            }
                        }
                    }
                    let auction_list : [Any]? = data?["auction_list"] as? [Any]
                    if sp_isArray(array: auction_list) {
                        for auction in auction_list!{
                            if let auctionDic : [String : Any] = auction as? [String : Any]{
                                let model = SPProductModel.sp_deserialize(from: auctionDic)
                                if let m = model{
                                    m.isAuction = true
                                    m.sp_getSecond()
                                    if m.second > 0 {
                                         auctionList.append(m)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                if let block = complete{
                    sp_log(message: " 获取商品数据\(listArray)")
                    block(errorcode,auctionList,listArray,nil,1)
                }
            }else{
                if let block  = complete {
                    block(SP_Request_Error,nil,nil,nil,0)
                }
            }
        }
    }
    /// 获取消息数量
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getMsgCount(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_MSGCOUNT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var count = ""
                if errorcode == SP_Request_Code_Success, sp_isDic(dic: data){
                    count = sp_getString(string: data?["count"])
                }
                
                if let block = complete {
                    block(errorcode,errorcode == SP_Request_Code_Success ? count : msg , nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"",nil)
                }
            }
        }
    }
    /// 获取活动数据
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getActivityList(requestModel:SPRequestModel,complete:SPActivityListComplete?){
        requestModel.url = SP_GET_ACTIVITYLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPActivityModel?
                if errorcode == SP_Request_Code_Success {
                    model = SPActivityModel.sp_deserialize(from: data)
                
                    if let m = model {
                        var auctionArray = [SPProductModel]()
                        if sp_getArrayCount(array: m.auction) > 0 {
                            for productModel in m.auction!{
                                productModel.isAuction = true
                                productModel.sp_getSecond()
                                if productModel.second > 0 {
                                    auctionArray.append(productModel)
                                }
                            }
                        }
                        m.auction = auctionArray
                        
                    }
                }
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    ///  获取商品分类
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
    class func sp_getCategory(requestModel:SPRequestModel,complete:SPRequestCompletList?) -> Void{
        requestModel.url = SP_GET_CATEGORY
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
//                var listArray : [SPSortRootModel] = [SPSortRootModel]()
                var lv3Array : [SPSortLv3Model] = [SPSortLv3Model]()
                if sp_isDic(dic: data) && errorcode == SP_Request_Code_Success {
                    let categorys : [Any]? = data!["categorys"] as? [Any]
                    if sp_isArray(array: categorys) {
                        for categorydic  in categorys! {
                            if sp_isDic(dic: categorydic) {
                                let dic : [String : Any] = categorydic as! [String : Any]
                                let model =  SPSortRootModel.sp_deserialize(from: dic)
                                if let m = model  {
                                    if sp_getArrayCount(array: m.lv2) > 0 {
                                        for lv2Model  in m.lv2!{
                                            if sp_getArrayCount(array: lv2Model.lv3) > 0 {
                                                if let array : [SPSortLv3Model] = lv2Model.lv3 {
                                                    lv3Array = lv3Array + array
                                                }
                                            }
                                        }
                                    }
                                    
//                                    listArray.append(m)
                                }
                            }
                        }
//                        let allModel = SPSortLv3Model()
//                        allModel.cat_name = "全部"
//                        lv3Array.insert(allModel, at: 0)
                    }
                }
                if let block = complete{
                    block(errorcode,lv3Array,nil,1)
                }
            }else{
                if let block  = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取商品列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
    class func sp_getProductList(requestModel : SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PRODUCT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var listArray = [SPProductModel]()
                var totalPage = 0
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: list) {
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let productModel = SPProductModel.sp_deserialize(from: dic)
                            if let p = productModel {
                                var auction : [String : Any]? = dic["auction"] as? [String : Any]
                                if sp_isDic(dic: auction){
                                    let auctionData = sp_getString(string: auction?["data"])
                                    if let isAuction = Bool(auctionData), isAuction == false {
                                        p.isAuction = false
                                    }else{
                                        p.auction_status = sp_getString(string: auction?["auction_status"])
                                        if let store : Int = auction?["store"] as? Int {
                                            p.auction_store = store
                                        }else{
                                            p.auction_store = 0
                                        }
                                        if let number : Int = auction?["number"] as? Int {
                                            p.auction_number = number
                                        }else{
                                            p.auction_number = 0
                                        }
                                        p.auction_end_time = sp_getString(string: auction?["end_time"] )
                                        p.auction_begin_time = sp_getString(string: auction?["begin_time"])
                                        p.auction_starting_price = sp_getString(string: auction?["starting_price"])
                                        p.isAuction = true
                                        p.max_price = sp_getString(string: auction?["max_price"])
                                        p.check = sp_getString(string: auction?["check"])
                                        p.auctionitem_id = sp_getString(string: auction?["auctionitem_id"])
                                        p.pledge = sp_getString(string: auction?["pledge"])
                                        p.is_pay = sp_getString(string: auction?["is_pay"])
                                        p.original_bid = sp_getString(string: auction?["original_bid"])
                                        p.sp_getSecond()
                                    }
                                }
                                if SP_ISSHOW_AUCTION {
                                      listArray.append(p)
                                }else{
                                    if p.isAuction == false{
                                        listArray.append(p)
                                    }
                                }

                            }
                        }
                    }
                    let pagers : [String:Any]? = data!["pagers"] as? [String : Any]
                    if sp_isDic(dic: pagers){
                        totalPage = pagers!["total"] as! Int
                    }
                }
                if let block = complete {
                    block(errorcode,listArray,nil,totalPage)
                }
            }else{
                if let block  = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    class func sp_productRecommd(requestModel : SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PRODUCT_RECOMMEND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [Any]? = json[SP_Request_Data_Key] as? [Any]
                var listArray = [SPProductModel]()
                var totalPage = 0
                if sp_getArrayCount(array: data) > 0 , errorcode == SP_Request_Code_Success {
                    totalPage = 1
                    let list : [Any]? =  data
                    if sp_isArray(array: list) {
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let productModel = SPProductModel.sp_deserialize(from: dic)
                            if let p = productModel {
                                var auction : [String : Any]? = dic["auction"] as? [String : Any]
                                if sp_isDic(dic: auction){
                                    let auctionData = sp_getString(string: auction?["data"])
                                    if let isAuction = Bool(auctionData), isAuction == false {
                                        p.isAuction = false
                                    }else{
                                        p.auction_status = sp_getString(string: auction?["auction_status"])
                                        if let store : Int = auction?["store"] as? Int {
                                            p.auction_store = store
                                        }else{
                                            p.auction_store = 0
                                        }
                                        if let number : Int = auction?["number"] as? Int {
                                            p.auction_number = number
                                        }else{
                                            p.auction_number = 0
                                        }
                                        p.auction_end_time = sp_getString(string: auction?["end_time"] )
                                        p.auction_begin_time = sp_getString(string: auction?["begin_time"])
                                        p.auction_starting_price = sp_getString(string: auction?["starting_price"])
                                        p.isAuction = true
                                        p.max_price = sp_getString(string: auction?["max_price"])
                                        p.check = sp_getString(string: auction?["check"])
                                        p.auctionitem_id = sp_getString(string: auction?["auctionitem_id"])
                                        p.pledge = sp_getString(string: auction?["pledge"])
                                        p.is_pay = sp_getString(string: auction?["is_pay"])
                                        p.original_bid = sp_getString(string: auction?["original_bid"])
                                    }
                                }
                                if SP_ISSHOW_AUCTION {
                                    listArray.append(p)
                                }else{
                                    if p.isAuction == false{
                                        listArray.append(p)
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                if let block = complete {
                    block(errorcode,listArray,nil,totalPage)
                }
            }else{
                if let block  = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    
    ///  获取商品详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求model
    ///   - complete: 回调
    class func sp_productDetaile(requestModel:SPRequestModel,complete:SPProductDetaileComplete?){
        requestModel.url = SP_GET_PRODUCT_DETAILE_URL
        self.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var detaileModel : SPProductDetailModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    detaileModel = SPProductDetailModel.sp_deserialize(from: data)
                    let item : [String : Any]? = data?["item"]  as? [String : Any]
                    if sp_isDic(dic: item) {
                        detaileModel?.item?.sku_id = sp_getString(string: item?["default_sku_id"])
                        detaileModel?.item?.desc = sp_getString(string: data?["desc"])
                        var auction : [String:Any]? = item?["auction"] as? [String : Any]
                        if sp_isDic(dic: auction),(auction?.count)! > 0{
                            
                            let auctionData = sp_getString(string: auction?["data"])
                            if let isAuction = Bool(auctionData), isAuction == false {
                                detaileModel?.item?.isAuction = false
                            }else{
                                detaileModel?.item?.auction_status = sp_getString(string: auction?["auction_status"])
                                if let store : Int = auction?["store"] as? Int {
                                    detaileModel?.item?.auction_store = store
                                }else{
                                    detaileModel?.item?.auction_store = 0
                                }
                                if let number : Int = auction?["number"] as? Int {
                                    detaileModel?.item?.auction_number = number
                                }else{
                                    detaileModel?.item?.auction_number = 0
                                }
                                detaileModel?.item?.auction_end_time = sp_getString(string: auction?["end_time"] )
                                detaileModel?.item?.auction_begin_time = sp_getString(string: auction?["begin_time"])
                                detaileModel?.item?.auction_starting_price = sp_getString(string: auction?["starting_price"])
                                detaileModel?.item?.payment_id = sp_getString(string: auction?["payment_id"])
                                detaileModel?.item?.isAuction = true
                                detaileModel?.item?.max_price = sp_getString(string: auction?["max_price"])
                                detaileModel?.item?.check = sp_getString(string: auction?["check"])
                                detaileModel?.item?.auctionitem_id = sp_getString(string: auction?["auctionitem_id"])
                                detaileModel?.item?.pledge = sp_getString(string: auction?["pledge"])
                                detaileModel?.item?.is_pay = sp_getString(string: auction?["is_pay"])
                                detaileModel?.item?.original_bid = sp_getString(string: auction?["original_bid"])
                                detaileModel?.item?.sp_getSecond()
                            }
                            
                           
                        }
                        
                        
//                        let spec : [String : Any]? = item?["spec"] as? [String : Any]
//                        if sp_isDic(dic: spec){
//                            let specSku : [Any]? = spec?["specSku"] as? [Any]
//                            if sp_isArray(array: specSku) {
//                                let sku : [String : Any]?  = specSku?.first  as? [String : Any]
//                                if sp_isDic(dic: sku) {
//                                    detaileModel?.item?.sku_id = sp_getString(string: sku?["sku_id"])
//                                }
//                            }
//                         }
                    }
                    
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
    /// 获取竞拍专区数据
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuctionList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_AUCTIONLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataList = [SPProductModel]()
                var totalPage = 0
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: list) {
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let productModel = SPProductModel.sp_deserialize(from: dic)
                            if let p = productModel {
                                p.sp_getSecond()
                                p.isAuction = true
                                if p.second > 0 {
                                     dataList.append(p)
                                }
                            }
                        }
                    }
                    let pagers : [String:Any]? = data!["pagers"] as? [String : Any]
                    if sp_isDic(dic: pagers){
                        totalPage = pagers!["total"] as! Int
                    }
                }
                if let block = complete {
                        block(errorcode,dataList,nil,totalPage)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 竞拍出价列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuctionPriceList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_AUCTIONGETPRICELIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [Any]? = json[SP_Request_Data_Key] as? [Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataList = [SPAuctionPrice]()
                var totalPage = 0
                if let total : Int = json["total"] as? Int {
                    totalPage = total
                }
                if sp_isArray(array: data),errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data
                    if sp_isArray(array: list) {
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let productModel = SPAuctionPrice.sp_deserialize(from: dic)
                            if let p = productModel {
                                p.showTime = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: p.time)))
                                dataList.append(p)
                            }
                        }
                    }
                    
//                    let pagers : [String:Any]? = data!["pagers"] as? [String : Any]
//                    if sp_isDic(dic: pagers){
//                        totalPage = pagers!["total"] as! Int
//                    }
                }
                
                if let block = complete {
                    block(errorcode,dataList,nil,totalPage)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 竞拍商品出价
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuctionAddPrice(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_AUCTIONADDPRICE_URL
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
                    block(SP_Request_Error,"出价失败",nil)
                }
            }
        }
    }
    /// 获取评价列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
    class func sp_getEvaluate(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_EVALUATE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var listArray = [SPEvaluateModel]()
                var totalPage : Int = 0
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    let list : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                              let dic : [String : Any] = listDic as! [String : Any]
                            let model = SPEvaluateModel.sp_deserialize(from: dic)
                            if let m = model {
                                model?.created_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: model?.created_time)))
                                model?.reply_time = SPDateManager.sp_string(to: TimeInterval(sp_getString(string: model?.reply_time)))
                                listArray.append(m)
                            }
                        }
                    }
                    let pagers : [String:Any]? = data!["pagers"] as? [String : Any]
                    if sp_isDic(dic: pagers){
                        totalPage = pagers!["total"] as! Int
                    }
                }
                
                if let block = complete{
                    block(errorcode,listArray,nil,totalPage)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取店铺数据
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShop(requestModel:SPRequestModel,complete:SPShopComplete?){
        requestModel.url = SP_GET_SHOPDATE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var shopModel : SPShopModel?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    let shopInfo : [String :Any]? = data?["shopInfo"] as? [String:Any]
                    if sp_isDic(dic: shopInfo){
                        shopModel = SPShopModel.sp_deserialize(from: shopInfo)
                        if let time = shopModel?.open_time {
                            if let date = SPDateManager.sp_date(to: TimeInterval(exactly: time)){
                                    shopModel?.openTime = SPDateManager.sp_dateString(to: date)
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,shopModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取筛选
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getFilter(requestModel:SPRequestModel,complete:SPFilterComplete?){
        requestModel.url = SP_GET_FILTER_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var model : SPFilterModel?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    model = SPFilterModel.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 新建地址
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAddAddress(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_ADD_ADDRESS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
//                let data : [String : Any] = json[SP_Request_Data_Key] as! [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"新建地址失败",nil)
                }
            }
        }
    }
    /// 更新地址
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUpdateAddress(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_UPDATE_ADDRESS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"更新地址失败",nil)
                }
            }
        }
    }
    /// 删除地址
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDeleteAddress(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DELETE_ADDRESS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                
                 let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"删除地址失败",nil)
                }
            }
        }
    }
    /// 设置默认地址
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDefaultAddress(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DEFAULT_ADDRESS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"设置默认地址失败",nil)
                }
            }
        }
    }
    /// 发送验证码
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getSendSms(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_SENDSMS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"发送验证码失败",nil)
                }
            }
        }
    }
    /// 登录
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getLogin(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_LONGIN_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                 let msg = sp_getString(string: json[SP_Request_Msg_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                if sp_isDic(dic: data) ,errorcode == SP_Request_Code_Success{
                    let userModel = SPUserModel.sp_deserialize(from: data)
                    SPAPPManager.instance().userModel = userModel
//                    NotificationCenter.default.post(name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
                }
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"登录失败",nil)
                }
            }
        }
    }
    /// 退出登录
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getLogout(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_LOGOUT_URL
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
                    block(SP_Request_Error,"退出登录失败",nil)
                }
            }
        }
    }
    /// 密码登录
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPWDLogin(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_PWDLOGIN_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                if sp_isDic(dic: data) ,errorcode == SP_Request_Code_Success{
                    let userModel = SPUserModel.sp_deserialize(from: data)
                    SPAPPManager.instance().userModel = userModel
//                    NotificationCenter.default.post(name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
                }
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"登录失败",nil)
                }
            }
        }
    }
    /// 第三方登录
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getThirdLogin(requestModel:SPRequestModel,complete:SPThirdLoginComplete?){
        requestModel.url = SP_GET_THIRDLOGIN_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                let binded = sp_getString(string: data?["binded"])
                if errorcode == SP_Request_Code_Success {
                    if binded == "1"{
                        let userModel = SPUserModel.sp_deserialize(from: data)
                        SPAPPManager.instance().userModel = userModel
                    }
                   
                }
                
                if let block = complete {
                    block(errorcode,binded,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"0","登录失败",nil)
                }
            }
        }
    }
    /// 第三方绑定
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getThirdBind(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_THIRDBIND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if errorcode == SP_Request_Code_Success, sp_isDic(dic: data){
                    let userModel = SPUserModel.sp_deserialize(from: data)
                    SPAPPManager.instance().userModel = userModel
                }
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"绑定失败",nil)
                }
            }
        }
    }
    ///  找回密码
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getForgetPWD(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_FORGETPWD_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
              
                if let block = complete {
                    block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"登录失败",nil)
                }
            }
        }
    }
    /// 获取地址列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAddressList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_ADDRESSLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                var listArray = [SPAddressModel]()
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let model = SPAddressModel.sp_deserialize(from: dic)
                            if let m = model {
                                listArray.append(m)
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,listArray,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取省市区
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getArea(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        let array  = sp_getAreaList()
        if sp_getArrayCount(array: array) > 0 {
            sp_simpleSQueues {
                var dataArray = [SPAreaModel]()
                for listDic in array! {
                    let dic : [String : Any] = listDic as! [String : Any]
                    let model = SPAreaModel.sp_deserialize(from: dic)
                    if let m = model {
                        dataArray.append(m)
                    }
                }
                sp_mainQueue {
                    if let block  = complete{
                        block(SP_Request_Code_Success,dataArray,nil,1)
                    }
                    sp_areaRequest(requestModel: requestModel, complete: complete)
                }
            }
 
        }else{
            sp_areaRequest(requestModel: requestModel, complete: complete)
        }
 
    }
    private class func sp_areaRequest(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_REGION_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                //                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                sp_simpleSQueues {
                    var listArray = [SPAreaModel]()
                    if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                        let list : [Any]? = data!["region"] as? [Any]
                        if sp_isArray(array: list){
                            for listDic in list! {
                                let dic : [String : Any] = listDic as! [String : Any]
                                let model = SPAreaModel.sp_deserialize(from: dic)
                                if let m = model {
                                    listArray.append(m)
                                }
                            }
                            sp_simpleSQueues {
                                sp_saveArea(array: list!)
                            }
                        }
                    }
                    sp_mainQueue {
                        if let block = complete {
                            block(errorcode,listArray,nil,1)
                        }
                    }
                }
                
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取会员中心数据统计
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getMemberCount(requestModel:SPRequestModel,complete:SPMemberCountComplete?){
        requestModel.url = SP_GET_MEMBER_COUNT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
//                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPMineCountModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    model = SPMineCountModel.sp_deserialize(from: data)
                }
                if let block = complete {
                        block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                     block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取会员信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getMemberInfo(requestModel:SPRequestModel,complete:SPMemberInfoComplete?){
        requestModel.url = SP_GET_MEMBER_INFO_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
//                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var memberModel : SPMemberModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    memberModel = SPMemberModel.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,memberModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 更新用户资料
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUpdateInfo(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_UPDATEINFO_URL
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
                    block(SP_Request_Error,"修改失败",nil)
                }
            }
        }
    }
    /// 酒庄分类
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getWinerSort(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_WINERSORT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String:Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var listArray = [SPWinerSortModel]()
                 if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data!["list"] as? [Any]
                   
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let dic : [String : Any]? = listDic as? [String : Any]
                            if sp_isDic(dic: dic){
                                let model = SPWinerSortModel.sp_deserialize(from: dic)
                                if let m = model {
                                    listArray.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,listArray,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取酒庄列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getWinerList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_WINERLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                 var listArray = [SPWinerModel]()
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success {
                    let list : [Any]? = data!["list"] as? [Any]
                    if sp_isArray(array: list){
                        for listDic in list! {
                            let dic : [String : Any] = listDic as! [String : Any]
                            let model = SPWinerModel.sp_deserialize(from: dic)
                            if let m = model {
                                listArray.append(m)
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,listArray,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取酒庄详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getWinerDetaile(requestModel:SPRequestModel,complete:SPWinerDetaileComplete?){
        requestModel.url = SP_GET_WINERDETAILE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detaileModel : SPWinerDetaileModel?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    let detail : [Any]? = data?["detail"] as? [Any]
                    if sp_isArray(array: detail){
                        let detailDic : [String : Any]? = detail?.first as? [String : Any]
                        if sp_isDic(dic: detailDic){
                             detaileModel = SPWinerDetaileModel.sp_deserialize(from: detailDic)
                        }
                    }
                  
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
    /// 添加商品到购物车
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAddProduct(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_ADDPRODUCT_URL
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
                    block(SP_Request_Error,"添加商品失败",nil)
                }
            }
        }
    }
    /// 获取购物车数据
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopCartData(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_GERSHOPCART_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var cartArray = [SPShopModel]()
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    let cartList : [Any]? = data!["cartlist"] as? [Any]
                    if sp_isArray(array: cartList) {
                        for cartDic in cartList! {
                            let shopDic : [String:Any]? = cartDic as? [String :Any]
                            var productArray = [SPProductModel]()
                            if sp_isDic(dic: shopDic){
                                let shopModel = SPShopModel.sp_deserialize(from: shopDic)
                                let promotion_cartitems : [Any]? = shopDic?["promotion_cartitems"] as? [Any]
                                if sp_isArray(array: promotion_cartitems) {
                                    for promotion in promotion_cartitems! {
                                        let promotionDic : [String : Any]? = promotion as? [String :Any]
                                        if sp_isDic(dic: promotionDic) {
                                            let cartitemlist : [Any]? = promotionDic?["cartitemlist"] as?  [Any]
                                            if sp_isArray(array: cartitemlist) {
                                                for cartItem in cartitemlist!{
                                                    let cartItemDic : [String : Any]? = cartItem as? [String : Any]
                                                    if sp_isDic(dic: cartItemDic) {
                                                        let productModel = SPProductModel.sp_deserialize(from: cartItemDic)
                                                        if let p = productModel {
                                                            productArray.append(p)
                                                        }
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                shopModel?.productArray = productArray
                                if sp_getArrayCount(array: shopModel?.productArray) > 0 {
                                    cartArray.append(shopModel!)
                                }
                                
                            }
                        }
                    }

                }
                
                if let block = complete {
                    block(errorcode,cartArray,nil,1)
                }
            }else{
                if let block = complete {
                     block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 删除购物车
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDeleteShopCart(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DELETESHOPCART_URL
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
    /// 更新购物车
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUpdateShopCart(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_UPDATESHOPCART_URL
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
                    block(SP_Request_Error,"更新失败",nil)
                }
            }
        }
    }
    /// 获取购物车数量
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopCartCount(requestModel:SPRequestModel,complete:SPShopCartCountComplete?){
        requestModel.url = SP_GET_SHOPCARTCOUNT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model  : SPShopCarCount?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    model = SPShopCarCount.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取确认订单数据
    ///
    /// - Parameters:
    ///   - reqestModel: 请求数据
    ///   - cpmplete: 回调
    class func sp_getConfirmOrder(reqestModel:SPRequestModel,complete:SPConfirmOrderComplete?){
        reqestModel.url = SP_GET_CONFIRMORDER_URL
        sp_unifiedSendRequest(requestModel: reqestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var confirmOrder : SPConfirmOrderModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    confirmOrder = SPConfirmOrderModel.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,msg,confirmOrder,nil)
                }
            }else{
                if let block = complete {
                   block(SP_Request_Error,"获取数据失败",nil,nil)
                }
            }
        }
        
    }
    /// 获取竞拍确认订单数据
    ///
    /// - Parameters:
    ///   - reqestModel: 请求数据
    ///   - cpmplete: 回调
    class func sp_getAuctionConfirmOrder(reqestModel:SPRequestModel,complete:SPConfirmOrderComplete?){
        reqestModel.url = SP_GET_AUCTIONCONFIRM_URL
        sp_unifiedSendRequest(requestModel: reqestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var confirmOrder : SPConfirmOrderModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    confirmOrder = SPConfirmOrderModel.sp_deserialize(from: data)
                    let shopModel = SPShopModel.sp_deserialize(from: data)
                    shopModel?.shop_name = sp_getString(string: data?["shopname"])
                    shopModel?.shop_logo = sp_getString(string: data?["shoplogo"])
                    let productModel = SPProductModel.sp_deserialize(from: data)
                    let auction : [String : Any]? = data?["auction"] as? [String :Any]
                    
                    if sp_isDic(dic: auction),(auction?.count)! > 0{
                        
                        let auctionData = sp_getString(string: auction?["data"])
                        if let isAuction = Bool(auctionData), isAuction == false {
                            productModel?.isAuction = false
                        }else{
                            productModel?.auction_status = sp_getString(string: auction?["status"])
                            if let store : Int = auction?["store"] as? Int {
                                productModel?.auction_store = store
                            }else{
                                productModel?.auction_store = 0
                            }
                            if let number : Int = auction?["number"] as? Int {
                                productModel?.auction_number = number
                            }else{
                                productModel?.auction_number = 0
                            }
                            productModel?.auction_end_time = sp_getString(string: auction?["end_time"] )
                            productModel?.auction_begin_time = sp_getString(string: auction?["begin_time"])
                            productModel?.auction_starting_price = sp_getString(string: auction?["starting_price"])
                            productModel?.isAuction = true
                            productModel?.max_price = sp_getString(string: auction?["max_price"])
                            productModel?.check = sp_getString(string: auction?["check"])
                            productModel?.auctionitem_id = sp_getString(string: auction?["auctionitem_id"])
                            productModel?.pledge = sp_getString(string: auction?["pledge"])
                            productModel?.is_pay = sp_getString(string: auction?["is_pay"])
                            productModel?.auction_status = sp_getString(string: auction?["auction_status"])
                        }
                        
                        
                    }
                    confirmOrder?.auctionitem_id = productModel?.auctionitem_id
                    confirmOrder?.pledge = productModel?.pledge
                    shopModel?.confirm_start_price = productModel?.auction_starting_price 
                    shopModel?.confrim_max_price = productModel?.max_price
                    shopModel?.confirm_auction_status = productModel?.auction_status
                    if let model = productModel{
                        shopModel?.productArray = [model]
                    }
                    if let shop = shopModel {
                        confirmOrder?.dataArray = [shop]
                    }
                    
                }
                
                if let block = complete {
                    block(errorcode,msg,confirmOrder,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"获取数据失败",nil,nil)
                }
            }
        }
        
    }
    /// 添加收藏
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAddCollection(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_ADDCOLLECT_URL
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
                    block(SP_Request_Error,"添加收藏失败",nil)
                }
            }
        }
    }
    /// 移除收藏
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getRemoveCollect(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_REMOVECOLLECT_URL
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
                    block(SP_Request_Error,"取消收藏失败",nil)
                }
            }
        }
    }
   
    /// 添加商品
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAddProduct(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_SHOPADDPRODUCT_URL
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
    /// 创建订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCreateOrder(requestModel:SPRequestModel,complete:SPCreateOrderComplete?){
        requestModel.url = SP_GET_CREATEOREDER_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var payOrder : SPOrderPayModel?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    payOrder = SPOrderPayModel.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,msg,payOrder,nil)
                }
            }else{
                if let block = complete {
                block(SP_Request_Error,"提交订单失败",nil,nil)
                }
            }
        }
    }
    /// 创建竞拍订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCreateAuctionOrder(requestModel:SPRequestModel,complete:SPCreateOrderComplete?){
        requestModel.url = SP_GET_AUCTIONCREARE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var payOrder : SPOrderPayModel?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success{
                    payOrder = SPOrderPayModel.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,msg,payOrder,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"提交订单失败",nil,nil)
                }
            }
        }
    }
    /// 根据地址ID获取确认订单金额
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getTotalPrice(requestModel:SPRequestModel,complete:SPConfirmOrderPriceComplete?){
        requestModel.url = SP_GET_TOTALPRICE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var priceModel : SPConfirmOrderPrice?
                if sp_isDic(dic: data), errorcode == SP_Request_Code_Success {
                    var total : [String:Any]? = data?["total"] as? [String : Any]
                    if sp_isDic(dic: total){
                        priceModel = SPConfirmOrderPrice.sp_deserialize(from: total)
                    }
                }
                
                if let block = complete {
                    block(errorcode,msg,priceModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"获取数据失败",nil,nil)
                }
            }
        }
    }
    /// 获取支付列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPayList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        var parm = [String:Any]()
        parm.updateValue("v3", forKey: "v")
        requestModel.parm = parm
 
        requestModel.url = SP_GET_PAYLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var payList = [SPPayModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    let category : [Any]? = data?["list"] as? [Any]
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPPayModel.sp_deserialize(from: listDic as! [String : Any])
                                if let m = model {
                                    if sp_getString(string: m.app_rpc_id) == SPPayType.wxPay.rawValue {
                                        if SPThridManager.sp_isInstallWX() == false{
                                            continue
                                        }
                                    }
                                    payList.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,payList,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取余额的状态
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBalanceStatus(requestModel:SPRequestModel,complete:SPBalanceStatusComplete?){
        requestModel.url = SP_GET_BALANCESTATUS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var balanceStatus : SPBalanceStatus?
                if errorcode == SP_Request_Code_Success {
                    if let dic = data {
                        if dic.count > 0 {
                            balanceStatus = SPBalanceStatus.sp_deserialize(from: dic)
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,balanceStatus,nil)
                    
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 去支付
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getToPay(requestModel:SPRequestModel,complete:SPTopayComplete?){
        requestModel.url = SP_GET_TOPAY_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                if let block = complete{
                    block(json,nil)
                }
            }else{
                if let block = complete {
                    block(nil,nil)
                }
            }
        }
    }
    /// 上传图片
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUploadImage(requestModel:SPRequestModel,complete:SPUploadImageComplete?){
        requestModel.url = SP_GET_SHOPUPLOAD_URL
           let model = sp_dealPublicParm(requestModel: requestModel)
        SPRequestManager.sp_upload(requestModel: model) { (data, error) in
            if sp_isDic(dic: data) ,let json : [String:Any] = data as? [String : Any] {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let dataDic : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var uploadImage : SPUploadImage?
                if sp_isDic(dic: dataDic),errorcode == SP_Request_Code_Success{
                    uploadImage = SPUploadImage.sp_deserialize(from: dataDic)
                }
                
                if let block = complete {
                    block(errorcode,msg,uploadImage,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"上传失败",nil,nil)
                }
            }
        }
        
    }
    /// 买家上传图片
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUserUploadImg(requestModel:SPRequestModel,complete:SPUploadImageComplete?){
        requestModel.url = SP_GET_UPLOADIMG_URL
         let model = sp_dealPublicParm(requestModel: requestModel)
        SPRequestManager.sp_upload(requestModel: model) { (data, error) in
            if sp_isDic(dic: data) ,let json : [String:Any] = data as? [String : Any] {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let dataDic : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var uploadImage : SPUploadImage?
                if sp_isDic(dic: dataDic),errorcode == SP_Request_Code_Success{
                    uploadImage = SPUploadImage.sp_deserialize(from: dataDic)
                }
                
                if let block = complete {
                    block(errorcode,msg,uploadImage,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"上传失败",nil,nil)
                }
            }
        }
    }
    ///  提交推送ID
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPush(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_PUSH_URL
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
    /// 设置头像
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUserImgSet(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_USERHEADIMG_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    
                }
                if let block = complete {
                  block(errorcode,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"上传头像失败",nil)
                }
            }
        }
    }
    ///  实名认证
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuthonYm(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_AUTONYM_URL
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
                    block(SP_Request_Error,"上传实名认证失败",nil)
                }
            }
        }
    }
    /// 个人认证详细信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuthonDet(requestModel:SPRequestModel,complete:SPRealNameAuthComplete?){
        requestModel.url = SP_GET_AUTONYMDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPRealNameAuth?
                if errorcode == SP_Request_Code_Success {
                    model = SPRealNameAuth.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 企业认证
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCompanyAuth(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_COMPANYAUTH_URL
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
                     block(SP_Request_Error,"上传企业认证失败",nil)
                }
            }
        }
    }
    /// 获取企业认证详细信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCompanyAuthDet(requestModel:SPRequestModel,complete:SPCompanyAuthComplete?){
        requestModel.url = SP_GET_COMPANYAUTHDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var companyModel : SPCompanyAuth?
                if errorcode == SP_Request_Code_Success {
                    companyModel = SPCompanyAuth.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,companyModel,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取企业认证状态
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCompanyAuthStatus(requestModel:SPRequestModel,complete:SPCompanyAuthComplete?){
        requestModel.url = SP_GET_COMPANYAUTHSTATUS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPCompanyAuth?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    model = SPCompanyAuth.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取实名认证状态
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getRealNameAuth(requestModel:SPRequestModel,complete:SPRealNameAuthComplete?){
        requestModel.url = SP_GET_REALNAMEAUTHSTATUS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPRealNameAuth?
                if sp_isDic(dic: data) ,errorcode == SP_Request_Code_Success {
                     model = SPRealNameAuth.sp_deserialize(from: data)
                }
                if let block = complete {
                   block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 商品估价
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getValuation(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_VALUATION_URL
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
                    block(SP_Request_Error,"上传估价商品失败",nil)
                }
            }
        }
    }
    /// 获取分类下的品牌
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBrand(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_BRAND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPBrandModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
                    let brand = SPBrandModel()
                    brand.brand_name = "全部"
                    lists.append(brand)
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPBrandModel.sp_deserialize(from: listDic as? [String : Any])
                                if let m = model {
                                    lists.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,lists,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取分类下的产地
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlace(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLACE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPPlaceModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
                    let placeModel = SPPlaceModel()
                    placeModel.area_name = "全部"
                    lists.append(placeModel)
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPPlaceModel.sp_deserialize(from: listDic as? [String : Any])
                                if let m = model {
                                    lists.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,lists,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取分类下的香型
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getType(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_TYPE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPTypeModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
                    let typeModel = SPTypeModel()
                    typeModel.odor_name = "全部"
                    lists.append(typeModel)
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPTypeModel.sp_deserialize(from: listDic as? [String : Any])
                                if let m = model {
                                    lists.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,lists,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取分类下的酒精度
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAlcohol(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_ALCOHOL_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPAlcoholDegree]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
                    let alcoholModel = SPAlcoholDegree()
                    alcoholModel.alcohol_name = "全部"
                    lists.append(alcoholModel)
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPAlcoholDegree.sp_deserialize(from: listDic as? [String : Any])
                                if let m = model {
                                    lists.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,lists,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 更新店铺信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUpdateShop(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_UPDATESHOP_URL
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
                    block(SP_Request_Error,"更新失败",nil)
                }
            }
        }
    }
    /// 获取版本信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAPPVersion(requestModel:SPRequestModel,complete:SPAPPVersionComplete?){
        requestModel.url = SP_GET_APPVERSION_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPUpdateModel? 
                if sp_isDic(dic: data) ,errorcode == SP_Request_Code_Success {
                    model = SPUpdateModel.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,model,nil)
                }
                
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    /// 获取开屏广告
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getOpenAdv(requestModel:SPRequestModel,complete:SPOpenAdvComplete?){
        requestModel.url = SP_GET_INDEX_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPOpenAdvModel?
                if errorcode == SP_Request_Code_Success {
                    if let modules : [Any] = data?["modules"] as? [Any] {
                        if sp_getArrayCount(array: modules) > 0 {
                            if let listDic : [String : Any] =  modules.first as? [String : Any] {
                                model = SPOpenAdvModel.sp_deserialize(from:listDic["params"] as? [String : Any])
                            }
                           
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
    ///  统一的请求入口 处理公共参数
    ///
    /// - Parameters:
    ///   - requestModel: 请求参数
    ///   - complete: 回调
     class func sp_unifiedSendRequest(requestModel : SPRequestModel?,complete:SPRequestJsonBlock? = nil) -> Void {
       let model = sp_dealPublicParm(requestModel: requestModel)
        SPRequestManager.sp_get(requestModel: model) { (data : Any?, error : Error?) in
            sp_simpleSQueues {
                if let json : [String : Any] = data  as? [String : Any]{
                    let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                    sp_log(message: "errorCode is  \(errorcode)")
                    if errorcode == "20001"{
                        // token 有问题
                        SPAPPManager.sp_dealLogout()
                    }
                }
//                sp_log(message: "\(data)")
            }
            if let block = complete {
                block(data as? [String : Any])
            }
        }
    }
    /// 处理公共参数
    ///
    /// - Parameter requestModel: 请求参数model
    /// - Returns: 参数model
    private class func sp_dealPublicParm(requestModel : SPRequestModel?) -> SPRequestModel{
        var  model : SPRequestModel
        if let m = requestModel {
            model = m
        }else{
            model = SPRequestModel()
        }
        
        var parm : [String: Any]
        if  let p = model.parm {
            parm = p
        }else{
            parm = [String: Any]()
        }
        if parm["format"] == nil {
            parm.updateValue("json", forKey: "format")
        }
        if parm["accessToken"] == nil && (SPAPPManager.instance().userModel != nil){
            parm.updateValue(sp_getString(string: SPAPPManager.instance().userModel?.accessToken), forKey: "accessToken")
        }
        if parm["v"] == nil {
            parm.updateValue("v1", forKey: "v")
        }
//        parm.updateValue("ios", forKey: "platform")
        model.parm = parm
        return model
    }
    
}
/// 请求数据返回公共的组装
struct SPResponseData  {
    var code : String!
    var msg : String!
    var totalPage : Int?
    var list : [Any]?
    var data : Any?
    var error : Error?
}

class SPRequestError {
    
}
