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
                
                
                if let block = complete {
                    
                }
            }else{
                if let block = complete {
                    
                }
            }
        }
    }
    
}
