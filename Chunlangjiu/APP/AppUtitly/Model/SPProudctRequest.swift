//
//  SPProudctRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/9/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
class SPProudctRequest : SPAppRequest {
    
    
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
                var dataArray = [SPSortRootModel]()
                if sp_isDic(dic: data),errorcode == SP_Request_Code_Success{
                    let category : [Any]? = data?["category"] as? [Any]
                    if sp_isArray(array: category){
                        for categoryDic in category! {
                            let dic : [String :Any]? = categoryDic as? [String:Any]
                            if sp_isDic(dic: dic){
                                let model = SPSortRootModel.sp_deserialize(from: dic)
                                if let  m = model{
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

