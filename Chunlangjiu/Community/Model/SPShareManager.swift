//
//  SPShareManager.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/7/29.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import UIKit
// 分享平台
enum SP_SharePlatformType : Int {
    case all                    // app 支持的所有分享
    case friend                 // 分享好友 qq好友 微信好友
    case sina                   // 新浪
    case wechateSession         // 微信好友
    case wechatTimeLine         // 微信朋友圈
    case qq                     //  qq
    case qzone                  // qq空间
    case sms                    // 短信
    case umeng                  // 友盟 主要用于注册
}
enum SP_ShareContentType : Int {
    case text                   // 分享文字
    case image                  // 分享图片
    case web                    // 分享网页
    case music                  // 分享音乐链接
    case vedio                  // 分享视频链接
}

/// 分享回调
typealias SPShareComplete = (_ completeModel : SPShareCompleteModel?,_ error : Error?) -> Void
///  分享取消
typealias SPShareDismissComplete = () -> Void
/// 第三方登录回调
typealias SPThridLoginComplete = (_ loginModel : SPThridLoginCompleteModel?,_ error :Error?)->Void
class SPShareManager {
    /// 注册第三方的
    ///
    /// - Parameters:
    ///   - platformType: 平台
    ///   - appKey: key
    ///   - appSecret: serret
    ///   - redirectURL: 地址
    class func sp_registApp(platformType : SP_SharePlatformType ,appKey : String?,appSecret:String?,redirectURL:String?) -> Void{
        switch platformType {
        case .umeng:
            UMSocialManager.default().umSocialAppkey = appKey
        case .wechateSession , .wechatTimeLine:
            UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: appKey, appSecret: appSecret, redirectURL: redirectURL)
        case .qq , .qzone :
            UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: appKey, appSecret: appSecret, redirectURL: redirectURL)
        case .sina :
            UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: appKey, appSecret: appSecret, redirectURL: redirectURL)
        case .all:
            sp_log(message: "all")
        case .friend:
            sp_log(message: "friend")
        case .sms:
            sp_log(message: "sms")
        }
    }
    ///  外部分享数据
    ///
    /// - Parameters:
    ///   - shareDataModel: 分享数据
    ///   - complete: 回调
    ///   - dismissComplete: 取消回调
    class func sp_share(shareDataModel: SPShareDataModel,complete:SPShareComplete?) -> Void{
                UMSocialUIManager.showShareMenuViewInWindow { (platformType, hasable) in
                    sp_log(message: "分享")
                    self.sp_share(platformType: platformType, shareDataModel: shareDataModel, complete: complete)
        }
    }
    ///  分享到第三方某个平台
    ///
    /// - Parameters:
    ///   - platformType: 那个平台
    ///   - shareDataModel: 分享数据
    ///   - complete: 回调
    fileprivate class func sp_share(platformType: UMSocialPlatformType,shareDataModel:SPShareDataModel?,complete:SPShareComplete?) {
        let messageObject = sp_getMessageModel(shareDataModel: shareDataModel)
       
        if platformType == .sina &&  sp_getString(string: shareDataModel?.descr).count > 0 && shareDataModel?.contentType == .web {
            messageObject.text = shareDataModel?.descr
        }
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: shareDataModel?.currentViewController) { (result, error ) in
            let errors : NSError? = error as NSError?
            if let e = errors {
                if e.code == UMSocialPlatformErrorType.shareFailed.rawValue {
                    shareDataModel?.thumbImage = shareDataModel?.placeholderImage
                    self.sp_share(platformType: platformType, shareDataModel: shareDataModel, complete: complete)
                }else{
                    sp_dealShareComplete(result: result, error: e, complete: complete)
                }
            }else{
                sp_dealShareComplete(result: result, error: error, complete: complete)
            }
          
        }
    
    }
    fileprivate class func sp_dealShareComplete(result:Any?,error:Error?,complete:SPShareComplete?){
        if let e = error {
            sp_dealComplete(complete: complete, completeModel: nil, error: e)
        }else{
            if result is UMSocialShareResponse {
                let resp = result as! UMSocialShareResponse
                let completeModel = SPShareCompleteModel()
                completeModel.uid = resp.uid
                completeModel.openId = resp.openid
                completeModel.refreshToken = resp.refreshToken
                completeModel.expiration = resp.expiration
                completeModel.accessToken = resp.accessToken
                completeModel.messgae = resp.message
              sp_dealComplete(complete: complete, completeModel: completeModel, error: nil)
                
            }else{
                sp_dealComplete(complete: complete, completeModel: nil, error: error)
            }
        }
    }
    fileprivate class func sp_dealComplete(complete : SPShareComplete?,completeModel:SPShareCompleteModel?,error:Error?){
        guard let block  = complete else {
            return
        }
        block(completeModel,error)
    }
    /// 获取第三方分享的数据
    ///
    /// - Parameter shareDataModel: 分享数据
    /// - Returns: UMSocialMessageObject
    fileprivate class func sp_getMessageModel(shareDataModel:SPShareDataModel?) -> UMSocialMessageObject{
        let messageObjec = UMSocialMessageObject()
        switch shareDataModel?.contentType {
        case .text?:
            messageObjec.text = shareDataModel?.title
        case .image? :
            if ((shareDataModel?.title) != nil) {
                messageObjec.text = shareDataModel?.title
            }
            messageObjec.shareObject = sp_getShareImage(shareDataModel: shareDataModel)
        case .web? :
            messageObjec.shareObject = sp_getShareWebpage(shareDataModel: shareDataModel)
        case .music? :
            messageObjec.shareObject = sp_getShareMusic(shareDataModel: shareDataModel)
        case .vedio? :
            messageObjec.shareObject = sp_getShareVideo(shareDataModel: shareDataModel)
        default:
            sp_log(message: "defaule")
        }
        return messageObjec
    }
    /// 获取分享图片的object
    ///
    /// - Parameter shareDataModel: 分享数据
    /// - Returns: UMShareImageObject
    fileprivate class func sp_getShareImage(shareDataModel:SPShareDataModel?) -> UMShareImageObject{
        let shareObject = UMShareImageObject()
        shareObject.thumbImage = shareDataModel?.thumbImage
        shareObject.shareImage = shareDataModel?.shareData
        return shareObject
    }
    /// 获取分享网页的object
    ///
    /// - Parameter shareDataModel: 分享数据
    /// - Returns: UMShareWebpageObject
    fileprivate class func sp_getShareWebpage(shareDataModel:SPShareDataModel?) -> UMShareWebpageObject{
        let shareObjec = UMShareWebpageObject.shareObject(withTitle: shareDataModel?.title, descr: shareDataModel?.descr, thumImage: shareDataModel?.thumbImage)
        if shareDataModel?.shareData is String{
            shareObjec?.webpageUrl = shareDataModel?.shareData as! String
        }
//        if !shareObjec?.webpageUrl || shareObjec?.webpageUrl.count == 0 {
////            shareObjec?.webpageUrl =
//        }
        return shareObjec!
    }
    /// 获取分享音乐的object
    ///
    /// - Parameter shareDataModel: 分享数据
    /// - Returns: UMShareMusicObject
    fileprivate class func sp_getShareMusic(shareDataModel:SPShareDataModel?) -> UMShareMusicObject {
        let shareObject = UMShareMusicObject.shareObject(withTitle: shareDataModel?.title, descr: shareDataModel?.descr, thumImage: shareDataModel?.thumbImage)
        if shareDataModel?.shareData is String {
            shareObject?.musicUrl = shareDataModel?.shareData as! String
        }
        return shareObject!
    }
    /// 获取分享视频的object
    ///
    /// - Parameter shareDataModel: 分享数据
    /// - Returns: UMShareVideoObject
    fileprivate class func sp_getShareVideo(shareDataModel:SPShareDataModel?) -> UMShareVideoObject{
        let shareObject = UMShareVideoObject.shareObject(withTitle: shareDataModel?.title, descr: shareDataModel?.descr, thumImage: shareDataModel?.thumbImage)
        if shareDataModel?.shareData is String {
            shareObject?.videoUrl = shareDataModel?.shareData as! String
        }
        return shareObject!
    }
    /// 第三方登录
    ///
    /// - Parameters:
    ///   - viewController: 当前控制器
    ///   - shareType: 登录平台
    ///   - complete: 回调
    class func sp_thridLogin(viewController : UIViewController,shareType : SP_SharePlatformType,complete : SPThridLoginComplete?){
        var platformType = UMSocialPlatformType.wechatSession
        if shareType == .qq {
            platformType = .QQ
        }else if shareType == .wechateSession {
            platformType = .wechatSession
        }else if shareType == .sina {
            platformType = .sina
        }
        UMSocialManager.default()?.auth(with: platformType, currentViewController: viewController, completion: { (result, error) in
            sp_log(message: error);
            if error != nil {
                if let block = complete {
                    block(nil,error)
                }
            }else {
                if let model : UMSocialAuthResponse = result as? UMSocialAuthResponse {
                    let loginModel = SPThridLoginCompleteModel()
                    loginModel.uid = model.uid
                    loginModel.openid = model.openid
                    loginModel.refreshToken = model.refreshToken
                    loginModel.expiration = model.expiration
                    loginModel.accessToken = model.accessToken
                    loginModel.unionId = model.unionId
                    loginModel.usid = model.usid
                    loginModel.originalResponse = model.originalResponse
                    sp_log(message: model.originalResponse)
                    if let block = complete {
                        block(loginModel,error)
                    }
                }
            }
        })
    }
    /// 第三方回调
    ///
    /// - Parameter url: 第三方返回的链接
    /// - Returns: 是否成功
    class func sp_handleOpen(url:URL)->Bool{
        if let isSuccess = UMSocialManager.default()?.handleOpen(url) {
            return isSuccess
        }
        return false 
    }
    class func sp_isInstall(type : SP_SharePlatformType)->Bool{
        var isInstall = true
        if type == .sina {
            if let result = UMSocialManager.default()?.isInstall(UMSocialPlatformType.sina){
                isInstall = result
            }
        }else if type == .qq{
            if let result = UMSocialManager.default()?.isInstall(UMSocialPlatformType.QQ){
                isInstall = result
            }
        }else if type == .wechateSession{
            if let result = UMSocialManager.default()?.isInstall(UMSocialPlatformType.wechatSession){
                isInstall = result
            }
        }
        return isInstall
    }
}


class SPShareDataModel : NSObject {
    var title : String = ""
    var descr : String = ""
    var thumbImage : Any?
    var shareData : Any?
    var platformType : SP_SharePlatformType = .all
    var contentType : SP_ShareContentType = .web
    weak var currentViewController : UIViewController?
    var placeholderImage : UIImage?
}
class SPShareCompleteModel : NSObject {
    var uid : String?
    var openId : String?
    var refreshToken : String?
    var expiration : Date?
    var accessToken : String?
    var originalResponse : Any?
    var messgae : String?
    var platformType : SP_SharePlatformType?
    var name : String?
    var iconUrl : String?
    var gender : String?
}

class SPThridLoginCompleteModel : NSObject {
    var uid : String?
    var openid : String?
    var refreshToken : String?
    var expiration : Date?
    var accessToken : String?
    var unionId : String?
    var usid : String?
    var originalResponse : Any?
    var platformType : SP_SharePlatformType?
}
