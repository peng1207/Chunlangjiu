//
//  AppDelegate.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/6/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds);
        self.window?.backgroundColor = UIColor.white;
        SPAPPManager.instance()
        SPAPPManager.sp_registerApp()
        if SPAPPManager.sp_isShowTutorialPage() {
            SPAPPManager.sp_showTutorialPageVC()
        }else{
            SPAPPManager.sp_showMainVC()
        }
        SPRealmTool.configRealm()
        self.window?.makeKeyAndVisible()
        self.registerRemoteNotification()
        SPAPPManager.sp_appVersion()
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.cancelAllLocalNotifications()
//         let enString = SPDes.encrypt(withText: "a123456", key: "chunlang")
//        sp_log(message: "加密后的数据\(sp_getString(string: enString))")
//        let deString = SPDes.decrypt(withText: enString, key: "chunlang")
//        sp_log(message: "解密后的数据 \(sp_getString(string: deString))")
        
        // Override point for customization after application launch.
        return true
    }
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        let result = SPThridManager.sp_open(url: url)
        if result {
            return result
        }
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = SPThridManager.sp_open(url: url)
        if result {
            return result
        }
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
 

}

