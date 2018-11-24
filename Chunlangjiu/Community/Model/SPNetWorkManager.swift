//
//  SPReachableilityManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/8/4.
//  Copyright © 2018年 Chunlang. All rights reserved.
//
// 处理网络相关的类 （监听网络，保存域名）
import Foundation
import Alamofire
/// 网络发生状态通知
let SP_NETWORK_NOTIFICATION = "SP_NETWORK_NOTIFICATION"
class SPNetWorkManager : NSObject {
    
    private static let reachManager = SPNetWorkManager()
    private var netWorkStatus : NetworkReachabilityManager.NetworkReachabilityStatus = .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi)
    private var domainNameDic : [String : String] = [String : String]()
    
    class func instance() -> SPNetWorkManager{
        return reachManager
    }
    override init() {
        super.init()
    }
    /// 监听网络
    func sp_startMonitor(){
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            self.netWorkStatus = status
            sp_log(message: "网络状态 \(status)")
            self.sp_sendNetWorckChange()
        }
        // 开始监听网络状态变化
        manager?.startListening()
    }
    /// 发送网络发生变化通知
    private func sp_sendNetWorckChange(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SP_NETWORK_NOTIFICATION), object: nil)
    }
    /// 是否没有网络
    ///
    /// - Returns: true 没有网络  false 有网络
    class func sp_notReachable() -> Bool {
        if instance().netWorkStatus == .notReachable || instance().netWorkStatus == .unknown {
            return true
        }
        return false
    }
    /// 设置域名
    ///
    /// - Parameters:
    ///   - domainName: 域名
    ///   - key: 域名对应的key
    func sp_set(domainName : String,key : String){
        domainNameDic.updateValue(domainName, forKey: key)
    }
    /// 获取域名
    ///
    /// - Parameter key: 域名对应的key
    /// - Returns: 域名
    func sp_getDomainName(key:String) -> String {
        let domain = domainNameDic[key]
        if let d = domain {
            return d
        }else{
            return ""
        }
    }
    
}

