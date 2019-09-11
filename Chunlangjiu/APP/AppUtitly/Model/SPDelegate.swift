//
//  SPDelegate.swift
//  Chunlangjiu
//
//  Created by chengzong liang on 2018/8/20.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UserNotifications

extension AppDelegate:UNUserNotificationCenterDelegate {
    func registerRemoteNotification (){
        if #available(iOS 10.0, *) {
            let notifiCenter = UNUserNotificationCenter.current()
            notifiCenter.delegate = self
            let types = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
            notifiCenter.requestAuthorization(options: types) { (flag, error) in
                if flag {
                    sp_log(message: "iOS request notification success")
                }else{
                    sp_log(message: "iOS 10 request notification fail")
                }
            }
        } else { //iOS8,iOS9注册通知
            
            let setting = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(setting)
        }
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        let userInfo = response.notification.request.content.userInfo
        sp_log(message: "userInfo10:\(userInfo)")
        SPThridManager.sp_handleRemoteNotification(userInfo: userInfo as [NSObject : Any])
//        sp_showTextAlert(tips: "iOS10点击跳转" + sp_getMsg(userInfo: userInfo as? [String : Any]))
        completionHandler()
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        sp_log(message: "前台收到新消息Active\(notification.request.content.userInfo)")
        completionHandler([.sound,.alert,.badge])
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        sp_log(message: "收到新消息Active\(userInfo)")
        SPThridManager.sp_handleRemoteNotification(userInfo: userInfo)
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
//            sp_showTextAlert(tips: sp_getMsg(userInfo: userInfo as? [String : Any]) + "前台")
        }else{
            // 代表从后台接受消息后进入app
            UIApplication.shared.applicationIconBadgeNumber = 0
//            sp_showTextAlert(tips: "ios10 以下点击跳转" + sp_getMsg(userInfo: userInfo as! [String : Any]))
        }
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        sp_showTextAlert(tips: sp_getMsg(userInfo: userInfo as? [String : Any]))
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        let nsdataStr = NSData.init(data: deviceToken)
//        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        var deviceTokenString = String()
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            deviceTokenString += String(format:"%02x", item&0x000000FF)
        }
        sp_log(message:"deviceToken is \(deviceTokenString)")
//        SPAPPManager.instance().pushToken = datastr
        SPThridManager.register(token: deviceTokenString)
    }
    private func sp_getMsg(userInfo :[String : Any]?)->String{
        if let info = userInfo {
            if let apsDic : [String : Any] = info["aps"] as? [String : Any]{
                let alertMsg = sp_getString(string: apsDic["alert"])
                return alertMsg
            }
        }
        return ""
    }
    
}
