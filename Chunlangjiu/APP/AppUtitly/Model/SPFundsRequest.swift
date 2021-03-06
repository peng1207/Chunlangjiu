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
    /// 提现
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCash(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_FUNDS_CASH_URL
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
                    block(SP_Request_Error,"提现失败",nil)
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
    /// 资金明细列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCapitalDetList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_CAPITALDETLIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var listArray : [SPCapitalDetModel] = [SPCapitalDetModel]()
                if errorcode == SP_Request_Code_Success , let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if sp_getArrayCount(array: list) > 0 ,let array = list{
                        for listDic in array {
                            if let listD : [String : Any] = listDic as? [String : Any] {
                                let model = SPCapitalDetModel.sp_deserialize(from: listD)
                                if let m = model {
                                    if let time : Int = m.logtime {
                                        m.time = SPDateManager.sp_string(to: TimeInterval(time))
                                    }
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
                    block(SP_Request_Error,nil,nil,1)
                }
            }
        }
    }
    /// 获取冻结资金明细列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getFreezeList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_FREEZELIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var listArray : [SPCapitalDetModel] = [SPCapitalDetModel]()
                if errorcode == SP_Request_Code_Success , let dic = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if sp_getArrayCount(array: list) > 0 ,let array = list{
                        for listDic in array {
                            if let listD : [String : Any] = listDic as? [String : Any] {
                                let model = SPCapitalDetModel.sp_deserialize(from: listD)
                                if let m = model {
                                    if let time : Int = m.logtime {
                                        m.time = SPDateManager.sp_string(to: TimeInterval(time))
                                    }
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
                      block(SP_Request_Error,nil,nil,1)
                }
            }
        }
    }
    /// 获取资金明细详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getCapitalDetDet(requestModel:SPRequestModel,complete:SPCapitalDetDetComplete?){
        requestModel.url = SP_GET_CAPITALDETDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPCapitalDetContentModel?
                if errorcode == SP_Request_Code_Success {
                    model = SPCapitalDetContentModel.sp_deserialize(from: data)
                    if let time : Int = model?.time{
                        model?.showTime = SPDateManager.sp_string(to: TimeInterval(time))
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
    /// 获取冻结资金详情
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getFreezeDet(requestModel:SPRequestModel,complete:SPCapitalDetDetComplete?){
        requestModel.url = SP_GET_FREEZEDET_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPCapitalDetContentModel?
                if errorcode == SP_Request_Code_Success {
                    model = SPCapitalDetContentModel.sp_deserialize(from: data)
                    if let time : Int = model?.time{
                        model?.showTime = SPDateManager.sp_string(to: TimeInterval(time))
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
    /// 创建保证金订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDepositCreate(requestModel:SPRequestModel,complete:SPCreateOrderComplete?){
        requestModel.url = SP_GET_DEPOSITCREATE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPOrderPayModel?
                
                if errorcode == SP_Request_Code_Success,sp_isDic(dic: data){
                    model = SPOrderPayModel.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,msg,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"缴纳保证金失败",nil,nil)
                }
            }
        }
    }
    /// 撤销保证金
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDepositRefund(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DEPOSITREFUND_URL
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
                    block(SP_Request_Error,"撤销保证金失败",nil)
                }
            }
        }
    }
    /// 取消申请撤销保证金
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDepositCance(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_DEPOSITCANCEL_URL
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
                     block(SP_Request_Error,"取消撤销申请失败",nil)
                }
            }
        }
    }
    /// 获取保证金相关信息
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getDepostit(requestModel:SPRequestModel,complete:SPDepoistComplete?){
        requestModel.url = SP_GET_DEPOSIT_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPDepositModel?
                if errorcode == SP_Request_Code_Success {
                    model = SPDepositModel.sp_deserialize(from: data)
                }
                if let block = complete {
                    block(errorcode,msg,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"获取数据失败",nil,nil)
                }
            }
        }
    }
    /// 创建充值订单
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getRechargeCreate(requestModel:SPRequestModel,complete:SPCreateOrderComplete?){
        requestModel.url = SP_GET_RECHARGE_CREATE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPOrderPayModel?
                
                if errorcode == SP_Request_Code_Success,sp_isDic(dic: data){
                    model = SPOrderPayModel.sp_deserialize(from: data)
                }
                
                if let block = complete {
                    block(errorcode,msg,model,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"充值失败",nil,nil)
                }
            }
        }
    }
    
}
