//
//  SPAPPManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/26.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
private let SP_SAVE_USER_DATA_KEY = "SP_SAVE_USER_DATA_KEY"
private let SP_SAVE_LOCATIONCITY_KEY = "SP_SAVE_LOCATIONCITY_KEY"
private let SP_SAVE_SHOWCITY_KEY = "SP_SAVE_SHOWCITY_KEY"
private let SP_SAVE_LATITUDE_KEY = "SP_SAVE_LATITUDE_KEY"
private let SP_SAVE_LONGITUDE_KEY = "SP_SAVE_LONGITUDE_KEY"
/// 保存 开屏广告
private let SP_SAVE_OPENADV_KEY = "SP_SAVE_OPENADV_KEY"
/// 保存教程页
private let SP_SAVE_TUTORIALPAGE_KEY = "SP_SAVE_TUTORIALPAGE_KEY"
//let SP_SHOP_ACCESSTOKEN = "35b5a32db3a7a1c22243c699b8e59aff18c7f4532875d76012ac3e8e4238abcf"
let SP_SHOP_ACCESSTOKEN = ""

class SPAPPManager : NSObject{
    
    private static let appManager = SPAPPManager()
    var userModel : SPUserModel?{
        didSet{
            sp_saveUserData()
        }
    }
    var memberModel : SPMemberModel? 
    //  获取省市区的回调
    private var areaComplete : SPGetListComplete?
    // 省市区数据
    private var areaList : [SPAreaModel]?
    // 城市数据
    private var cityList : [SPCityGroupModel]?
    private var cityLetterList : [String]?
    // 是否只获取城市数据
    private var isCity : Bool = false
    var locationCity : String? {
        didSet {
            sp_saveUser(data: locationCity, key: SP_SAVE_LOCATIONCITY_KEY)
        }
    }
    var locationLatitude : Double?{
        didSet{
            sp_saveUser(data: locationLatitude, key: SP_SAVE_LATITUDE_KEY)
        }
    }
    var locationlongitude : Double?{
        didSet{
            sp_saveUser(data: locationlongitude, key: SP_SAVE_LONGITUDE_KEY)
        }
    }
    var showCity : String?{
        didSet{
            sp_saveUser(data: showCity, key: SP_SAVE_SHOWCITY_KEY)
        }
    }
    var pushToken: String?
    var clientId : String?
    fileprivate var timer : Timer?
    fileprivate var lastTimeInterval : Int = 0
    fileprivate var areaRequest : Bool = false
    class func instance() -> SPAPPManager{
        return appManager
    }
    override init() {
        super.init()
        sp_getUserData()
        sp_getAllData()
        sp_addNotification()
        sp_startTimer()
    }
    private func sp_getAllData(){
        self.showCity = sp_getString(string: sp_getUser(key: SP_SAVE_SHOWCITY_KEY))
        self.locationCity = sp_getString(string:  sp_getUser(key: SP_SAVE_LOCATIONCITY_KEY))
        self.locationlongitude = Double(sp_getString(string: sp_getUser(key: SP_SAVE_LONGITUDE_KEY)))
        self.locationLatitude = Double(sp_getString(string: sp_getUser(key: SP_SAVE_LATITUDE_KEY)))
    }
    /// 跳到登录界面
    class func sp_login(){
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appdelegate.window?.rootViewController
        if tabbarController is SPMainVC {
            let tabBar : SPMainVC = tabbarController as! SPMainVC
            let nav : UINavigationController? = tabBar.viewControllers![tabBar.selectedIndex] as? UINavigationController
            if nav != nil {
//                nav?.pushViewController(SPPhoneLoginVC(), animated: true)
                nav?.pushViewController(SPLoginMainVC(), animated: true)
            }
        }
    }
    ///清除用户数据
    class func sp_cleanData(){
          SPAPPManager.instance().userModel = nil
    }
    /// 处理退出登录
    class func sp_dealLogout(){
        SPAPPManager.sp_cleanData()
        NotificationCenter.default.post(name: NSNotification.Name(SP_LOGOUT_NOTIFICATION), object: nil)
        
    }
    
    /// 处理登录成功之后的返回
    class func sp_dealLoginPop(){
        let appdelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let tabbarController = appdelegate.window?.rootViewController
        if tabbarController is SPMainVC {
            let tabBar : SPMainVC = tabbarController as! SPMainVC
            let nav : UINavigationController? = tabBar.viewControllers![tabBar.selectedIndex] as? UINavigationController
            if let navVC = nav {
                var vc : UIViewController?
                for tmpVC in navVC.viewControllers {
                    if tmpVC is SPLoginMainVC {
                        break
                    }
                    else if tmpVC is SPPhoneLoginVC {
                        break
                    }
                    vc = tmpVC
                }
                
                navVC.setNavigationBarHidden(false, animated: false)
                if let tmpvc = vc{
                    navVC.popToViewController(tmpvc, animated: true)
                }else{
                    navVC.popToRootViewController(animated: true)
                }
                UIApplication.shared.statusBarStyle = .lightContent
            }
        }
    }
    
    class func sp_change(identity : String){
        guard let userModel = SPAPPManager.instance().userModel else {
            return
        }
        userModel.identity = sp_getString(string: identity)
        SPAPPManager.instance().userModel = userModel
    }
    /// 注册第三方数据
    class func sp_registerApp(){
        SPNetWorkManager.instance().sp_set(domainName: SP_MAIN_DOMAIN_NAME, key: SP_MAIN_DOMAIN_NAME_KEY)
        sp_log(message: "\(SPNetWorkManager.instance().sp_getDomainName(key: SP_MAIN_DOMAIN_NAME_KEY))")
        SPNetWorkManager.instance().sp_startMonitor()
        SPNetWorkManager.instance().sp_startWwan()
        sp_simpleSQueues(queueName: "com.chunlangjiu.registerThridApp") {
            SPThridManager.sp_registThridApp()
            sp_mainQueue {
                  SPThridManager.sp_startLocation()
            }
        }
        instance().sp_sendAreaRequest()
    }
    /// 是否登录
    ///
    /// - Returns: 是否
    class func sp_isLogin(isPush : Bool = true)-> Bool{
        if instance().userModel != nil {
            return true
        }else{
            if isPush {
                 self.sp_login()
            }
        }
        return false
    }
    /// 获取省市区 或获取城市
    ///
    /// - Parameters:
    ///   - isCity: 是否只获取城市
    ///   - complete: 回调
    class func sp_getAreaData(isCity:Bool,complete:SPGetListComplete?){
        guard let block = complete else {
            return
        }
        if isCity && sp_getArrayCount(array: instance().cityList) > 0  {
            block(instance().cityList)
            return
        }
        if !isCity && sp_getArrayCount(array: instance().areaList) > 0 {
            block(instance().areaList)
            return
        }
        instance().isCity = isCity
        instance().areaComplete = complete
        if instance().areaRequest {
            instance().sp_sendAreaRequest()
        }
    }
    /// 获取城市排序字母 这个方法在sp_getAreaData 回调之后获取
    ///
    /// - Returns: 排序数据
    class func sp_getCityLetter() -> [String]?{
        return instance().cityLetterList
    }
    /// 保存用户数据
    private func sp_saveUserData(){
        if let u = self.userModel {
            sp_saveUser(data: u.toJSONString(), key: SP_SAVE_USER_DATA_KEY)
        }else{
            sp_saveUser(data: nil, key: SP_SAVE_USER_DATA_KEY)
        }
    }
    /// 获取用户数据
    private func sp_getUserData(){
        if let u =  sp_getUser(key: SP_SAVE_USER_DATA_KEY) {
            if sp_getString(string: u).count > 0   {
                let s : String = u as! String
                self.userModel = SPUserModel.sp_deserialize(from: s)
                self.userModel?.identity = ""
            }
        }
    }
    /// 上传推送token或第三方推送
    class func sp_uploadPushToken(){
        guard SPAPPManager.instance().userModel != nil else {
            return
        }
        if sp_getString(string: SPAPPManager.instance().clientId).count > 0 {
            let request = SPRequestModel()
            var parm = [String:Any]()
            parm.updateValue("ios", forKey: "type")
          
            parm.updateValue(sp_getString(string: SPAPPManager.instance().clientId), forKey: "clientid")
            request.parm = parm
            SPAppRequest.sp_getPush(requestModel: request) { (code, msg, errorModel) in
                
            }
        }
    }
    /// 是否商家
    ///
    /// - Returns: true or false
    class func sp_isBusiness()->Bool{
        return sp_getString(string: SPAPPManager.instance().userModel?.identity) == SP_IS_ENTERPRISE ? true : false
    }
    class func sp_appVersion(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue("ios", forKey: "app_type")
        parm.updateValue("chunlang", forKey: "platform")
        request.parm = parm
        SPAppRequest.sp_getAPPVersion(requestModel: request) { (code, model, errorModel) in
            if code == SP_Request_Code_Success {
                sp_log(message: "获取版本信息\(sp_getString(string: model?.versions))  下载链接\(sp_getString(string: model?.url))")
                SPUpdateView.sp_show(model: model)
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
// MARK: - 获取数据
fileprivate extension SPAPPManager {
    /// 发送获取省市区请求
    private func sp_sendAreaRequest(){
        self.areaRequest = false
        SPAppRequest.sp_getArea(requestModel: SPRequestModel()) { (code, list, errorModel, totalPage) in
            self.sp_dealGetAreaRequest(code: code, list: list, errorModel: errorModel, totalPage: totalPage)
        }
    }
    /// 处理获取省市区的回调
    ///
    /// - Parameters:
    ///   - code: 错误码
    ///   - list: 数据
    ///   - errorModel: 错误数据
    ///   - totalPage: 总页数
    private func sp_dealGetAreaRequest(code:String,list:[Any]?,errorModel:SPRequestError?,totalPage:Int){
        self.areaRequest = true
        if code == SP_Request_Code_Success {
            self.areaList = list as? [SPAreaModel]
            self.sp_getCityData()
//            SPRealmTool.sp_insert(list: self.areaList!)
        }
        self.sp_dealAreaComplete()
    }
    /// 获取城市数据
    private func sp_getCityData(){
        sp_simpleSQueues {
            if sp_getArrayCount(array: self.areaList) > 0 {
                var cityDic = [String:SPCityGroupModel]()
                for pModel in self.areaList! {
                    for cityModel in pModel.children {
                        cityModel.sp_getFirstLetter()
                        let firstLetter = sp_getString(string: cityModel.firstLetter)
                        let letterValue : SPCityGroupModel? = cityDic[firstLetter]
                        if letterValue != nil {
                            var listArray = letterValue?.list
                            listArray?.append(cityModel)
                            letterValue?.list = listArray
                            cityDic.updateValue(letterValue!, forKey: firstLetter)
                        }else{
                            let groupModel = SPCityGroupModel()
                            groupModel.firstLetter = firstLetter
                            var listArray = [SPAreaModel]()
                            listArray.append(cityModel)
                            groupModel.list = listArray
                            cityDic.updateValue(groupModel, forKey: firstLetter)
                        }
                    }
                }
                let letterKey = cityDic.keys
                let resultArray = letterKey.sorted(by: { (str1, str2 ) -> Bool in
                    return str1 < str2
                })
                var list = [SPCityGroupModel]()
                for letter in resultArray {
                    let letterValue : SPCityGroupModel? = cityDic[letter]
                    if let value = letterValue{
                        list.append(value)
                    }
                }
                self.cityList = list
                self.cityLetterList = resultArray
            }
           
            self.sp_dealAreaComplete()
        }
        
    }
    /// 处理获取省市区和城市是否回调
    private func sp_dealAreaComplete(){
        guard let block = self.areaComplete else {
            return
        }
        if isCity {
            block(self.cityList)
        }else{
            block(self.areaList)
        }
    }
    
 
    
}
// MARK: - notification
extension SPAPPManager {
    /// 添加通知
    fileprivate func sp_addNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(sp_loginNotification), name: NSNotification.Name(SP_LOGIN_NOTIFICATION), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(sp_becomeActive), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sp_enterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(sp_netChangeNotification), name: NSNotification.Name(SP_NETWORK_NOTIFICATION), object: nil)
    }
    @objc fileprivate func sp_becomeActive(){
        sp_log(message: "进入前台")
        self.sp_startTimer()
    }
    @objc fileprivate func sp_enterBackground(){
         sp_log(message: "进入后台")
        self.sp_stopTimer()
    }
    ///  登录通知
    @objc fileprivate func sp_loginNotification(){
        SPAPPManager.sp_uploadPushToken()
        sp_showEnterCode()
    }
    ///  网络发生变化的通知
    @objc fileprivate func sp_netChangeNotification(){
        if SPNetWorkManager.sp_notReachable() == false {
            // 有网络
            if self.areaRequest && sp_getArrayCount(array: self.areaList) <= 0 {
                sp_sendAreaRequest()
            }
            SPAPPManager.sp_getOpenAdvRequesst()
        }
        
    }
    /// 发送定时器运行的通知
    ///
    /// - Parameter timer: 时间间距
    fileprivate func sp_sendTime(timer : Int){
         
        NotificationCenter.default.post(name: NSNotification.Name(SP_TIMERUN_NOTIFICATION), object: ["timer":(  timer <= 0 ? 1 : timer)])
    }
}
extension SPAPPManager{
    
    /// 展示输入邀请码
    fileprivate func sp_showEnterCode(){
        if let referrer = Bool(sp_getString(string: self.userModel?.referrer)) , referrer == false{
            // 还没输入
            SPInvitationCodeView.sp_showView(); 
        }
    }
    
    fileprivate func sp_startTimer(){
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sp_timerRun), userInfo: nil, repeats: true)
            if self.lastTimeInterval == 0 {
                self.lastTimeInterval = Int(Date().timeIntervalSince1970)
            }
            //            RunLoop.current.add(self.timer!, forMode: RunLoopMode.defaultRunLoopMode)
//            RunLoop.current.run()
        }
    }
    @objc fileprivate func sp_timerRun(){
        let currentTime = Date().timeIntervalSince1970
        sp_sendTime(timer: Int(currentTime) - self.lastTimeInterval)
        self.lastTimeInterval = Int(currentTime)
    }
    fileprivate func sp_stopTimer(){
        if self.timer != nil {
            if (self.timer?.isValid)!{
                self.timer?.invalidate()
            }
        }
        self.timer = nil
    }
    /// 是否展示教程页
    ///
    /// - Returns: true 展示 false 不展示
   class func sp_isShowTutorialPage()->Bool {
        var isShow = false
        let version = sp_getString(string: sp_getUser(key: SP_SAVE_TUTORIALPAGE_KEY))
        let newVersion = sp_getVersionCode()
        if sp_getString(string: version).count == 0 {
            isShow = true
        }else if sp_getString(string: newVersion).compare(sp_getString(string: version)) ==   ComparisonResult.orderedDescending  {
            isShow = true
        }
        if isShow {
            sp_saveUser(data: newVersion, key: SP_SAVE_TUTORIALPAGE_KEY)
        }
        return isShow
    }
    /// 获取升级code
    ///
    /// - Returns: code
   class func sp_getVersionCode()->String{
        let infoDic : [String : Any]?  = Bundle.main.infoDictionary
        if let dic = infoDic {
            let versionCode = dic["versionCode"]
            return sp_getString(string:versionCode)
        }else{
            return ""
        }
    }
    ///  展示主页面
    class func sp_showMainVC(){
        let appDelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelete.window {
            window.rootViewController = SPMainVC()
        }
    }
    class func sp_showTutorialPageVC(){
        let appDelete : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        if let window = appDelete.window {
            window.rootViewController = SPTutorialPageVC()
        }
    }
}
//MARK: - 开屏广告
extension SPAPPManager {
    /// 下载图片
    ///
    /// - Parameter urlString: 图片链接
    class func sp_downImg(urlString : String){
        if sp_getString(string: urlString).count == 0 {
            return
        }
        let enString = urlString.MD5String
        let cachePath = sp_getCachePath()
        let filePath =  "\(sp_getString(string: cachePath))/\(sp_getString(string: enString)).jpg"
     
        let isExist : Bool =  FileManager.default.fileExists(atPath: filePath)
        if isExist == false {
            let downloader = ImageDownloader.default
//            downloader.sessionConfiguration = URLSessionConfiguration.default
            downloader.downloadTimeout = 30
            downloader.downloadImage(with: URL(string: sp_getString(string: urlString))!, retrieveImageTask: nil, options: nil, progressBlock: nil) { (image, error, url, data) in
                
                if let imageData = data {
                   try? FileManager.default.removeItem(atPath: sp_getString(string: filePath))
                   try? imageData.write(to: URL(fileURLWithPath: sp_getString(string: filePath)))
                }
            }
        }
    }
    /// 获取开屏的广告
    class func sp_getOpenAdvRequesst(){
        let request = SPRequestModel()
        var parm = [String : Any]()
        parm.updateValue("activityindex", forKey: "tmpl")
        request.parm = parm
        SPAppRequest.sp_getOpenAdv(requestModel: request) { (code , model, errorModel) in
            if code  == SP_Request_Code_Success {
                sp_saveOpenAdv(model: model)
                sp_downImg(urlString: sp_getString(string: model?.imagesrc))
            }
        }
    }
    
    /// 保存获取到开屏广告数据
    ///
    /// - Parameter model: 开屏广告对象
    class func sp_saveOpenAdv(model : SPOpenAdvModel?){
        let oldModel = sp_getOpenAdv()
        if let m = model  {
            sp_saveUser(data: m.toJSONString(), key: SP_SAVE_OPENADV_KEY)
        }else{
            sp_saveUser(data: nil, key: SP_SAVE_OPENADV_KEY)
        }
        if let oldM = oldModel {
            var removePath = ""
            if let nM = model {
                if sp_getString(string: oldM.imagesrc) == sp_getString(string: nM.imagesrc) {
                    
                }else {
                    // 删除旧的链接
                    removePath = "\(sp_getCachePath())/\(sp_getString(string: sp_getString(string: oldM.imagesrc).MD5String)).jpg"
                }
            }else {
                // 直接删除
                 removePath = "\(sp_getCachePath())/\(sp_getString(string: sp_getString(string: oldM.imagesrc).MD5String)).jpg"
            }
            if sp_getString(string: removePath).count > 0 {
               try? FileManager.default.removeItem(atPath: sp_getString(string: removePath))
            }
        }
        
    }
    /// 获取开屏广告Model
    ///
    /// - Returns:
    class func sp_getOpenAdv()->SPOpenAdvModel?{
        if let value = sp_getUser(key: SP_SAVE_OPENADV_KEY) {
            if sp_getString(string: value).count > 0 {
                let jsonString = sp_getString(string: value)
                let model = SPOpenAdvModel.sp_deserialize(from: jsonString)
                return model
            }
        }
        return nil
    }
    
}

