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
import CoreTelephony
import Reachability
/// 网络发生状态通知
let SP_NETWORK_NOTIFICATION = "SP_NETWORK_NOTIFICATION"
class SPNetWorkManager : NSObject {
    
    private static let reachManager = SPNetWorkManager()
    private var netWorkStatus : NetworkReachabilityManager.NetworkReachabilityStatus = .reachable(NetworkReachabilityManager.ConnectionType.ethernetOrWiFi)
    private var netWorkOldStatus : NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    private var wwanStatus : CTCellularDataRestrictedState = CTCellularDataRestrictedState.restrictedStateUnknown
    private var domainNameDic : [String : String] = [String : String]()
    private var reachManager : NetworkReachabilityManager!
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
            self.netWorkOldStatus = self.netWorkStatus
            self.netWorkStatus = status
            sp_log(message: "网络状态 \(status)")
            self.sp_sendNetWorckChange()
        }
        // 开始监听网络状态变化
        manager?.startListening()
        self.reachManager = manager
 
        
    }
    func sp_startWwan(){
        if #available(iOS 9.0, *) {
            let cellularData = CTCellularData()
            cellularData.cellularDataRestrictionDidUpdateNotifier = { [weak self](state) in
                self?.wwanStatus = state
                 sp_log(message: "\(state)")
            }
        } else {
            // Fallback on earlier versions
        }
       
    }
    /// 发送网络发生变化通知
    private func sp_sendNetWorckChange(){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SP_NETWORK_NOTIFICATION), object: nil)
    }
    /// 是否没有网络
    ///
    /// - Returns: true 没有网络  false 有网络
    class func sp_notReachable() -> Bool {
        sp_log(message: "\(instance().reachManager.networkReachabilityStatus)")
        if instance().reachManager.isReachable {
            return false
        }
        return true
    }
    /// 是否无网络变成有网络
    ///
    /// - Returns: true 是从无网络变成有网络 false 不是
    class func sp_isNotChangehave()->Bool {
        if instance().netWorkOldStatus == .notReachable {
            if !sp_notReachable() {
                return true
            }
        }
        return false
    }
    /// 是否是wifi网络
    ///
    /// - Returns: true wifi 网络 false 不是wifi网络
    class func sp_isWifi() -> Bool{
        return instance().reachManager.isReachableOnEthernetOrWiFi
    }
    /// 是否移动网络
    ///
    /// - Returns: true 移动网 false 不是移动网络
    class func sp_isWwan() -> Bool{
         return instance().reachManager.isReachableOnWWAN
    }
    /// 判断移动网络是否开启
    ///
    /// - Returns: true 开启移动网络 false 关闭移动网络
    class func sp_isOpenWwan() -> Bool {
        return instance().wwanStatus == .restricted ? false : true
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

