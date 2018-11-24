//
//  SPAuthorizatio.swift
//  Chunlangjiu
//
//  Created by 黄树鹏 on 2018/11/8.
//  Copyright © 2018年 Chunlang. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

typealias AuthorizedBlock = (_ auth : Bool) -> Void

// 权限表
class SPAuthorizatio{
    // 相机权限
    class func isRightCamera(authoriedBlock : AuthorizedBlock?) -> Void {
        guard let authoriedComplete = authoriedBlock  else {
            return
        }
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .notDetermined {
            // 第一次授权
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { (grant) in
                authoriedComplete(grant)
            }
        }else if authStatus == .authorized{
            authoriedComplete(true)
        }else{
            authoriedComplete(false)
        }
    }
    
    // 相册权限
    class func isRightPhoto(authoriedBlock :  AuthorizedBlock?) -> Void {
        guard let authoriedComplete = authoriedBlock  else {
            return
        }
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) in
                if status == .authorized{
                    authoriedComplete(true)
                }else{
                    authoriedComplete(false)
                }
            }
        }else if (authStatus == .authorized){
            authoriedComplete(true)
        }else{
            authoriedComplete(false)
        }
    }
}
