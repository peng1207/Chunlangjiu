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
        completionHandler()
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        sp_log(message: "收到新消息Active\(userInfo)")
        if application.applicationState == UIApplicationState.active {
            // 代表从前台接受消息app
        }else{
            // 代表从后台接受消息后进入app
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        completionHandler(.newData)
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let nsdataStr = NSData.init(data: deviceToken)
        let datastr = nsdataStr.description.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "").replacingOccurrences(of: " ", with: "")
        sp_log(message:"deviceToken is \(datastr)")
        SPAPPManager.instance().pushToken = datastr
        SPThridManager.register(token: datastr)
    }
}
