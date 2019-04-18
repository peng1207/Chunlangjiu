//
//  SPPartnerRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/16.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPPartnerRequest {
    
    /// 获取城市合伙人列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getPartnerList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_PARTNER_URL
       SPAppRequest.sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray : [SPPartnerModel] = [SPPartnerModel]()
                if errorcode == SP_Request_Code_Success {
//                    let list : [Any]? = data?["list"] as? [Any]
                     let list : [Any]? = json[SP_Request_Data_Key] as? [Any]
                    if let l = list, sp_getArrayCount(array:l) > 0{
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any] {
                                let model = SPPartnerModel.sp_deserialize(from: lDic)
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
    
}
