//
//  SPThridManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation

let SP_GETUI_APPID  = "ed2XgSCNZUAk7e8LksMce5"
let SP_GETUI_APPSECRET = "XQY0MtICcv7drJesxQn1Y"
let SP_GETUI_APPKEY = "F2cXuwCSvm8AgOkq1gc833"
let SP_GETUI_MASTERSECRET = "eB0eeALJy99Lh1WfTodER3"
let SP_GD_APPKEY = "a54367a33285be53a2c9038199a6d40d"
let SP_UM_APPKEY = "5b3b37cdf43e4852a5000181"
let SP_QQ_APPID = "1106941579"
let SP_QQ_APPKEY = "1TPx8u4i5uQE9Vf3"
let SP_SINA_APPSECRET = "bccdf04dac982831efd444a71588daea"
let SP_SINA_APPKEY = "1325843831"
let SP_WX_APPID = "wx0e1869b241d7234f"
let SP_WX_APPSECRET = "76be7f506fd8a4d51e002dffbbb30f14"
/// 支付结果的通知
let SP_PAYRESULT_NOTIFICATION = "SP_PAYRESULT_NOTIFICATION"
/// 微信支付
let SP_PAY_TYPE_WX = "SP_PAY_TYPE_WX"
/// 支付宝支付
let SP_PAY_TYPE_ALIPAY = "SP_PAY_TYPE_ALIPAY"
/// 支付类型
let SP_PAY_TYPE_KEY = "SP_PAY_TYPE_KEY"
///  支付状态
let SP_PAY_STATUES_KEY = "SP_PAY_STATUES_KEY"
/// 是否客户端的key
let SP_PAY_CLIENT_KEY = "SP_PAY_CLIENT_KEY"
/// 支付成功
let SP_PAY_SUCCESS = "SP_PAY_SUCCESS"
///  支付失败
let SP_PAY_FAILUR = "SP_PAY_FAILUR"
/// 取消支付
let SP_PAY_CANCE = "SP_PAY_CANCE"
class SPThridManager : NSObject,GeTuiSdkDelegate,WXApiDelegate {
    
    private var locationManager : AMapLocationManager = AMapLocationManager()
    private static let thirdManger = SPThridManager()
    private var clientCallback = false
    private var isPingPay : Bool = false
    class func instance() -> SPThridManager {
        return thirdManger
    }
    class func sp_registThridApp(){
        SPShareManager.sp_registApp(platformType: SP_SharePlatformType.umeng, appKey: SP_UM_APPKEY, appSecret: nil, redirectURL: nil)
        SPShareManager.sp_registApp(platformType: SP_SharePlatformType.wechateSession, appKey: SP_WX_APPID, appSecret: SP_WX_APPSECRET, redirectURL: nil)
        SPShareManager.sp_registApp(platformType: SP_SharePlatformType.qq, appKey: SP_QQ_APPID, appSecret: nil, redirectURL: nil)
        SPShareManager.sp_registApp(platformType: SP_SharePlatformType.sina, appKey: SP_SINA_APPKEY, appSecret: SP_SINA_APPSECRET, redirectURL: "http://sns.whalecloud.com/sina2/callback")
        WXApi.registerApp(SP_WX_APPID)
        sp_log(message: "高德key\(SP_GD_APPKEY)")
        AMapServices.shared().apiKey = SP_GD_APPKEY
        GeTuiSdk.start(withAppId: SP_GETUI_APPID, appKey: SP_GETUI_APPKEY, appSecret: SP_GETUI_APPSECRET, delegate: instance())
        SPThridManager.instance().sp_addNotification()
        UMSocialGlobal.shareInstance()?.isUsingHttpsWhenShareContent = false
        UMConfigure.initWithAppkey(SP_UM_APPKEY, channel: nil)
        MobClick.setCrashReportEnabled(true)
        
    }
    
    class func sp_startLocation(){
        SPThridManager.instance().sp_startLocation()
    }
    private func sp_startLocation(){
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.locationTimeout = 2
        self.locationManager.reGeocodeTimeout = 2
        self.locationManager.requestLocation(withReGeocode: true) { (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            sp_log(message: "\(location)----\(reGeocode)")
            if  reGeocode != nil {
                SPAPPManager.instance().locationCity = reGeocode?.city
                SPAPPManager.instance().showCity = reGeocode?.city
            }
            SPAPPManager.instance().locationLatitude = location?.coordinate.latitude
            SPAPPManager.instance().locationlongitude = location?.coordinate.longitude
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: SP_LOCATION_NOTIFICATION), object: nil)
         
        }
    }
    /// 向个推注册token
    ///
    /// - Parameter token: token
    class func register(token:String){
        GeTuiSdk.registerDeviceToken(token)
    }
    class func sp_isInstallWX()->Bool{
       return WXApi.isWXAppInstalled()
    }
    class func sp_isInstallQQ()->Bool{
        return SPShareManager.sp_isInstall(type: SP_SharePlatformType.qq)
    }
    class func sp_beginLogPageView(pageName : String){
        MobClick.beginLogPageView(sp_getString(string: pageName))
        
    }
    class func sp_endLogPageView(pageName : String){
        MobClick.endLogPageView(sp_getString(string: pageName))
        
    }
    func geTuiSdkDidRegisterClient(_ clientId: String) {
        
        SPAPPManager.instance().clientId = clientId
        SPAPPManager.sp_uploadPushToken()
    }
    func geTuiSdkDidReceivePayloadData(_ payloadData: Data!, andTaskId taskId: String!, andMsgId msgId: String!, andOffLine offLine: Bool, fromGtAppId appId: String!) {
        
//        if UIApplication.shared.applicationState ==  UIApplicationState.active {
//            let payloadMsg = sp_getString(string:  String(data: payloadData, encoding: String.Encoding.utf8))
//            //        sp_showTextAlert(tips: payloadMsg)
//            let localNotification = UILocalNotification()
//            localNotification.timeZone = NSTimeZone.default
//            localNotification.fireDate = Date(timeIntervalSinceNow: 5)
//            localNotification.alertBody = payloadMsg
//            if payloadMsg.count == 0 {
//                localNotification.alertBody = "获取的数据为空"
//            }
//            if #available(iOS 8.2, *) {
//                localNotification.alertTitle = "收到个推透传信息"
//            } else {
//                // Fallback on earlier versions
//            }
//            localNotification.userInfo = nil
//            UIApplication.shared.presentLocalNotificationNow(localNotification)
//        }
    }
    class func sp_wxPay(dic:[String:Any]){
        instance().isPingPay = false
       let req = PayReq()
        req.openID = sp_getString(string: dic["appid"])
        req.partnerId = sp_getString(string: dic["partnerid"])
        req.package = sp_getString(string: dic["package"])
        req.nonceStr = sp_getString(string: dic["noncestr"])
        req.sign = sp_getString(string: dic["sign"])
        req.prepayId = sp_getString(string: dic["prepayid"])
        let timestamp = dic["timestamp"]
        if let time = timestamp {
            if let timeStamp =  UInt32(sp_getString(string: time)){
                req.timeStamp = timeStamp
            }
        }
        WXApi.send(req)
    }
    class func sp_aliPay(payOrder:String){
          instance().isPingPay = false
        AlipaySDK.defaultService().payOrder(sp_getString(string: payOrder), fromScheme: "com.chunlangjiu.app") { (data) in
            if sp_isDic(dic: data){
                let payDic : [String :Any] = data as! [String : Any]
                sp_dealApiPay(resutl: sp_getString(string: payDic["resultStatus"]))
            }
        }
        
    }
    class func sp_pingPay(data:Any?,complete:((_ status : String)->Void)? = nil){
        guard let d = data as? NSObject else {
            return
        }
          instance().isPingPay = true
        Pingpp.createPayment(d, appURLScheme: "com.chunlangjiu.app") { (result, error) in
            sp_log(message: "\(result) ---- \(error?.code)")
            var statusString = ""
            if let e = error {
                switch e.code{
                case PingppErrorOption.errCancelled:
                    statusString = SP_PAY_CANCE
                default:
                    statusString = SP_PAY_FAILUR
                }
            }else{
                statusString = SP_PAY_SUCCESS;
            }
            if let block = complete {
                block(statusString)
            }
            sp_showPayResult(payState: statusString)
        }
    }
    
    func onResp(_ resp: BaseResp!) {
        sp_dealWXComplete(resp: resp )
    }
    class func sp_open(url:URL) -> Bool{
        var result = false
        if instance().isPingPay {
            result = Pingpp.handleOpen(url, withCompletion: nil)
            if result == true {
                SPThridManager.instance().clientCallback = true
            }
        }
      
        if !result {
             result = sp_dealApiPay(url: url)
        }
       
        if !result {
             result = sp_dealWX(url: url)
        }
        if !result {
            result =  SPShareManager.sp_handleOpen(url: url)
        }
        
        return result
    }
    private class func sp_dealApiPay(url :URL) ->Bool{
         var result = false
        if sp_getString(string: url.host) == "safepay" {
            SPThridManager.instance().clientCallback = true
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (data) in
                if sp_isDic(dic: data){
                    let payDic : [String :Any] = data as! [String : Any]
                    sp_dealApiPay(resutl: sp_getString(string: payDic["resultStatus"]))
                }
            }
            result = true
        }else if sp_getString(string: url.host) == "platformapi" {
             SPThridManager.instance().clientCallback = true
            AlipaySDK.defaultService().processAuthResult(url) { (data) in
                
            }
            result = true
        }
        return result
    }
    private class func sp_dealApiPay(resutl:String?){
        guard let s = resutl else {
            return
        }
        var payStatus = ""
        if sp_getString(string: s) == "9000" {
            // 支付成功
            payStatus = SP_PAY_SUCCESS
        }else if sp_getString(string: s) == "6001" {
            // 取消支付
            payStatus = SP_PAY_CANCE
        }else{
            // 支付失败
            payStatus = SP_PAY_FAILUR
        }
        sp_sendPayNotification(payType: SP_PAY_TYPE_ALIPAY, payState: payStatus, client: true)
    }
    /// 处理微信支付回调
    ///
    /// - Parameter url: 微信返回数据
    /// - Returns: 是否跳转
    private class func sp_dealWX(url:URL)->Bool{
        // sp_getString(string: url.host) == "pay"
        if sp_getString(string: url.scheme) == SP_WX_APPID  {
            let urlString = "\(sp_getString(string: url.absoluteString))"
           
            if  urlString.contains("pay") {
                SPThridManager.instance().clientCallback = true
                let isSuccess = WXApi.handleOpen(url, delegate: SPThridManager.instance())
                return isSuccess
            }
        }
        return false
    }
    private func sp_dealWXComplete(resp : BaseResp){
        if resp is PayResp {
            var payStatues = "";
            let response : PayResp = resp as! PayResp
            switch response.errCode {
            case WXSuccess.rawValue :
                // 支付成功
                payStatues = SP_PAY_SUCCESS
            case WXErrCodeUserCancel.rawValue :
                payStatues = SP_PAY_CANCE
            default :
                payStatues = SP_PAY_FAILUR
            }
            SPThridManager.sp_sendPayNotification(payType: SP_PAY_TYPE_WX, payState: payStatues, client: true)
            sp_log(message: "支付结果 \(payStatues)")
        }
    }
    /// 发送支付结果的通知
    ///
    /// - Parameters:
    ///   - payType: 支付类型
    ///   - payState: 支付结果
    ///   - client: 是否从客户端返回的
    private class func sp_sendPayNotification(payType:String,payState:String,client :Bool){
        var userInfo = [String:Any]()
        userInfo.updateValue(payType, forKey: SP_PAY_TYPE_KEY)
        userInfo.updateValue(payState, forKey: SP_PAY_STATUES_KEY)
        userInfo.updateValue(client, forKey: SP_PAY_CLIENT_KEY)
        NotificationCenter.default.post(name: NSNotification.Name(SP_PAYRESULT_NOTIFICATION), object: userInfo)
        sp_showPayResult(payState: payState)
    }
    private class func sp_showPayResult(payState :String){
        var msg = ""
        if payState == SP_PAY_SUCCESS {
            msg = "支付成功"
        }else if payState == SP_PAY_CANCE {
            msg = "取消支付"
        }else if payState == SP_PAY_FAILUR{
            msg = "支付失败"
        }
        sp_showTextAlert(tips: msg)
    }
}
// MARK: - notification
extension SPThridManager {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_applicationDidBecomeActive(application:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    @objc fileprivate func sp_applicationDidBecomeActive(application: UIApplication){
        if !self.clientCallback {
            SPThridManager.sp_sendPayNotification(payType: "", payState: "", client: false)
        }else{
            SPThridManager.sp_sendPayNotification(payType: "", payState: "", client: true)
        }
        self.clientCallback = false
    }
}
// MARK: - 事件统计
extension SPThridManager {
    /// 商品搜索条件
    ///
    /// - Parameters:
    ///   - eventId: 搜索类型
    ///   - name: 类型对应的值
    class func sp_search(eventId : String,name : String? = nil){
        if sp_getString(string: name).count > 0  {
             var parm = [String : Any]()
            parm.updateValue(sp_getString(string: name), forKey: "value")
            sp_sendEventID(eventId: sp_getString(string: eventId), attributes: parm)
        }else{
            sp_sendEventID(eventId: sp_getString(string: eventId))
        }
    }
    /// 首页好酒推荐
    ///
    /// - Parameter index: 点击的位置
    class func sp_recommend(index:String){
        sp_sendEventID(eventId: SP_EventID.recommend.rawValue, attributes: ["index":sp_getString(string: index)])
    }
    /// 竞拍
    class func sp_auction(){
        sp_sendEventID(eventId: SP_EventID.auction.rawValue)
    }
    /// 我的
    class func sp_mine(){
        sp_sendEventID(eventId: SP_EventID.mine.rawValue)
    }
    /// 首页
    class func sp_index(){
        sp_sendEventID(eventId: SP_EventID.index.rawValue)
    }
    /// 全部
    class func sp_all(){
        sp_sendEventID(eventId: SP_EventID.all.rawValue)
    }
    /// 购物车
    class func sp_shopCart(){
        sp_sendEventID(eventId: SP_EventID.shopCart.rawValue)
    }
    /// 品牌推荐
    class func sp_brand(){
        sp_sendEventID(eventId: SP_EventID.brand.rawValue)
    }
    /// 首页icon
    class func sp_icon(name:String? = nil){
        if sp_getString(string: name).count > 0 {
            sp_sendEventID(eventId: SP_EventID.icon.rawValue, attributes: ["type":sp_getString(string: name)])
        }else{
             sp_sendEventID(eventId: SP_EventID.icon.rawValue)
        }
       
    }
    /// 广告点击
    class func sp_banner(){
        sp_sendEventID(eventId: SP_EventID.banner.rawValue)
    }
    private class func sp_sendEventID(eventId : String, attributes : [String : Any]? = nil){
        if let dic : [String : Any] = attributes {
            MobClick.event(sp_getString(string: eventId), attributes: dic)
        }else{
            MobClick.event(sp_getString(string: eventId))
        }
        sp_log(message: "传给友盟的事件为\(eventId) =====\(sp_getString(string: attributes))")
    }
    
    class func sp_handleRemoteNotification(userInfo : [NSObject : Any]?){
        if let info = userInfo {
            GeTuiSdk.handleRemoteNotification(info)
        }
    }
    
}
