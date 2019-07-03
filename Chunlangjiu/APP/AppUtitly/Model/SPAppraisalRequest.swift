//
//  SPAppraisalRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/5/5.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPAppraisalRequest {
    /// 提交鉴定
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAuthenticate(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_AUTHENTICATE_URL
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
                    block(SP_Request_Error,"提交鉴定失败",nil)
                }
            }
        }
    }
    /// 获取鉴定师列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getGemmologistList(requestModel:SPRequestModel,complete:SPRequestCompletList?,contenComplete:SPChoiceAppraisalComplete?){
        requestModel.url = SP_GET_GEMMOLOGISTLIST_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray  = [SPAppraisalInfoModel]()
                if errorcode == SP_Request_Code_Success, let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if let l = list , sp_getArrayCount(array: l) > 0 {
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any] {
                                let model =  SPAppraisalInfoModel.sp_deserialize(from: lDic)
                                if let m = model {
                                      dataArray.append(m)
                                }
                            }
                        }
                    }
                    let count = sp_getString(string: dic["count"])
                    let content = sp_getString(string: dic["content"])
                    if let block = contenComplete{
                        block(count,content)
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
    /// 某个鉴定师鉴定列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAppraisalList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_APPRAISALLIST_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray  = [SPAppraisalProductModel]()
                if errorcode == SP_Request_Code_Success, let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if let l = list , sp_getArrayCount(array: l) > 0 {
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any] {
                                let model = SPAppraisalProductModel.sp_deserialize(from: lDic)
                                if let m = model {
                                    dataArray.append(m)
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
    /// 获取卖家鉴定列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAppraisalList(requestModel:SPRequestModel,complete:SPRequestCompletList?,countComplete:SPGetAppraisalCountComplete?){
        requestModel.url = SP_GET_SHOPAPPRAISALLIST_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray  = [SPAppraisalProductModel]()
                if errorcode == SP_Request_Code_Success, let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if let l = list , sp_getArrayCount(array: l) > 0 {
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any] {
                                let model = SPAppraisalProductModel.sp_deserialize(from: lDic)
                                if let m = model {
                                    dataArray.append(m)
                                }
                            }
                        }
                    }
                    var false_count = "0"
                    if let count = Int(sp_getString(string: dic["false_count"])){
                        false_count = String(format: "%d", count)
                    }
                    var true_count = "0"
                    if let count = Int(sp_getString(string: dic["true_count"])){
                        true_count = String(format: "%d", count)
                    }
                    if let countBlock = countComplete{
                        countBlock(true_count,false_count)
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
    /// 获取买家鉴定列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getUserAppraisalList(requestModel:SPRequestModel,complete:SPRequestCompletList?,countComplete:SPGetAppraisalCountComplete?){
        requestModel.url = SP_GET_USERAPPRAISALLIST_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray  = [SPAppraisalProductModel]()
                if errorcode == SP_Request_Code_Success, let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if let l = list , sp_getArrayCount(array: l) > 0 {
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any] {
                                let model = SPAppraisalProductModel.sp_deserialize(from: lDic)
                                if let m = model {
                                    dataArray.append(m)
                                }
                            }
                        }
                    }
                    
                    
                    var false_count = "0"
                    if let count = Int(sp_getString(string: dic["false_count"])){
                        false_count = String(format: "%d", count)
                    }
                    var true_count = "0"
                    if let count = Int(sp_getString(string: dic["true_count"])){
                        true_count = String(format: "%d", count)
                    }
                    if let countBlock = countComplete{
                        countBlock(true_count,false_count)
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
    /// 鉴定详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAppraisalDet(requestModel:SPRequestModel,complete:SPAppraisalDetComplete?){
        requestModel.url = SP_GET_APPRAISALDER_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPAppraisalProductModel?
                if errorcode == SP_Request_Code_Success, let dic = data {
                    model = SPAppraisalProductModel.sp_deserialize(from: dic)
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
    /// 获取鉴定师信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAppraisalInfo(requestModel:SPRequestModel,complete:SPAppraisalInfoComplete?){
        requestModel.url = SP_GET_APPRAISAINFO_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPAppraisalInfoModel?
                if errorcode == SP_Request_Code_Success, let dic = data {
                    model = SPAppraisalInfoModel.sp_deserialize(from: dic)
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
    /// 编辑鉴定师信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getEditAppraisalInfo(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_EDITAPPRAISAINFO_URL
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
                    block(SP_Request_Error,"提交失败",nil)
                }
            }
        }
    }
    /// 获取卖家鉴定师信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getShopAppraisalInfo(requestModel:SPRequestModel,complete:SPAppraisalInfoComplete?){
        requestModel.url = SP_GET_SHOPAPPRAISAINFO_URL
        SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPAppraisalInfoModel?
                if errorcode == SP_Request_Code_Success, let dic = data {
                    model = SPAppraisalInfoModel.sp_deserialize(from: dic)
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
    /// 快速变现
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getAppraisalSell(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_APPRAISASELL_URL
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
                    block(SP_Request_Error,"提交快速变现失败",nil)
                }
            }
        }
    }
}
