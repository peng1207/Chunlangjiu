//
//  SPSetRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPSetRequest : SPAppRequest {
    
    /// 修改登录密码
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调M
    class func sp_getModifyLoginPwd(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_MODIFY_LOGINPWD_URL
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
                    block(SP_Request_Error,"修改密码失败",nil)
                }
            }
        }
    }
    
}
