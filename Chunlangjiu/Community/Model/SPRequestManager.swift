//
//  SPRequestManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import Alamofire
// 封装请求类 减少跟第三方接触
enum SP_HttpMethod {
    case get
    case post
    case head
    case put
}

enum SP_ResponseFormat {
    case json
    case data
    case string
}
typealias SPRequestBlock = (_ data : Any? ,_ error: Error?) -> Void

class SPRequestManager {
    static  fileprivate var requestCacheArr = [DataRequest]()
    
    public static let netManager : SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.timeoutIntervalForRequest = 30
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
//    static func sp_getSessionManager()->SessionManager{
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
//        return SessionManager(configuration: configuration)
//    }
    
    class func sp_get(requestModel : SPRequestModel,requestBlock : SPRequestBlock?) {
        guard let url = requestModel.url else {
            sp_log(message: "链接为空 不发送请求")
            if  let block = requestBlock {
                block(nil,nil)
            }
            return
        }
        if SPNetWorkManager.sp_notReachable() {
            sp_log(message: "没有网络 不发送请求")
            if  let block = requestBlock {
                block(nil,nil)
            }
            return
        }
        guard let requestUrl = URL(string: url) else {
            sp_log(message: "连接获取失败 不发送请求")
            if  let block = requestBlock {
                block(nil,nil)
            }
            return
        }
        sp_log(message: "发送请求数据")
        var httpMethod : HTTPMethod = .post
        switch requestModel.httpMethod {
        case .get:
            httpMethod = .get
        case .post:
            httpMethod = .post
        case .head :
            httpMethod = .head
        case .put :
            httpMethod = .put
        }
       
        let dataRequest =  netManager.request(requestUrl, method: httpMethod, parameters: requestModel.parm, encoding: JSONEncoding.default, headers: nil)
        // 忽略本地缓存，重新获取，防止没更新json文件
        //        SessionManager.default.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        //        SessionManager.default.session.configuration.timeoutIntervalForRequest = 30
//        let dataRequest = request(requestUrl, method: httpMethod, parameters: requestModel.parm, encoding: JSONEncoding.default, headers: nil)
     
        requestModel.isRequest = true
        switch requestModel.reponseFormt {
        case .json:
            dataRequest.responseJSON { (dataResponse : DataResponse) in
                sp_requestSuccess(dataResponse: dataResponse, requestModel: requestModel, requestBlock: requestBlock)
            }
        case .data:
            dataRequest.responseData { (dataResponse:DataResponse) in
               
            }
        case .string:
            dataRequest.responseString { (dataResponse : DataResponse) in
               
            }
        }
    }
    class func  sp_upload(requestModel:SPRequestModel,requestBlock : SPRequestBlock?){
        guard let url = requestModel.url else {
            return
        }
//        let headers = ["content-type":"multipart/form-data"]
        Alamofire.upload(multipartFormData: { (formData) in
            for (key,value) in requestModel.parm! {
                let parmData = sp_getString(string: value).data(using: String.Encoding.utf8)
                if let data = parmData{
                    formData.append(data, withName: sp_getString(string: key))
                }
            }
            for i in 0..<sp_getArrayCount(array: requestModel.data){
                formData.append(requestModel.data![i], withName: "image")
            }
            
            
        }, to: URL(string: url)!) { (encodingResult) in
            switch encodingResult {
            case .failure(let encodingError):
                if let block = requestBlock {
                    block(nil,encodingError)
                }
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.responseJSON(completionHandler: { (response) in
                    if let block = requestBlock {
                        block(response.result.value,nil)
                    }
                })
            }
        }
       
    }
    
    private class func sp_requestSuccess(dataResponse : DataResponse<Any>,requestModel : SPRequestModel ,requestBlock : SPRequestBlock?){
        requestModel.isRequest = false
        guard let block = requestBlock else {
            return
        }
        block(dataResponse.result.value,dataResponse.error)
    }
    class func sp_removeAllCache(){
        for task in self.requestCacheArr {
            task.cancel()
        }
        self.requestCacheArr.removeAll()
    }
    class func sp_remove(task:DataRequest) {
        
    }
    
}
class SPRequestModel : NSObject {
    /// 请求链接
    var url : String?
    /// 请求参数
    var parm : [String: Any]?
    /// 是否正在请求中
    var isRequest : Bool = false
    var httpMethod : SP_HttpMethod = .post
    var reponseFormt : SP_ResponseFormat = .json
    var data : [Data]?
    var name : String?
    var fileName : [String]?
    var mineType : String?
}

