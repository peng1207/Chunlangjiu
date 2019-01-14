//
//  SPFansRequest.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2019/1/8.
//  Copyright © 2019 Chunlang. All rights reserved.
//

import Foundation
class SPFansRequest : SPAppRequest {
    
    /// 获取分数s数量和累积佣金的
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getFansNum(requestModel:SPRequestModel,complete:SPFansComplete?){
        requestModel.url = SP_Get_fANS_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var model : SPFansModel?
                if errorcode == SP_Request_Code_Success {
                    model = SPFansModel.sp_deserialize(from: data)
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
    /// 获取粉丝列表
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getFansList(requestModel:SPRequestModel,complete:SPRequestCompletList?){
        requestModel.url = SP_GET_fANS_LIST_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var dataArray : [SPFansListModel] = [SPFansListModel]()
                if errorcode == SP_Request_Code_Success,let dic : [String : Any] = data {
                    let list : [Any]? = dic["list"] as? [Any]
                    if let l = list, sp_getArrayCount(array: l) > 0{
                        for listDic in l {
                            if let lDic : [String : Any] = listDic as? [String : Any]{
                                let model = SPFansListModel.sp_deserialize(from: lDic)
                                if let m = model {
                                    if let createTime : Int = m.createtime {
                                        m.time = SPDateManager.sp_string(to:TimeInterval(exactly: createTime))
                                    }
                                 
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
    /// 获取邀请码
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getInvitationCode(requestModel:SPRequestModel,complete:SPInvitationCodeComplete?){
        requestModel.url = SP_GET_INVITATIONCODE_URL
        sp_unifiedSendRequest(requestModel: requestModel) { (dataJson) in
            if let json = dataJson {
                let errorcode =  sp_getString(string: json[SP_Request_Errorcod_Key])
                let data : [String : Any]? = json[SP_Request_Data_Key] as? [String : Any]
                let msg = sp_getString(string: json[SP_Request_Msg_Key])
                var invitationCode : String = ""
                if errorcode == SP_Request_Code_Success {
                    invitationCode = sp_getString(string: data?["code"])
                }
                if let block = complete {
                    block(errorcode,msg,invitationCode,nil)
                }
            }else{
                if let block = complete {
                    block(SP_Request_Error,"获取邀请码失败","",nil)
                }
            }
        }
    }
    /// 输入邀请码
    ///
    /// - Parameters:
    ///   - requestModel: 请求数据
    ///   - complete: 回调
    class func sp_getInputInvitationCode(requestModel:SPRequestModel,complete:SPRequestDefaultComplete?){
        requestModel.url = SP_GET_INPUT_INVITATIONCODE_URL
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
                    block(SP_Request_Error,"设置失败",nil)
                }
            }
        }
    }
}
