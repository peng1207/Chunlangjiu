//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef  Chunlangjiu_Bridging_Header_h
#define   Chunlangjiu_Bridging_Header_h

#import <UMShare/UMShare.h>
// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>
//在桥接文件中引入头文件
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "WXApi.h"
#import "WXApiObject.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
#import <MBProgressHUD/MBProgressHUD.h>
#import <UMCommon/UMCommon.h>
#import <UMAnalytics/MobClick.h>
//#import <UMCommon/UMCommon.h>
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import <AlipaySDK/AlipaySDK.h>
#import <CommonCrypto/CommonCrypto.h>
#import "SPDes.h"
#import "Pingpp.h"
#endif
