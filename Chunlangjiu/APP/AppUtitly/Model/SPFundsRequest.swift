//
//  SPFundsRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPFundsRequest : SPAppRequest {
    /// 获取我的资金
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getMoney(requestModel:SPRequestModel,complete:SPFundsMoneyComplete?){
        requestModel.url = SP_GET_FUNDS_MONEY_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPMoneyModel?
                if errorcode == SP_Request_Code_Success {
                     model = SPMoneyModel.sp_deserialize(from: data)
                }
               
                if let block = complete {
                  block(errorcode,model,msg,nil)
                    
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,"获取我的资金失败",nil)
                }
            }
        }
    }
    /// 获取银行卡列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBankCardList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_BANKCARD_LIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var listArray : [SPBankCardModel] = [SPBankCardModel]()
                if errorcode == SP_Request_Code_Success , let d = data {
                    var list : [Any]? = d["list"] as? [Any]
                    if sp_getArrayCount(array: list) > 0 {
                        for listDic in list!{
                            if sp_isDic(dic: listDic) {
                                if let dic : [String : Any] = listDic as! [String : Any] {
                                    let model = SPBankCardModel.sp_deserialize(from: dic)
                                    if let m = model {
                                        listArray.append(m)
                                    }
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
    /// 删除银行卡
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBankCardDelete(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_BANKCARD_DELETE_URL
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
                    block(SP_Request_Error,"删除银行卡失败",nil)
                }
            }
        }
    }
    /// 添加银行卡
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBankCardAdd(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_BANKCARD_ADD_URL
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
                    block(SP_Request_Error,"添加银行卡失败",nil)
                }
            }
        }
    }
    /// 根据卡号获取对应银行信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getBankCardInfo(requestModel:SPRequestModel,complete:SPFundBankCardComplete?){
        requestModel.url = SP_GET_BANKCARD_INFO_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPBankCardInfoModel?
                if errorcode == SP_Request_Code_Success , let dic = data {
                    model = SPBankCardInfoModel.sp_deserialize(from: dic)
                }
                
                if let block = complete {
                    block(errorcode,model,msg,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,nil,"获取银行信息失败",nil)
                }
            }
        }
    }
}
