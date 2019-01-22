//
//  SPProductRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPProductRequest : SPAppRequest {
    
    
    /// 获取店铺的平台分类
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlatformCategory(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLATFORMCATEGIRY_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
//                var dataArray = [SPSortRootModel]()
                  var lv3Array : [SPSortLv3Model] = [SPSortLv3Model]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    let category : [Any]? = data?["category"] as? [Any]
                    if sp_isArray(array: category){
                        for categoryDic in category! {
                            let dic : [String :Any]? = categoryDic as? [String:Any]
                            if sp_isDic(dic: dic){
                                let model = SPSortRootModel.sp_deserialize(from: dic)
                                if let  m = model{
                                    if sp_getArrayCount(array: m.lv2) > 0 {
                                        for lv2Model  in m.lv2!{
                                            if sp_getArrayCount(array: lv2Model.lv3) > 0 {
                                                if let array : [SPSortLv3Model] = lv2Model.lv3 {
                                                    lv3Array = lv3Array + array
                                                }
                                            }
                                        }
                                    }
//                                    dataArray.append(m)
                                }
                            }
                        }
                    }
                }
                if let block = complete {
                    block(errorcode,lv3Array,nil,1)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil,0)
                }
            }
        }
    }
    /// 获取店铺分类
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopCart(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_SHOPSORT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPShopCategory]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["category"] as? [Any]
                    if sp_isArray(array: category) {
                        for listDic in category! {
                            if sp_isDic(dic: listDic) {
                                let model = SPShopCategory.sp_deserialize(from: listDic as! [String : Any])
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
    /// 获取平台分类下的品牌
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlatformBrand(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLATFORMBRAND_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPBrandModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["brands"] as? [Any]
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
    /// 获取平台分类下的产地
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlatformPlace(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLATFORMPLACE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPPlaceModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
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
    
    /// 获取平台分类下的香型
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlatformType(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLATFORMTYPE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPTypeModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
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
    /// 获取平台分类下的酒精度
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPlatformAlcohol(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PLATFORMALCOHOL_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var lists = [SPAlcoholDegree]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success {
                    let category : [Any]? = data?["list"] as? [Any]
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
    /// 获取商品详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getProductDet(requestModel:SPRequestModel,complete:SPPorudctDetComplete?){
        requestModel.url = SP_GET_SHOP_PRODUCTDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var detailModel : SPProductModel?
                if sp_isDic(dic: data) , errorcode == SP_Request_Code_Success{
                    if let item : [String : Any] = data?["item"] as? [String : Any]{
                        detailModel = SPProductModel.sp_deserialize(from: item)
                    }
                    
                    
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
    
    /// 编辑商品
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopEditProduct(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
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
    /// 检查用户是否达到最大发布商品的权限
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCheckProduct(requestModel:SPRequestModel,complete:SPCheckProductComplete?){
        requestModel.url = SP_GET_CHECKITEM_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                if let block = complete {
                    block(errorcode,data,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,nil)
                }
            }
        }
    }
}

